function [R, T] = RotationAndTranslation(F, intrinsic,inliers1, inliers2)
E = intrinsic * F * intrinsic';
%% decompose E
[U, D, V] = svd(E);
D(1,1) = 1;
D(2,2) = 1;
D(3,3) = 0;
E = U * D * V';
[U, ~, V] = svd(E);
W=[0 -1 0; 1 0 0; 0 0 1];
Z = [0 1 0; -1 0 0; 0 0 0]; % ³õµÈÐÐ±ä»»
CameraMatrixBase1 = U * W * V';
CameraMatrixBase2 = U * W' * V';

if det(CameraMatrixBase1) < 0
    CameraMatrixBase1 = -CameraMatrixBase1;
end
if det(CameraMatrixBase2) < 0
    CameraMatrixBase2 = -CameraMatrixBase2;
end

T = -[U(1,3) U(2,3) U(3,3)];
%% choose solution
negativeNumber = zeros(1, 4);
nInliers=size(inliers1, 1);
camProjectMatrix1 = ([eye(3); [0 0 0]]*intrinsic)';
M1 = camProjectMatrix1(1:3, 1:3);
c1 = -M1 \ camProjectMatrix1(:,4);

for i = 1:4  % four solution
    T=-T;
    R=CameraMatrixBase1';
    if i>2
        R=CameraMatrixBase2';
    end
    camProjectMatrix2 = ([R; T]*intrinsic)';
    M2 = camProjectMatrix2(1:3, 1:3);
    c2 = -M2 \ camProjectMatrix2(:,4);
    
    for j = 1:nInliers
        a1 = M1 \ [inliers1(j, :), 1]';
        a2 = M2 \ [inliers2(j, :), 1]';
        A = [a1, -a2];
        alpha = (A' * A) \ A' * (c2 - c1);
        p = (c1 + alpha(1) * a1 + c2 + alpha(2) * a2) / 2;
        m1(j, :) = p';
    end
    
    m2 = bsxfun(@plus, m1 * R, T);
    negativeNumber(i) = sum((m1(:,3) < 0) | (m2(:,3) < 0)); % arbitary smaller then 0
end

[~, idx] = min(negativeNumber);
if idx<3
    R=CameraMatrixBase1';
end
if idx==2 || idx ==4
    T =-T;
end
end