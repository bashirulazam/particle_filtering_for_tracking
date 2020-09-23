function alpha = find_alpha(NextFrame,template,S)
N = size(S,2);
ext = 50;
NextFrame = padarray(NextFrame, [ext ext],'both');
height = size(NextFrame,1);
width = size(NextFrame,2);
for i = 1:N
    x = S(1,i)+ ext;
    y = S(2,i) + ext;
    search_x = x - ext:x+ext;
    search_y = y - ext:y+ext;
    search_x = search_x(search_x > 1 & search_x < width );
    search_y = search_y(search_y > 1 & search_y < height);
    if length(search_x) < size(template,2) || length (search_y) < size(template,1)
        alpha(i) = eps;
    else
        c = normxcorr2(template,NextFrame(search_y,search_x));
        alpha(i) = max(c(:));
    end
end