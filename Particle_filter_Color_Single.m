% Particle filtering 
%% Read video
vid = VideoReader('data/multi_1.mp4');
img_size = [vid.Width vid.Height];
num_frames = floor(vid.Duration * vid.FrameRate);

%% Initialize particles 
% particles: rows
           % cols 
           % vr
           % vc
num_particle = 2000;
particle_rows = randi(img_size(2), [num_particle,1]);
particle_cols = randi(img_size(1), [num_particle,1]);
particles = [particle_rows particle_cols zeros(num_particle,2)]';

%% Some initialization
phi = [1 0 1 0;
       0 1 0 1;
       0 0 1 0;
       0 0 0 1];
   
Q = [16 0 0 0;
     0 16 0 0;
     0  0 4 0;
     0  0 0 4];
 
 % Try to find the pixels in this color:
 img_1 = read(vid,1);
 imshow(img_1);
 color_tg = [30; 40; 60]; % An approx value found by hand
 % stapler : [200; 100; 120]
 % coin: [200; 190; 160]
 % stone: [30; 40; 60]
 color_std = 30; % To be tuned
 
%% Output video
outputVideo = VideoWriter(fullfile('Tracking_Single_Color.mp4'));
outputVideo.FrameRate = floor(vid.FrameRate);
open(outputVideo)
 
%% Recursive filtering
for i = 1 : num_frames
    img_i = read(vid, i);
    
    % Update the particles
    particles = phi * particles; % To the next time instant 
    particles(1:2,:) = particles(1:2,:) + Q(1,1) * randn(2, num_particle);
    particles(3:4,:) = particles(3:4,:) + Q(3,3) * randn(2, num_particle);
    particles = round(particles);
    
    % Calculate the alpha
    a = alpha_prob(color_tg, color_std, particles, img_i);
    
    % Resample the particles 
    particles = resample(particles, a);
    
    % Plotting the particles 
    figure(1)
    image(img_i)
    
    hold on
    plot(particles(2,:), particles(1,:), '.')
    hold off
    
    drawnow
    
    out = insertMarker(img_i,[particles(2,:)',particles(1,:)'],'+');
    writeVideo(outputVideo,out)
end
close(outputVideo)