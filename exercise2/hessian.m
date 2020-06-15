% px - vector of x coordinates of interest points
% py - vector oy y coordinates of interest points
% H - value of Hessian determinant computed for every image pixel
%
% note: use the functions gaussderiv2.m and nonmaxsup2d.m 

function [px, py, H] = hessian(img, sigma, thresh)
   [imgDxx, imgDxy, imgDyy] = gaussderiv2(img,sigma);
   
   % compute the Hessian determinant for each pixel in store the values in H
   H = sigma^4 * (imgDxx .* imgDyy - imgDxy.^2);
   
   imgMax=nonmaxsup2d(H);
   
   [py, px]= find(imgMax > thresh);
end