function [num_act] = apply_bow_folder(ccluster_centers, sDir,scale)

PARAMS = get_ism_params;

vImgNames = dir(fullfile(strcat(sDir,'/'), '*.jpg'));
num_img = length(vImgNames);

 histogramm = zeros(size(ccluster_centers,2),1);
 
  for ii=1:num_img
  
     curImg = single(imread(fullfile(strcat(sDir,'/'), vImgNames(ii).name)));

     curImg = imresize(curImg,scale);

     img = curImg(:,:,1);
     curImgG = curImg(:,:,2);
     curImgB = curImg(:,:,3);

    [px,py,H] = hessian(img(:,:,1), PARAMS.hessian_sigma, PARAMS.hessian_thresh);
    num_features = size(px,1);
    
    sift_frames = [px'; py'; PARAMS.feature_scale*ones(1, num_features); PARAMS.feature_ori*ones(1, num_features)];
    [sift_frames, sift_desc] = vl_sift(img(:,:,1), 'Frames', sift_frames);

    for i=1:size(sift_desc,2)
      for j=1:size(ccluster_centers,2)
        if (norm(double(sift_desc(:,i)) - ccluster_centers(:,j)) <  PARAMS.patch_match_reco_tresh)
            histogramm(j)=histogramm(j)+1;
        end
      end
    end
  end
  if(num_img ~= 0)
      num_act = sum(histogramm)/num_img;
  else
      num_act = 0;
  end
end

  