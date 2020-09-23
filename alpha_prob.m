function a = alpha_prob(color_tg, color_std, particles, img)

num_particle = size(particles,2);
a = zeros(1,num_particle);
particles = round(particles);
size_img = size(img);
img_size = size_img(1:2);  % 1920 1080

for i = 1 : num_particle
    
    m = particles(1,i); % rows
    n = particles(2,i); % cols
    
    if  (m >= 1 && m <= img_size(1)) && (n >= 1 && n <= img_size(2)) % eliminate negative coordinates 
        rgb = double(img(m,n,:));
        d1 = rgb(1,1,1) - color_tg(1,1);
        d2 = rgb(1,1,2) - color_tg(2,1);
        d3 = rgb(1,1,3) - color_tg(3,1);
        d = sqrt(d1^2 + d2^2 + d3^2);
        a(i) =  1/sqrt(2 * pi * color_std) * exp(-(d^2/(2*(color_std.^2))));
    else
        %a(i) = -Inf;
        a(i) = 0;
    end
end
