function im_mir = leftRightFlipping(images)
% takes an cell array of images and applies left-right flipping to it
% returns a cell array if the flipped images
    im_mir=cellfun(@fliplr, images,'un',0); % the mirrored images
end

