function [f]= getSIFTFeatures(image)
%convert images to greyscale
Im = single(rgb2gray(image));
f = vl_sift(Im);
end