clear all
close all
clc

N_frame = 2000;

for i = [3, 8, 135]
    currFrame = imread(strcat('Results/Multi_Resize/Track_',num2str(i),'.jpg'));
    imwrite(currFrame(55:580,120:790,:),strcat('Results/Multi_',num2str(i),'.jpg'));
end




