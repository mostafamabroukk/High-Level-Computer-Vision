function res = rotateAndCropImage(img, deg)
% takes an single image 'img' and rotates it by the angle 'deg'
% The result is cropped s.t. there are no black borders
% 'deg' is a double angle which should be in the range [-20,20]
    
    if (deg < -20) || (deg > 20)
       error('deg should be in [-20,20]!'); 
    end
    
    % first channel is used to get the rotation coordinates
    first_chan = img(:,:,1);
    [num_rows,num_cols] = size(first_chan);
    % we need the value 0 as a marker of black borders
    first_chan(first_chan == 0) = 1;
    
    first_chan_rot = imrotate(first_chan, deg, 'bilinear', 'crop');
    
    % compute now the crop coordinates
    if (deg > 0)
        row_min_col = 1; 
        row_max_col = num_cols;
        col_min_row = num_rows;
        col_max_row = 1;
    else
        row_min_col = num_cols;
        row_max_col = 1;
        col_min_row = 1;
        col_max_row = num_rows;
    end
    
    
    % find crop coordinates
    row_min = 1;
    for i=1:num_rows
        if (first_chan_rot(i,row_min_col) == 0)
            row_min = row_min + 1;
        else
            break;
        end
    end
    row_max = num_rows;
    for i=num_rows:-1:1
        if (first_chan_rot(i,row_max_col) == 0)
            row_max = row_max - 1;
        else
            break;
        end
    end
    col_min = 1;
    for i=1:num_cols
        if (first_chan_rot(col_min_row,i) == 0)
            col_min = col_min + 1;
        else
            break;
        end
    end
    col_max = num_cols;
    for i=num_cols:-1:1
        if (first_chan_rot(col_max_row,i) == 0)
            col_max = col_max - 1;
        else
            break;
        end
    end
    
    % rotate and crop the actual image using the computed crop coordinates
    im_rot = imrotate(img, deg, 'bilinear', 'crop');
    res = im_rot(row_min:row_max, col_min:col_max,:);
end

