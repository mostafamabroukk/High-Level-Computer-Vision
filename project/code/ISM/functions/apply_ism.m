function [det, det2] = apply_ism(cluster_centers, cluster_occurrences, cluster_occurrences2, img)

  PARAMS = get_ism_params;

  acc = 0;
     curImgR = img(:,:,1);
     curImgG = img(:,:,2);
     curImgB = img(:,:,3);
    
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
    if numel(activ)~=0
        num_act = numel(activ(:,1));
    else
        num_act = 0;
    end
    bsize = 10;
    
    score = [];
    imgX = size(img(:,:,1), 2);
    imgY = size(img(:,:,1), 1);
    houghAccumulator = zeros(ceil(imgX/bsize), ceil(imgY/bsize));
    HAmaxX = size(houghAccumulator, 1);
    HAmaxY = size(houghAccumulator, 2);

    for j = 1:num_act

      act_index = activ(j,1);
      
      abs_x = activ(j, 2);
      abs_y = activ(j, 3);
      occ_rel_x = cluster_occurrences(cluster_occurrences(:,1) == act_index, 2);
      occ_rel_y = cluster_occurrences(cluster_occurrences(:,1) == act_index, 3);

      abs_occ_x = abs_x - occ_rel_x;
      abs_occ_y = abs_y - occ_rel_y;
      num_occ = size(abs_occ_x, 1);

      % found points don't seem special/right
      %scatter(abs_x,abs_y,'rx');
      %scatter(abs_occ_x,abs_occ_y);
      
      %weight = 1/num_act + 1/num_occ;
      weight = 1/num_occ;
      for occ = 1:num_occ
        xIdx = ceil(abs_occ_x(occ)/bsize);
        yIdx = ceil(abs_occ_y(occ)/bsize);
        if (xIdx < 1) continue; end
        if (xIdx > HAmaxX) continue; end
        if (yIdx < 1) continue; end
        if (yIdx > HAmaxY) continue; end
        houghAccumulator(xIdx, yIdx) = houghAccumulator(xIdx, yIdx) + weight;
      end

    end
    
    score2 = [];
    houghAccumulator2 = zeros(ceil(imgX/bsize), ceil(imgY/bsize));
    
    for j = 1:num_act

      act_index = activ(j,1);
      
      abs_x = activ(j, 2);
      abs_y = activ(j, 3);
      occ_rel_x = cluster_occurrences2(cluster_occurrences2(:,1) == act_index, 2);
      occ_rel_y = cluster_occurrences2(cluster_occurrences2(:,1) == act_index, 3);

      abs_occ_x = abs_x - occ_rel_x;
      abs_occ_y = abs_y - occ_rel_y;
      num_occ = size(abs_occ_x, 1);

      %weight = 1/num_act + 1/num_occ;
      weight = 1/num_occ;
      for occ = 1:num_occ
        xIdx = ceil(abs_occ_x(occ)/bsize);
        yIdx = ceil(abs_occ_y(occ)/bsize);
        if (xIdx < 1) continue; end
        if (xIdx > HAmaxX) continue; end
        if (yIdx < 1) continue; end
        if (yIdx > HAmaxY) continue; end
        houghAccumulator2(xIdx, yIdx) = houghAccumulator2(xIdx, yIdx) + weight;
      end

    end
    
    maxima = nonmaxsup2d(houghAccumulator);
    [x,y] = find(maxima>PARAMS.min_det_score);
    scores = maxima(maxima > PARAMS.min_det_score);
    detections = [x, y, scores];
    detections = sortrows(detections,-3);
    
    maxima2 = nonmaxsup2d(houghAccumulator2);
    [x,y] = find(maxima2>PARAMS.min_det_score);
    scores2 = maxima2(maxima2 > PARAMS.min_det_score);
    detections2 = [x, y, scores2];
    detections2 = sortrows(detections2,-3);
    
    num_detections2 = size(detections2, 1);
    detections2(:, 1) = bsize*detections2(:, 1);
    detections2(:, 2) = bsize*detections2(:, 2);
    %scatter(detections2(:, 1), detections2(:, 2), 'rx')
    
    num_detections = size(detections, 1);
    sum(detections(:,3));
    detections(:, 1) = bsize*detections(:, 1);
    detections(:, 2) = bsize*detections(:, 2);
    %scatter(detections(:, 1), detections(:, 2), 'rx')
    
    det =detections (1,1:2);
    det2=detections2(1,1:2);
    
end

  