%
% Compute gradient orientation histogram for one cell of the HOG descriptor.
% Each pixel should contribute to corresponding orientation bin with magnitude
% of its gradient. 
%
% parameters: 
% 
% img_cell_mag - matrix of gradient magnitudes for each pixel on the cell
% img_cell_ori - matrix of gradient orientations for each pixel of the cell
%
% PARAMS.hist_binsize - number of bins in the gradient orientation histogram
% PARAMS.hist_min - minimal orientation of the gradient vector
% PARAMS.hist_max - maximal orientation of the gradient vector
%
%
% note: see detector_param.m for the definition of PARAMS
%

function h = comp_cell_hist(PARAMS, img_cell_mag, img_cell_ori)

  img_cell_mag = img_cell_mag(:);
  img_cell_ori = img_cell_ori(:);

  img_cell_ori(img_cell_ori < PARAMS.hist_min) = img_cell_ori(img_cell_ori < PARAMS.hist_min) + 1e-6;
  img_cell_ori(img_cell_ori >= PARAMS.hist_max) = img_cell_ori(img_cell_ori >= PARAMS.hist_max) - 1e-6;

  assert(all(img_cell_ori >= PARAMS.hist_min));
  assert(all(img_cell_ori < PARAMS.hist_max));
  
  h = zeros(PARAMS.hist_numbins,1);
  
  valuerange = abs(PARAMS.hist_max - PARAMS.hist_min);
  
  for i=1:size(img_cell_ori,1)
    % - min and then / range norms to [0,1]
    % * PARAMS.hist_numbins - 1 to get to [0, PARAMS.hist_numbins bins-1]
    % +1 to to get in the interval [1, PARAMS.hist_numbins bins]
    index = round((img_cell_ori(i) - PARAMS.hist_min) / valuerange...
        * (PARAMS.hist_numbins - 1)) + 1;
    h(index) = h(index) + img_cell_mag(i);
  end
end