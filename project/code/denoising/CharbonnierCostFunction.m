function [res] = CharbonnierCostFunction(img, lambda)
% computes the Perona-Malik cost function (a matrix with the size of the 
% image) for an given image 'img' and a parameter 'lambda'
% 'lambda' is a contrast parameter: smaller lambda means more edges
    [Gmag,Gdir] = imgradient(img);
    res = 1 ./ sqrt(1 + (Gmag.^2 / lambda^2));
end

