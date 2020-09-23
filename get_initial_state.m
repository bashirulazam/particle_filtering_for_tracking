clear all
close all
clc

filename = strcat('data/Images_coin/Image',num2str(1),'.jpg');
im = imread(filename);
figure
imshow(im2bw(im));
[centers,radii] = imfindcircles(im, [40 70],'Sensitivity',0.95);
viscircles(centers,radii,'Color','b')
