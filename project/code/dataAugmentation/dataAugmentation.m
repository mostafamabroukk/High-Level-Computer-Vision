function [] = dataAugmentation(imgPath, imgType)
% This function takes a directory of images and applies some augmentation
% techniques to them
    
    % first load the images from the directory
    imagesMeta  = dir([imgPath imgType]);
    images = cell(length(imagesMeta),1);
    for idx = 1:length(images)
        images{idx} = imread([imgPath imagesMeta(idx).name]);
    end
    
    % apply left-right flipping
    % im_mir=leftRightFlipping(images);

    N = length(images);
    
    % Our images are 640 x 480
    % use random crops that contain 90 percent of the image
    % cropping window in [0,20] x [30,60]
    percentage = 0.9;
    height = size(images{1},1)*percentage*ones(N,1);
    width = size(images{1},2)*percentage*ones(N,1);
    tl_x = int16(rand(N,1)*20);
    % offset in x-direction s.t. we keep the steering wheel ()at least
    % partially in the image
    tl_y = int16(rand(N,1)*30)+30;
    im_cropped = cropping(images, tl_x, tl_y, width, height);

    
    % Shift the hue value of the images by some random constant in 
    % [-0.1,0.1] to account for color illumination changes
    hue_shift = rand(N,1)/10;
    im_shifted = illuminationColorShift(im_cropped, hue_shift);
    
    montage( cat(4,im_shifted{:}) )
end

