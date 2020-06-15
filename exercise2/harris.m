% px - vector of x coordinates of interest points
% py - vector oy y coordinates of interest points
% M - value of the cornerness function computed for every image pixel
%


function [px py M] = harris(img, sigma, thresh)
 
alpha = 0.05;
sigmaCoef = 1.5;

[imgDy, imgDx] = gaussderiv(img, sigma);

%structure tensor elements
imgDxx = imgDx .* imgDx;
imgDyy = imgDy .* imgDy;
imgDxy = imgDx .* imgDy;

%smoothing of structure tensor
sigmaT = sigmaCoef * sigma;
dimT = ceil(6 * sigmaT);
if ( mod(dimT, 2) == 0)
  dimT = dimT + 1;  
end

gaussT = fspecial('gaussian', [dimT, dimT], sigmaT);
imgDxxG = sigma^2 * conv2(imgDxx, gaussT, 'same');
imgDyyG = sigma^2 * conv2(imgDyy, gaussT, 'same');
imgDxyG = sigma^2 * conv2(imgDxy, gaussT, 'same');

% det & trace of smoothed structure tensor
detMatrix = (imgDxxG .* imgDyyG - imgDxyG .^2);
traceMatrix = (imgDxxG + imgDyyG);

% harris 'cornerness'
M = detMatrix - alpha*(traceMatrix .^2);
hMaxMatrix = nonmaxsup2d(M);

[py, px] = find(hMaxMatrix > thresh);


  % ... 
