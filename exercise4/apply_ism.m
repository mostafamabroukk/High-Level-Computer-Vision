function [detections, acc] = apply_ism(sDir, cluster_centers, cluster_occurrences, image_idx_list)

  
  vImgNames = dir(fullfile(sDir, '*.png'));
  
  for imageID=image_idx_list

    PARAMS = get_ism_params();
    img = single(rgb2gray(imread(strcat(sDir, '/', vImgNames(imageID).name))));
    figure(400+imageID);
    imshow(img/255);
    hold on
    
    [px,py,H] = hessian(img, PARAMS.hessian_sigma, PARAMS.hessian_thresh);
    num_features = size(px,1);

    sift_frames = [px'; py'; PARAMS.feature_scale*ones(1, num_features); PARAMS.feature_ori*ones(1, num_features)];
    [sift_frames, sift_desc] = vl_sift(img, 'Frames', sift_frames);
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

    score = [];
    imgX = size(img, 2);
    imgY = size(img, 1);
    houghAccumulator = zeros(ceil(imgX/10), ceil(imgY/10));
    HAmaxX = size(houghAccumulator, 1);
    HAmaxY = size(houghAccumulator, 2);

    for j = 1:num_act

      act_index = activ(j,1);
      
      abs_x = activ(j, 2);
      abs_y = activ(j, 3);
      occ_rel_x = cluster_occurrences(cluster_occurrences(:,1) == act_index, 2);
      occ_rel_y = cluster_occurrences(cluster_occurrences(:,1) == act_index, 3);

      abs_occ_x = abs_x + occ_rel_x;
      abs_occ_y = abs_y + occ_rel_y;
      num_occ = size(abs_occ_x, 1);

      weight = 1/num_act + 1/num_occ;
      for occ = 1:num_occ
        xIdx = ceil(abs_occ_x(occ)/10);
        yIdx = ceil(abs_occ_y(occ)/10);
        if (xIdx < 1) continue; end
        if (xIdx > HAmaxX) continue; end
        if (yIdx < 1) continue; end
        if (yIdx > HAmaxY) continue; end
        houghAccumulator(xIdx, yIdx) = houghAccumulator(xIdx, yIdx) + weight;
      end

    end
    maxima = nonmaxsup2d(houghAccumulator);
    [x,y] = find(maxima>PARAMS.min_det_score);
    scores = maxima(maxima > PARAMS.min_det_score);
    detections = [x, y, scores];
    detections = sortrows(detections,-3);
    
    num_detections = size(detections, 1);
    
    detections(:, 1) = 10*detections(:, 1);
    detections(:, 2) = 10*detections(:, 2);
    scatter(detections(:, 1), detections(:, 2), 'rx')
    if (num_detections > 0) draw_detections(vImgNames(imageID).name, detections(1, :), 'r'); end;
    if (num_detections > 1) draw_detections(vImgNames(imageID).name, detections(2, :), 'g'); end;
    if (num_detections > 2) draw_detections(vImgNames(imageID).name, detections(3, :), 'b'); end;

  end  

end

  