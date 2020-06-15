function [MSE,num_act] = apply_bow(ccluster_centers, histogramm_in, img)

  PARAMS = get_ism_params;

     curImgR = img(:,:,1);
     curImgG = img(:,:,2);
     curImgB = img(:,:,3);
    
    [px,py,H] = hessian(img(:,:,1), PARAMS.hessian_sigma, PARAMS.hessian_thresh);
    num_features = size(px,1);

    if size(px,2)~=0
        histogramm = zeros(size(ccluster_centers,2),1);

        sift_frames = [px'; py'; PARAMS.feature_scale*ones(1, num_features); PARAMS.feature_ori*ones(1, num_features)];
        [sift_frames, sift_desc] = vl_sift(img(:,:,1), 'Frames', sift_frames);

        for i=1:size(sift_desc,2)
          for j=1:size(ccluster_centers,2)
            if (norm(double(sift_desc(:,i)) - ccluster_centers(:,j)) <  PARAMS.patch_match_reco_tresh)
                histogramm(j)=histogramm(j)+1;
            end
          end
        end
        MSE = immse(histogramm_in,histogramm);
        %figure('Name','SingleHisto');
        %bar(histogramm);
        %num_act = sum(histogramm)*10/size(sift_desc,2);
        num_act = sum(histogramm);
    else
        num_act = 0;
        MSE = 100;
    end
end

  