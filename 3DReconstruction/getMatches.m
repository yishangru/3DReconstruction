function [matchPoint1, matchPoint2] = getMatches(f1, img0, img1)
% f has a column for each frame, column 1 2 as center, 3, as scale, 4 as orientation
%[matches, scores] = vl_ubcmatch(d1, d2, threshold); Bad matching
imagePoint1 = [f1(1, :); f1(2, :)]';
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);
initialize(tracker, imagePoint1, img0);
[imagePoint2, validIdx] = step(tracker, img1);
matchPoint1 = imagePoint1(validIdx, :);
matchPoint2 = imagePoint2(validIdx, :);
end
