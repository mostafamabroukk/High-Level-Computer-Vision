%
% compute joint histogram of gradient magnitudes and Laplacian
% 
% note: use the functions gradmag.m and laplace.m
%
% note: you can assume that gradient magnitude is in the range [0, 100], 
%       and Laplacian is in the range [-60, 60]
% 

function h = maglap_hist(img_gray, num_bins)

  assert(length(size(img_gray)) == 2, 'image dimension mismatch');
  assert(isfloat(img_gray), 'incorrect image type');

  sigma = 2.0;

  %define a 2D histogram  with "num_bins^2" number of entries
  h=zeros(num_bins,num_bins);

  % compute the gradient magnitudes and Laplacian
  mag = gradmag(img_gray,sigma);
  lap = laplace(img_gray,sigma);

  % quantize the gradient magnitude and Laplacian to "num_bins" number of values
  rangeLap = 12;
  rangeMag = 30;
  
  lap = lap + rangeLap/2;
  
  %mag(mag < 0)   = 0;
  mag(mag >= rangeMag) = rangeMag-1;
  lap(lap < 0)   = 0;
  lap(lap >= rangeLap) = rangeLap-1;

  multLap = (num_bins)/(rangeLap);
  multMag=(num_bins)/(rangeMag);
   
   mag = floor(multMag*mag);
   lap = floor(multLap*lap);

  % execute the loop for each pixel in the image,
  for i=1:size(img_gray, 1)
    for j=1:size(img_gray, 2)

      %increment a histogram bin which corresponds to the value of pixel i,j; h(mag,lap)
      mag1 = mag(i,j)+1;
      lap1 = lap(i,j)+1;
      h(mag1,lap1) = h(mag1,lap1)+ 1;
    end
  end

  % normalize the histogram such that its integral (sum) is equal 1
  h=h/sum(h(:));
  h=reshape(h,(num_bins)^2,1);


