function pointIn3d = TriangulationImage(matchedPoint1, matchedPoint2, extrinsicMat1, extrinsicMat2)
pointIn2d(:,:,1)=matchedPoint1;
pointIn2d(:,:,2)=matchedPoint2;

camHolder(:,:,1)=extrinsicMat1;
camHolder(:,:,2)=extrinsicMat2;

pointIn3d = zeros(size(pointIn2d, 1), 3, 'like', pointIn2d);  % three dimension
for i = 1:size(pointIn2d, 1)
    pairs=squeeze(pointIn2d(i, :, :))';
    A = zeros(4, 4);
    for j = 1:2
        P = camHolder(:,:,j)';
        A(2*j-1,:)=pairs(j, 1)*P(3,:)-P(1,:);
        A(2*j,:)=pairs(j, 2)*P(3,:)-P(2,:);
    end
    [~,~,V] = svd(A);
    X = V(:, end);
    X = X/X(end);
    pointIn3d(i, :) = X(1:3)';
end

