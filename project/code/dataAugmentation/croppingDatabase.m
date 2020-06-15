function [data_cropped] = croppingDatabase(dataPath)
% returns a cropped version of the database found in 'dataPath' as a 
% cell array of images
    images = readInImages('jpg',dataPath);
    
    % Downsample the images
    images = cellfun(@(i) imresize(i, 0.7), images, 'un', 0);
    
    % crop the images to 640 x 480
    N = numel(images);
    tl_x = ones(N,1) * 20;
    tl_y = ones(N,1) * 220;
    width = ones(N,1) * 640;
    height = ones(N,1) * 480;    
    data_cropped = cropping(images, tl_x, tl_y, width, height);
end

