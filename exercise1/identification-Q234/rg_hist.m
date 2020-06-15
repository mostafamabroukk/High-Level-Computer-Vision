%
%  compute joint histogram for r/g values
%  note that r/g values should be in the range [0, 1];
%  histogram should be normalized so that sum of all values equals 1
%
%  img_color - input color image
%  num_bins - number of bins used to discretize each dimension, total number of bins in the histogram should be num_bins^2
%

function h = rg_hist(img_color, num_bins)

  assert(size(img_color, 3) == 3, 'image dimension mismatch');
  assert(isfloat(img_color), 'incorrect image type');
  
  %define a 2D histogram  with "num_bins^2" number of entries
  h=zeros(num_bins, num_bins);
  
  R = img_color(:, :, 1);
  G = img_color(:, :, 2);
  B = img_color(:, :, 3);
  img_sum = R + G + B;
  
  nR = R./img_sum;
  nG = G./img_sum;
  
  
  % NOTE: 
  % imquantize() is not our code and it's implementation is not part of our
  %   solution. However we've encounetered versions of MATLAB where the
  %   function was not present, therefore we are attaching it is a backup.
  %   The rights belong to MathWorks.
  qR = imquantize(nR, linspace(0, 1, num_bins));
  qG = imquantize(nG, linspace(0, 1, num_bins));
  
  quantized_img_color = zeros(size(img_color));
  quantized_img_color(:, :, 1) = qR;
  quantized_img_color(:, :, 2) = qG;
  
  qic = quantized_img_color;
  
  for i=1:size(img_color,1)
    for j=1:size(img_color,2)
      %increment a histogram bin which corresponds to the value of pixel i,j; h(R,G,B)
      % ...
        h(qic(i, j, 1), qic(i, j, 2)) = h(qic(i, j, 1), qic(i, j, 2)) + 1;
    end
  end
  
  h = h(:);
  h = h/sum(h);
  
  
  
  
  
  