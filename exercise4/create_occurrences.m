function cluster_occurrences = create_occurrences(sDir, cluster_centers)
  
  PARAMS = get_ism_params();
  
  vImgNames = dir(fullfile(sDir,'*.png'));
  
  all_sift_desc = [];
  all_loc_pos_x = [];
  all_loc_pos_y = [];
  
  for i=1:length(vImgNames)
     % load image and convert it a one channel gray image
     % TODO: not quite sure about the conversion but all our images are
     % gray images anyway
     curImg = single(rgb2gray(imread(strcat(sDir, '/', vImgNames(i).name))));
     % compute Hessian interest points, px and py are the coordinates of
     % the interest points, H is the Hessian determinant in each pixel
     [px py, H] = hessian(curImg, PARAMS.hessian_sigma, PARAMS.hessian_thresh);
     
     % compute the local positions of the interest points
     loc_pos_x = px - (size(curImg,2) / 2);
     loc_pos_y = py - (size(curImg,1) / 2);
     
     num_features = size(px,1);
     
     sift_frames = [px'; py'; ...
        PARAMS.feature_scale*ones(1, num_features); ...
        PARAMS.feature_ori*ones(1, num_features)];
     [sift_frames, sift_desc] = vl_sift(curImg, 'Frames', sift_frames);
     
     % collect all SIFT vectors and local positions across all different 
     % images such that we can use them to create occurences
     all_sift_desc = cat(2, all_sift_desc, sift_desc);
     all_loc_pos_x = cat(1, all_loc_pos_x, loc_pos_x);
     all_loc_pos_y = cat(1, all_loc_pos_y, loc_pos_y);
  end
  
  cluster_occurrences = [];
  
  % Each extracted feature is then matched to the codebook and activates 
  % all codebook entries for which its Euclidian distance is smaller than 
  % the predefined threshold
  for i=1:size(all_sift_desc,2)
    for j=1:size(cluster_centers,2)
        if (norm(double(all_sift_desc(:,i)) - cluster_centers(:,j)) <  PARAMS.match_tresh)
           % For each activation, an occurrence record is stored containing
           % the index of the activated codebook entry,
           % the relative location of the activating image feature with 
           % respect to the image center
           rel_loc = [all_loc_pos_x(i) all_loc_pos_y(i)];
           activation_index = j;
           cluster_occurrences = [cluster_occurrences; activation_index rel_loc];
           % TODO: Append to cluster_occurrences
           
        end
    end
  end
  
end