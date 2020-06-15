function [cluster_centers, assignments, feature_patches] = create_codebook(sDir, num_clusters)
  
  PARAMS = get_ism_params();

  vImgNames = dir(fullfile(sDir, '*.png'));
  patch_diameter = 9;
  
  all_sift_desc = [];
  feature_patches = [];
  ct = 1;
  for i=1:length(vImgNames)
     % load image and convert it a one channel gray image
     % TODO: not quite sure about the conversion but all our images are
     % gray images anyway
     curImg = single(rgb2gray(imread(strcat(sDir, '/', vImgNames(i).name))));
     % compute Hessian interest points, px and py are the coordinates of
     % the interest points, H is the Hessian determinant in each pixel
     [px py, H] = hessian(curImg, PARAMS.hessian_sigma, PARAMS.hessian_thresh);
     
     num_features = size(px,1);
     
     sift_frames = [px'; py'; ...
        PARAMS.feature_scale*ones(1, num_features); ...
        PARAMS.feature_ori*ones(1, num_features)];
     [sift_frames, sift_desc] = vl_sift(curImg, 'Frames', sift_frames);
     
     padded_img = padarray(curImg, [patch_diameter, patch_diameter], 0);
     for (frame = 1:size(sift_frames, 2))
        frameX = sift_frames(1, frame);
        frameY = sift_frames(2, frame);
        feature_patches(:, :, ct) = padded_img(frameY:frameY+2*patch_diameter,...
          frameX:frameX+2*patch_diameter);
        ct = ct + 1;
     end
    
     % collect all SIFT vectors across all different images such that we
     % can cluster them
     all_sift_desc = cat(2, all_sift_desc, sift_desc);
     
     
  end
  all_sift_desc = single(all_sift_desc);
  
  [cluster_centers, assignments] = vl_kmeans(all_sift_desc, num_clusters);
  
  
end
 



