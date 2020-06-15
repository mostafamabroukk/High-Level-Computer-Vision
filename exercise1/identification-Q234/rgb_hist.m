%
%  compute joint histogram for each color channel in the image, histogram should be normalized so that sum of all values equals 1
%  assume that values in each channel vary between 0 and 255
%
%  img_color - input color image
%  num_bins - number of bins used to discretize each channel, total number of bins in the histogram should be num_bins^3
%

function h=rgb_hist(img_color, num_bins)

  assert(size(img_color, 3) == 3, 'image dimension mismatch');
  assert(isfloat(img_color), 'incorrect image type');

  %define a 3D histogram  with "num_bins^3" number of entries
  h=zeros(num_bins,num_bins,num_bins);
  
  %quantize the image to "num_bins" number of values
  %...
  R = img_color(:, :, 1);
  G = img_color(:, :, 2);
  B = img_color(:, :, 3);
  
  
  
  % NOTE: 
  % imquantize() is not our code and it's implementation is not part of our
  %   solution. However we've encounetered versions of MATLAB where the
  %   function was not present, therefore we are attaching it is a backup.
  %   The rights belong to MathWorks.
  qR = imquantize(R, linspace(0, 255, num_bins));
  qG = imquantize(G, linspace(0, 255, num_bins));
  qB = imquantize(B, linspace(0, 255, num_bins));
  
  quantized_img_color = zeros(size(img_color));
  quantized_img_color(:, :, 1) = qR;
  quantized_img_color(:, :, 2) = qG;
  quantized_img_color(:, :, 3) = qB;
  
  qic = quantized_img_color;
  
  %execute the loop for each pixel in the image 
  
  for i=1:size(img_color,1)
    for j=1:size(img_color,2)
      %increment a histogram bin which corresponds to the value of pixel i,j; h(R,G,B)
      % ...
        h(qic(i, j, 1), qic(i, j, 2), qic(i, j, 3)) = h(qic(i, j, 1), qic(i, j, 2), qic(i, j, 3)) + 1;
    end
  end

  %normalize the histogram such that its integral (sum) is equal 1
  % ... 
  
  h = h(:);
  h = h/sum(h);
  %h = h/sum(sum(sum(h)));
  