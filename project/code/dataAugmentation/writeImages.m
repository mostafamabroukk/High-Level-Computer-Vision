function [] = writeImages(images, outputPath)
% wirte a cell array of images 'images' to the folder specified by 
% 'outputPath'
for i = 1:numel(images)
    fileName = sprintf('image_%03d.jpg',i);
    imwrite( images{i}, [outputPath '\' fileName] );
end
end

