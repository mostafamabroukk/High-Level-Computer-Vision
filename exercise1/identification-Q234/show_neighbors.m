%
% for each image file from 'query_images' find and visualize the 5 nearest images from 'model_image'.
%
% note: use the previously implemented function 'find_best_match.m'
% note: use subplot command to show all the images in the same Matlab figure, one row per query image
%

function show_neighbors(model_images, query_images, dist_type, hist_type, num_bins)
  
  figure(4);
  clf;
  num_nearest = 5;
  
  [best_match, D] = find_best_match(model_images, query_images, dist_type, hist_type, num_bins);
  for j = 1:length(query_images)
    hist_distances = D(:, j)';
    [sortedValues,sortIndex] = sort(hist_distances(:),'descend'); 
    topk_indices = sortIndex(1:num_nearest)
    subplot(length(query_images), 6, (j-1)*6+1);
    imshow(query_images{j});
    for k = 1:num_nearest
      image = imread(model_images{topk_indices(k)});
      subplot(length(query_images), 6, (j-1)*6+k+1);
      imshow(image);
    end
  end

  

  % ...
