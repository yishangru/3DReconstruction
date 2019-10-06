function SfMConstruction(imagePath,intrisicPath, saveFilename)
resDir = 'result/';
% get intrinsic matrix
f=fopen(intrisicPath);
data=textscan(f,'%f %f %f');
for i=1:3
    intrinOriginal(:,i)=data{i};
end
imageHolder = cell(1, size(imagePath, 2));
intrinsicNormal = intrinOriginal;
for i = 1:size(imagePath, 2)
    imageHolder{i} = imread(imagePath{i});
    if size(imageHolder{i}, 2) > 1200
        imageHolder{i} = imresize(imageHolder{i}, 1200/size(imageHolder{i}, 2));
        intrinsicNormal = intrinOriginal*1200/size(imageHolder{i},2);
    end
end
intrinsic = intrinsicNormal(1:3,:)';

%% match features with SIFT for first image
rotation = eye(3);
translation = zeros(1,3);

pointToShow = [];
pointColor = [];
for i = 2:size(imagePath, 2)
    disp(['For Image ', int2str(i-1), '-', int2str(i)])
    img0 = imageHolder{i-1};
    img1 = imageHolder{i};
    f1= getSIFTFeatures(img0, -1);
    [matchPoint1, matchPoint2] = getMatches(f1, img0, img1);
    %% Estimate F R T from matchPoint
    [F, inliers] = RANSAC(matchPoint1, matchPoint2);
    inlierPoints1 = matchPoint1(inliers, :);
    inlierPoints2 = matchPoint2(inliers, :);
    % use inlier and F to estimate R and t
    [R, T] = RotationAndTranslation(F, intrinsic, inlierPoints1, inlierPoints2); % estimate R and t
    camExtrinsic1 = [rotation; translation]*intrinsic; % use the first as original
    camExtrinsic2 = [rotation*R; translation - T]*intrinsic; % relative position
    rotation = rotation*R;
    translation = translation - T;

    %% Triangulation View with dense matchPoint
    f1 = getSIFTFeatures(img0, 10);
    [matchPoint1, matchPoint2] = getMatches(f1, img0, img1);
    point3Dreconstruct = TriangulationImage(matchPoint1, matchPoint2, camExtrinsic1, camExtrinsic2);
    cls = reshape(img0, [size(img0, 1) * size(img0, 2), 3]);
    pointToShow = [pointToShow; point3Dreconstruct];
    colorIdx = sub2ind([size(img0, 1), size(img0, 2)], round(matchPoint1(:,2)),round(matchPoint1(:, 1)));
    pointColor = [pointColor; cls(colorIdx, :)];
end

disp('Show 3D point in spatial')
ptCloud = pointCloud(pointToShow, 'Color', pointColor);
pcwrite(ptCloud,[resDir,saveFilename],'PLYFormat','ascii');
disp(['saving ',resDir,saveFilename,'.ply']);
figure
pcshow(ptCloud, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', 'MarkerSize', 45);
end