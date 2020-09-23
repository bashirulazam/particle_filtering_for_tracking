clear all
close all
clc

vidObj = VideoWriter('Post_Estimation.avi');
open(vidObj);

N_frame = 1500;

for i = 2:N_frame
    currFrame = imread(strcat('Plots/Track_',num2str(i),'.jpg'));
    
    %writeVideo(vidObj,currFrame(55:580,120:790,:));
    writeVideo(vidObj,currFrame);

end

close(vidObj);


