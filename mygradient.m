function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%

dx = imfilter(I, [-1 0 1], 'replicate');
dy = imfilter(I, [-1 0 1]', 'replicate');

mag = sqrt(dx.^2 + dy.^2);
ori = atan2(dy, dx);

