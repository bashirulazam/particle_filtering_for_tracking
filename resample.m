% Resample the particles
function particles = resample(particles, a)
num_particle = size(particles,2);
% Calculating Cumulative Distribution
w = a./sum(a); % The weight
f = cumsum(w,2); % cdf

% Generating Random Numbers
T = rand(1, num_particle);

% Resampling
[~, I] = histc(T, f);
particles = particles(:, I+1);
