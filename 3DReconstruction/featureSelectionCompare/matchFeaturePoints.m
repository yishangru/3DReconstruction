function [matchedPoints1,matchedPoints2]=matchFeaturePoints(I1,I2,thresh)
imagePoints1 = detectMinEigenFeatures(rgb2gray(I1), 'MinQuality', thresh);
imagePoints1 = imagePoints1.Location;
% change to sift to see the result image
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);
initialize(tracker, imagePoints1, I1);
[imagePoints2, validIdx] = step(tracker, I2);
matchedPoints1 = imagePoints1(validIdx, :);
matchedPoints2 = imagePoints2(validIdx, :);
end