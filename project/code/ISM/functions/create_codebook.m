function [cluster_centers, assignments, feature_patches] = create_codebook(sDir, num_clusters,scale)
  
  PARAMS = get_ism_params();
  
  patch_diameter = 9;
  
  all_sift_desc = [];
  feature_patches = [];
  ct = 1;
 
  for ii=0:9
    vImgNames = dir(fullfile(strcat(sDir,'/c',num2str(ii),'/'), '*.jpg'));

      for i=1:ceil(length(vImgNames)/10)
         
          if(mod(i,10)==0)
            strcat('Codebook creation for ISM, ',num2str(i))
          end
          
         curImg = single(imread(fullfile(strcat(sDir,'/c',num2str(ii),'/'), vImgNames(i).name)));
         curImg = imresize(curImg,scale);

         [px py, H] = hessian(curImg(:,:,1), PARAMS.hessian_sigma, PARAMS.hessian_thresh);

         num_features = size(px,1);

         sift_frames = [px'; py'; ...
            PARAMS.feature_scale*ones(1, num_features); ...
            PARAMS.feature_ori*ones(1, num_features)];
         [sift_frames, sift_desc] = vl_sift(curImg(:,:,1), 'Frames', sift_frames);


         padded_imgR = padarray(curImg(:,:,1), [patch_diameter, patch_diameter], 0);
         padded_imgG = padarray(curImg(:,:,2), [patch_diameter, patch_diameter], 0);
         padded_imgB = padarray(curImg(:,:,3), [patch_diameter, patch_diameter], 0);
         for (frame = 1:size(sift_frames, 2))
            frameX = sift_frames(1, frame);
            frameY = sift_frames(2, frame);
            feature_patches(:, :, ct) = [padded_imgR(frameY:frameY+2*patch_diameter,...
              frameX:frameX+2*patch_diameter)...
              padded_imgG(frameY:frameY+2*patch_diameter,...
              frameX:frameX+2*patch_diameter)...
              padded_imgB(frameY:frameY+2*patch_diameter,...
              frameX:frameX+2*patch_diameter)];
            ct = ct + 1;
         end

         all_sift_desc = cat(2, all_sift_desc, sift_desc);

      end

      end
      all_sift_desc = single(all_sift_desc);

      [cluster_centers, assignments] = vl_kmeans(all_sift_desc, num_clusters);
  
  
end
 



