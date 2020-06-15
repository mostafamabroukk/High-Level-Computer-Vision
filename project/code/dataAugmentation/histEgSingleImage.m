function [imgEq] = histEgSingleImage(img)
%HISTEGSINGLEIMAGE Summary of this function goes here
%   takes an RGB image 'img' and performs histogram equalization on it by
%   converting it to HSV and performing there histogram equalization only
%   to the H channel
    imgHSV = rgb2hsv(img);
    Vchannel = imgHSV(:,:,3);
    imgEq = hsv2rgb(cat(3, imgHSV(:,:,1), imgHSV(:,:,2), histeq(Vchannel,256)));
end

