%test
img0 = imread('6.jpg');
img1 = imread('7.jpg');
ms=size(img0,2);
ds=1200;
if ms>ds
    img0=imresize(img0,ds/ms);
    img1=imresize(img1,ds/ms);
    col=col*ds/ms;
end

[f1, d1] = getSIFTFeatures(img0);
[matchPoint1, matchPoint2] = getMatches(f1, img0, img1);
figure(1);
ax = axes;
selected = randperm(size(matchPoint1, 1), 30);
showMatchedFeatures(img0, img1, matchPoint1(selected, :), matchPoint2(selected, :), 'montage', 'Parent',ax);
title('Feature Matching Using SIFT')
legend(ax, 'Matched points 1','Matched points 2');
print(1, '-dpng','-r400', 'SIFT_feature') 

[mp1, mp2] = matchFeaturePoints(img0,img1,0.01);
figure(2)
ax = axes;
selected = randperm(size(mp1, 1), 30);
showMatchedFeatures(img0, img1, mp1(selected, :), mp2(selected, :), 'montage','Parent',ax);
title('Feature Matching Using MinEigenFeatures')
legend(ax, 'Matched points 1','Matched points 2');
print(2, '-dpng','-r400', 'MinEigen_feature') 