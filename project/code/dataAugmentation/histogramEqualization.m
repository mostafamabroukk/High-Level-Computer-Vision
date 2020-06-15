function [img_eq] = histogramEqualization(images)
% takes an cell array of RGB images and applies histogram equalization to
% them
    img_eq = cellfun(@histEgSingleImage, images,'un',0); % the equalized images
end

