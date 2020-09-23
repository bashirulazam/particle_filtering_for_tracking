clear all
close all
clc

vr = VideoReader('data/Video_Multi.mp4');
im1 = imresize(rgb2gray(read(vr,1)),1/4);
N_frame = floor(vr.Duration * vr.FrameRate);
imshow(uint8(im1));
[circles,radii] = imfindcircles(im1,[10 30]);
 c1 = round(circles(1,1));
r1 = round(circles(1,2));
template = im1(r1-20:r1+20,c1-20:c1+20);
figure
imshow(uint8(template));


NextFrame = im1;
height = size(NextFrame,1);
width = size(NextFrame,2);
N = 500;
 
S = [randi(width,1,N) ; randi(height,1,N); zeros(1,N); zeros(1,N)] ;
S = Myupdate(S);
w(1,:) = ones(1,N)/N;
alpha(1,:) = find_alpha(NextFrame, template, S);
for i = 2:N_frame
    w(i,:) = alpha(i-1,:)/sum(alpha(i-1,:));
    f(i,:) = cumsum(w(i,:),2);
    T = rand(1,N);
    [~,Ind] = histc(T,f(i,:));
    S = S(:,Ind + 1);
    NextFrame = imresize(rgb2gray(read(vr,i)),1/4);
    alpha(i,:) = find_alpha(NextFrame, template, S);
    S = Myupdate(S);
    figure
    image(imresize(read(vr,i),1/4));
    hold on 
    plot(S(1,:),S(2,:),'.')
    hold off
    drawnow
    saveas(gca,strcat('Results/Single_Resize/Track_',num2str(i),'.jpg'));
    close
    figure
    x = S(1,:);
    y = S(2,:);
    z = w(i,:);
    scatter3(S(1,:),S(2,:),w(i,:))
    axis([1 width 1 height 0 1])
    xlabel('Width of the image');
    ylabel('Height of the image');
    zlabel('Posterior Estimate of Object position');
    saveas(gca,strcat('Plots/Track_Single',num2str(i),'.jpg'));
    close
end