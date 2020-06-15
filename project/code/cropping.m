function [im_cropped] = cropping(images, tl_x, tl_y, width, height)
% takes a cell array of images and crops them 
% based on the specified cropping window:
% tl_x, tl_y = top left corner, pixel cordinates (vectors of length length(images))
% width, and height (vectors of length length(images))
    subindex3D = @(A,r,c,d) A(r,c,d); %# An anonymous function to index a 3D matrix
    cellfunc = @(image, idx) subindex3D(image,...
        tl_x(idx):tl_x(idx)+height(idx), tl_y(idx):tl_y(idx)+width(idx),':'); 
    
    N = length(images);
    indices = num2cell(1:N)';
    
    im_cropped = cellfun(@(i,idx) cellfunc(i,idx), images, indices, 'un', 0);
end

