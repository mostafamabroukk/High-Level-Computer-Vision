function [img_trans] = eliminateOutliers(img, thres, n)
% takes an given gray value image 'img' and an threshold 'thres'
% all pixel which have a higher intensity then 'thres' are considered as
% noise (salt impuls noise)
% only these pixels are substituted by the mean inside an '2n+1' x '2n+1' window
% where the mean only takes pixels into account which are considered to be
% non-noise (< thres)

    [Nx, Ny] = size(img);

    noise_map = zeros(Nx, Ny);
    noise_map(img > thres) = 1;
    
    img_trans = img;
    
    for i = 1:Nx
        for j = 1:Ny            
            if (~noise_map(i,j))
               continue; 
            else
                sum = double(0);
                count = 0;
                for k = -n:n
                   x_pos = i + k;
                   if ((x_pos < 1) || (x_pos > Nx)) % forbid indices that leave the image
                       continue;
                   end
                   for l = -n:n
                      y_pos = j + l;
                      if ((y_pos < 1) || (y_pos > Ny)) % forbid indices that leave the image
                          continue;
                      end
                      if (noise_map(x_pos,y_pos))
                         continue; % we do not want noise pixel in the averaging 
                      else
                          sum = sum + double(img(x_pos,y_pos));
                          count = count + 1;
                      end
                   end
                end
                % we cannot average if only noise is present in the choosen window
                if (count ~= 0) 
                   img_trans(i,j) = sum / count; 
                end
            end
        end
    end
    
    montage(cat(4,img, noise_map*255, img_trans))
end

