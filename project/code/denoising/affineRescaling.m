function [img_trans] = affineRescaling(img, low_bound, up_bound)
    % Performs an affine resclaing st. an image which should be contained
    % insde the range [low_bound, up_bound] afterwards really uses
    % [low_bound, up_bound]
    img_min = min(img(:));
    img_max = max(img(:));
    if img_max == img_min
        error('Maximum equals minimum of passed image. Cannot rescale this!');
    else
        if low_bound > 0
            % now it should really use [low_bound, up_bound]
            img_trans = (up_bound - low_bound)...
                * (img - img_min)/(img_max - img_min) + low_bound; 
        elseif (up_bound > 0)
            % now it should be inside [0, abs(low_bound) + up_bound]
            img = img + abs(low_bound); 
            img_min = min(img(:));
            img_max = max(img(:));
            % now it should really use [0, abs(low_bound) + up_bound]
            img = (abs(low_bound) + up_bound) * (img - img_min)/(img_max - img_min); 
            % now it should be inside [low_bound, up_bound] (remember that low_bound is neg)
            img_trans = img - abs(low_bound);
        else
            % both are < 0
            % TODO: Write this! Here not needed
            error(strcat('affineRescaling: Unimplemented case that ',...
                'low_bound and up_bound are both < 0!'));
        end
    end
end

