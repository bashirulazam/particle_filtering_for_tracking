function [centers] = Mydetect(centers_pred,image_index)

filename = strcat('data/Images_coin/Image',num2str(image_index),'.jpg');
im = imread(filename);
figure
imshow(im2bw(im));
[centers,radii] = imfindcircles(im, [40 70],'Sensitivity',0.95);
viscircles(centers,radii,'Color','b')
centers = centers(3,:);
dist = [centers - centers_pred(1:2,1)];