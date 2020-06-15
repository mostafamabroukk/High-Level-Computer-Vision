function [bestDet, acc] = apply_ism2(cluster_centers, cluster_occurrences, img)

  PARAMS = get_ism_params;

  acc = 0;
     curImgR = img(:,:,1);
     curImgG = img(:,:,2);
     curImgB = img(:,:,3);
    
    %figure(400);
    %imshow(img/255);
    %hold on
    
    [px,py,H] = hessian(img(:,:,1), PARAMS.hessian_sigma, PARAMS.hessian_thresh);
    num_features = size(px,1);

    sift_frames = [px'; py'; PARAMS.feature_scale*ones(1, num_features); PARAMS.feature_ori*ones(1, num_features)];
    [sift_frames, sift_desc] = vl_sift(img(:,:,1), 'Frames', sift_frames);
    activ = [];
    for i=1:size(sift_desc,2)
      for j=1:size(cluster_centers,2)
        if (norm(double(sift_desc(:,i)) - cluster_centers(:,j)) <  PARAMS.match_reco_tresh)
           abs_loc = [px(i), py(i)];
           activation_index = j;  
           activ = [activ;activation_index, abs_loc];
        end
      end
    end
    num_act = numel(activ(:,1));

    bestDet = num_act;
 
hold off
end

  