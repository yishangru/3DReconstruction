function [f] = getSIFTFeatures(image, binSize)
%convert images to greyscale
Im = single(rgb2gray(image));
if binSize == -1
    f = vl_sift(Im); % use normal sift feature extraction
else
    f = vl_dsift(Im, 'Size', binSize); % use dense sift feature extraction
end