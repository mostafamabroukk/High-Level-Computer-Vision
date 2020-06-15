function [im_shifted] = illuminationColorShift(images, hue_shift)
    % takes an cell array of images a applies a global hue shift specified 
    % by the vector 'hue_shift' (--> double vector)
    % result will be an cell array of rgb images
    im_shifted = cellfun(@(i,h) illuminationColorShiftSingle(i,h),...
        images, num2cell(hue_shift), 'un', 0);
end



function [im_shifted] = illuminationColorShiftSingle(img, hue_shift)
    % This funcrion converts a single RGB image 'img' into HSV and shifts than 
    % the hue channel globally by 'hue_shift'
    % Afterwards the image is converted back into RGB
    % Idea: Paper: "Data-Augmentation for Reducing Dataset Bias in Person
    % Re-identification", 2015
    hsv_img = rgb2hsv(img);
    hsv_img(:,:,1) = hsv_img(:,:,1) + hue_shift;
    
    % make sure that we do not leave our quantisation range [0,1]
    % Remember HSV is circular
    hsv_img(hsv_img > 1) = hsv_img(hsv_img > 1) - 1;
    hsv_img(hsv_img < 0) = hsv_img(hsv_img < 0) + 1;
    
    im_shifted = hsv2rgb(hsv_img);
end

