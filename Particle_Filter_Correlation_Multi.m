clear all
close all
clc

vr = VideoReader('data/Video_multi.mp4');
im1 = imresize(rgb2gray(read(vr,1)),1/4);
imshow(uint8(im1));
% [circles,radii] = imfindcircles(im1,[20 40]);
% c1 = round(circles(1,1));
% r1 = round(circles(1,2));
template1 = im1(33:72,153:196);
template2 = im1(93:167,31:146);
template3 = im1(182:255,173:250);
figure
imshow(uint8(template1));
figure
imshow(uint8(template2));
figure
imshow(uint8(template3));

NextFrame = im1;
height = size(NextFrame,1);
width = size(NextFrame,2);
N = 100;
 
S1 = [randi(width,1,N) ; randi(height,1,N); zeros(1,N); zeros(1,N)];
S2 = [randi(width,1,N) ; randi(height,1,N); zeros(1,N); zeros(1,N)];
S3 = [randi(width,1,N) ; randi(height,1,N); zeros(1,N); zeros(1,N)];
S1 = Myupdate(S1);
S2 = Myupdate(S2);
S3 = Myupdate(S3);
w1(1,:) = ones(1,N)/N;
w2(1,:) = ones(1,N)/N;
w3(1,:) = ones(1,N)/N;
alpha1(1,:) = find_alpha(NextFrame, template1, S1);
alpha2(1,:) = find_alpha(NextFrame, template2, S2);
alpha3(1,:) = find_alpha(NextFrame, template3, S3);

for i = 2:300
    S1 = Myresample(alpha1(i-1,:),S1);
    S2 = Myresample(alpha2(i-1,:),S2);
    S3 = Myresample(alpha3(i-1,:),S3);
    NextFrame = imresize(rgb2gray(read(vr,i)),1/4);
    alpha1(i,:) = find_alpha(NextFrame, template1, S1);
    alpha2(i,:) = find_alpha(NextFrame, template2, S2);
    alpha3(i,:) = find_alpha(NextFrame, template3, S3);
    
    S1 = Myupdate(S1);
    S2 = Myupdate(S2);
    S3 = Myupdate(S3);
    figure
    image(imresize(read(vr,i),1/4));
    hold on 
    plot(S1(2,:),S1(1,:),'.')
    hold on 
    plot(S2(2,:),S2(1,:),'x')
    plot(S3(2,:),S3(1,:),'o')
    hold off
    drawnow
    saveas(gca,strcat('Results/Track_',num2str(i),'.jpg'));
    close
end