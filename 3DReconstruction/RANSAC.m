function [f,bestInliers] = RANSAC(MatchPoint1, MatchPoint2)
pointNumber = size(MatchPoint1, 1); % get number of points
% extend matchpoint
pointsImage1=[MatchPoint1'; ones(1, pointNumber)];% each row as x, y
pointsImage2=[MatchPoint2'; ones(1, pointNumber)];

threshold = 0.02;
iteration = 20000;
bestDist = realmax('double');

% use iteration to find a proper fundamental matrix
disp('Sample for Fundamental Matrix')
for i=1:iteration
    % random select 8 points for F matrix estimation
    samplePoint = randperm(pointNumber, 8);
    f = FundamentalCal(pointsImage1(:, samplePoint), pointsImage2(:, samplePoint));
    
    % use geometric error for F matrix
    error1 = ((pointsImage1' * f)').*pointsImage2;
    error2 =  pointsImage1.*(f*pointsImage2);
    d = sum(error1, 1) .^ 2 + sum(error2, 1).^2;

    % find inliers
    inliers = coder.nullcopy(false(1, pointNumber));
    inliers(d<=threshold)=true; % for each match point, count inliner number
    InlierNum=sum(inliers);
    
    % RANSAC metric
    Dist = cast(sum(d(inliers)),'double') + threshold*(pointNumber - InlierNum);
    if bestDist > Dist
      bestDist = Dist;
      bestInliers = inliers;
    end
end

disp('End Sample for Fundamental Matrix')

% eliminate the outliers and recalculate fundamental matrix
f = FundamentalCal(pointsImage1(:, bestInliers), pointsImage2(:, bestInliers));
end

function f = FundamentalCal(pointsImage1, pointsImage2)
% In order to deal with image dimensional issue (width, height)
num = size(pointsImage1, 2);
[pointsImage1, tran1] = vision.internal.normalizePoints(pointsImage1, 2, 'double');
[pointsImage2, tran2] = vision.internal.normalizePoints(pointsImage2, 2, 'double');

% extend the fundamental matrix
fExtend = coder.nullcopy(zeros(num, 9, 'double'));
fExtend(:,1)=(pointsImage1(1,:).*pointsImage2(1,:))';
fExtend(:,2)=(pointsImage1(2,:).*pointsImage2(1,:))';
fExtend(:,3)=pointsImage2(1,:)';
fExtend(:,4)=(pointsImage1(1,:).*pointsImage2(2,:))';
fExtend(:,5)=(pointsImage1(2,:).*pointsImage2(2,:))';
fExtend(:,6)=pointsImage2(2,:)';
fExtend(:,7)=pointsImage1(1,:)';
fExtend(:,8)=pointsImage1(2,:)';
fExtend(:,9)=1;

% set last eigen value as 0
[~, ~, Vf] = svd(fExtend, 0);
f = reshape(Vf(:, end), 3, 3)'; % reshape f to 3*3
[u, s, v] = svd(f);
s(end) = 0;
f = u * s * v';

% restore f to the unnormalized one
f = tran2' * f * tran1;
f = f / norm(f);
if f(end) < 0  % this is f(3,3)
  f = -f;
end
end