%
% This function stiches two images related by a homogrphy into one image. 
% The image plane of image 1 is extended to fit the additional points of
% image 2. Intensity values are looked up in image 2, using bilinear
% interpolation (use the provided function interpolate_2d). 
% Further parts belonging to image 1 and image 2 are smoothly blended. 
% 
%
% img1 : the first gray value image
% img2 : the second gray value image 
% H    : the homography estimated between the images
% sz   : the amount of pixel to increase the left image on the right 
% st   : amount of overlap between the images
%
% img  : the final panorama image
% 
function img = pan_sample(img1,img2,H,sz,st)

%% Image Resampling (Question 4b)

  % append a sufficient number of black columns to the left image 
  left = zeros(size(img1,1),sz);
  img = [img1,left];
  % loop over all newly appended pixels plus some overlap    
  bound=size(img,2);
  
  for jj=bound-(sz+st):bound
      for ii=1:(size(img1,1))
        % transform the current pixel coordinates to a point in the right image   
        
        % Notice switch of jj ii
        v = H*[jj ii 1]';
        v = v/v(3);
        % following line not needed, leads to incorrect results because of
        % bugs in interpolate_2d:
        % 
        % v = floor(v) 
        
        % look up gray-values of the four pixels nearest to the transformed
        
        % following line not needed, done by interpolate_2d:
        % 
        % four = [img2(v(1)-1);img2(v(1)+1);img2(v(1)-bound);img2(v(1)+bound)];
        
        % bilinearly interpolate the gray-value at transformed coordinates and 
        % assign them to the source pixel in the left image. 
        
        % Notice switch of v(1) and v(2)
        
        new_value = interpolate_2d(img2,v(2),v(1));
        
        %To obtain the solution to Question 4b, comment out code for
        %Question 4c below:
        
        % Start of Question 4c 
        % if we are in overlap region, blend)
        if (jj < size(img1, 2) && jj >= size(img1, 2) - st)
          
          img1_value = img(ii, jj);
          img2_value = new_value;
          img1_w = (size(img1, 2) - jj)/st;
          img2_w = 1 - img1_w;
          
          new_value = img1_value * img1_w + img2_value * img2_w;
        end
        % End of Question 4c
        
        
        
        img(ii,jj) = new_value;
        
      end
  end
  img=img/255;
