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
particles2 = [particle_rows particle_cols zeros(num_particle,2)]';

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
 color_tg2 = [200; 100; 120];
 % stapler : [200; 100; 120]
 % coin: [200; 190; 160]
 % stone: [30; 40; 60]
 color_std = 30; % To be tuned
 
%% Output video
outputVideo = VideoWriter('Tracking_Multi_Color.mp4');
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
    
    particles2 = phi * particles2; % To the next time instant 
    particles2(1:2,:) = particles2(1:2,:) + Q(1,1) * randn(2, num_particle);
    particles2(3:4,:) = particles2(3:4,:) + Q(3,3) * randn(2, num_particle);
    particles2 = round(particles2);
    
    % Calculate the alpha
    a1 = alpha_prob(color_tg, color_std, particles, img_i);
    a2 = alpha_prob(color_tg2, color_std, particles2, img_i);
    
    % Resample the particles 
    particles = resample(particles, a1);
    particles2 = resample(particles2, a2);
    
    % Plotting the particles 
    figure(1)
    image(img_i)
    
    hold on
    plot(particles(2,:), particles(1,:), '.')
    plot(particles2(2,:), particles2(1,:), '.')
    hold off
    
    drawnow
    
    %particles_all = [particles(2,:)' particles(1,:)' ;particles2(2,:)' particles2(1,:)'];
    out = insertMarker(img_i,[particles(2,:); particles(1,:)]','x', 'color','blue');
    out2 = insertMarker(out,[particles2(2,:); particles2(1,:)]','x','color','green');
    writeVideo(outputVideo,out2)
end
close(outputVideo)