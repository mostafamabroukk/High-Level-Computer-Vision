function [im_rot] = rotateImages(images, deg)
% takes an cell array of images and applies rotation to it
% returns a cell array if the rotated images
% 'deg' = vector of doubles specifiing the rotation angle for each image in
% degrees, should be in [-20,20]
    im_rot = cellfun(@(i,deg) rotateAndCropImage(i,deg), images, num2cell(deg), 'un', 0);
end

