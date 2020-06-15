%
% compute image descriptors corresponding to the list of interest points 
% 
% D - matrix with number of rows equal to number of interest points, each row should be equal to the corresponding descriptor vector
% px, py - vectors of x/y coordinates of interest points
% desc_size - size of the region around interest point which is used to compute the descriptor
% desc_func - handle of the corresponding descriptor function (i.e. @rg_hist)
% num_bins - number of bins parameter of the descriptor function 
%

% test with
    % I1 = imread('gantrycrane.png');
    % I1_grayscale = double(rgb2gray(I1));
    % K1=compute_descriptors(@rg_hist,double(I1),[1,2,3],[1,3,2],10,255)
    % K2=compute_descriptors(@dxdy_hist,double(I1_grayscale),[1,2,3],[1,3,2],3,255)


function D = compute_descriptors(desc_func, img, px, py, desc_size, num_bins)
  
  desc_radius = round((desc_size-1)/2);
  dc =desc_radius;
  
  
  %D = ones(length(px),(num_bins+1)^2);
  
  dim = size(img);
  x_dim = dim(2);
  y_dim = dim(1);
  
  for i=1:numel(px)
        x=px(i);
        y=py(i);
        
        b = [  x-dc >= 1 
               x+dc <= x_dim
               y-dc >= 1
               y+dc <= y_dim];
        %[x-b(1)*dc x+b(2)*dc y-b(3)*dc y+b(4)*dc];
        patch = img(y-b(3)*dc: y+b(4)*dc,x-b(1)*dc : x+b(2)*dc,:);
        h=desc_func(patch,num_bins);
        D(i,:)=h';
  end;
  
  %h = desc_func(img,num_bins);
 
end
