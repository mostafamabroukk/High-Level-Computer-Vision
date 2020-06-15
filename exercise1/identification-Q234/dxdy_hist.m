%
%  compute joint histogram of Gaussian partial derivatives of the image in x and y direction
%  for sigma = 6.0, the range of derivatives is approximately [-34, 34]
%  histogram should be normalized so that sum of all values equals 1
%
%  img_gray - input grayvalue image
%  num_bins - number of bins used to discretize each dimension, total number of bins in the histogram should be num_bins^2
%
%  note: you can use the function gaussderiv.m from the filter exercise.
%

function h=dxdy_hist(img_gray, num_bins)

  assert(length(size(img_gray)) == 2, 'image dimension mismatch');
  assert(isfloat(img_gray), 'incorrect image type');
  gauss = fspecial('gaussian', [19 19], 6); %range = 3*sigma + 1
  
  dim = size(img_gray);
  dim_x = dim(1);
  dim_y = dim(2);
  
  
  img_gauss = conv2(img_gray, gauss, 'same');
  % compute the first derivatives
  % ...
  img_gauss_x_ext = [img_gauss(1, :); img_gauss(1:dim_x-1, :)];
  img_gauss_y_ext = [img_gauss(:, 1), img_gauss(:, 1:dim_y-1)];
  
  img_dx = img_gauss_x_ext - img_gauss;
  img_dy = img_gauss_y_ext - img_gauss;
  
  % quantize derivatives to "num_bins" number of values
  % ...
  
  % NOTE: 
  % imquantize() is not our code and it's implementation is not part of our
  %   solution. However we've encounetered versions of MATLAB where the
  %   function was not present, therefore we are attaching it is a backup.
  %   The rights belong to MathWorks.
  qdx = imquantize(img_dx, linspace(-34, 34, num_bins));
  qdy = imquantize(img_dy, linspace(-34, 34, num_bins));
  
  quantized_img_d = zeros(size(img_gray));
  quantized_img_d(:, :, 1) = qdx;
  quantized_img_d(:, :, 2) = qdy;
  
  qid= quantized_img_d;
  
  
  % define a 2D histogram  with "num_bins^2" number of entries
  % ...
  h=zeros(num_bins, num_bins);
  for i=1:size(img_gray,1)
    for j=1:size(img_gray,2)
      %increment a histogram bin which corresponds to the value of pixel i,j; h(R,G,B)
      % ...
      h(qid(i, j, 1), qid(i, j, 2)) = h(qid(i, j, 1), qid(i, j, 2)) + 1;
    end
  end
  
  h = h(:);
  h = h/sum(h);
  
  % ...
end
