%
%  compute histogram of image intensities, histogram should be normalized so that sum of all values equals 1
%  assume that image intensity varies between 0 and 255
%
%  img_gray - input image in grayscale format
%  num_bins - number of bins in the histogram
%
function h = normalized_hist(img_gray, num_bins)

  assert(length(size(img_gray)) == 2, 'image dimension mismatch');
  assert(isfloat(img_gray), 'incorrect image type');

  % compute the histogram of pixel intensity values
  % ...
  
    
  h = zeros(1, num_bins);
  bin_width = 256/num_bins;
  
  for i=1:num_bins
    h(i)=sum(sum((img_gray >= (i-1)*bin_width ).*(img_gray < i * bin_width)));
  end
  
    
  %normalize the histogram such that its integral (sum) is equal 1
  % ...
  h = h(:);
  h = h / sum(h);
  