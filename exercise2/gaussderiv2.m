%
% return 2nd order Gaussian derivatives of the image
% 
% note: use functions gauss.m and gaussdx.m from exercise 1
%

function [imgDxx, imgDxy, imgDyy] = gaussderiv2(img,sigma)
  
  assert(length(size(img)) == 2, 'expecting 2d grayscale image');

  D = gaussdx(sigma);

  [imgDx,imgDy]=gaussderiv(img,sigma);
  
  % we only smooth once
  imgDxx = conv2(imgDx,D,'same');
  imgDxy= conv2(imgDx,D','same');  
  imgDyy= conv2(imgDy,D','same');
end




