function cluster_occurrences = create_occurrences(sDir, cluster_centers,scale)
  
  PARAMS = get_ism_params();
  A = csvalpha('driver_imgs_list.csv');
    
  all_sift_desc = [];
  all_loc_pos_x = [];
  all_loc_pos_y = [];
  
  for ii=0:9
    vImgNames = dir(fullfile(strcat(sDir,'/c',num2str(ii),'/'), '*.jpg'));
  
  for i=1:ceil(length(vImgNames)/10)
      if(mod(i,10)==0)
          strcat('Occurrence creation for ISM - Seat, ',num2str(i))
      end
      
     index = find(strcmp(A(:,3), vImgNames(i).name));
     driver = A{index,1};
     
     seat_pos = strcat(sDir,'/seat_pos_',driver);
     seat_pos = load(seat_pos);
     seat_pos = seat_pos.bboxes_sw(1,:)*scale;
     
     seat_pos = ceil([(seat_pos(2)+seat_pos(4)/2),(seat_pos(1)+seat_pos(3)/2)]);
   
     curImg = single(imread(fullfile(strcat(sDir,'/c',num2str(ii),'/'), vImgNames(i).name)));
     
     curImg = imresize(curImg,scale);

     [px py, H] = hessian(curImg(:,:,1), PARAMS.hessian_sigma, PARAMS.hessian_thresh);
     
     loc_pos_x = px - seat_pos(2);
     loc_pos_y = py - seat_pos(1);
     
     num_features = size(px,1);
     
     sift_frames = [px'; py'; ...
        PARAMS.feature_scale*ones(1, num_features); ...
        PARAMS.feature_ori*ones(1, num_features)];
     [sift_frames, sift_desc] = vl_sift(curImg(:,:,1), 'Frames', sift_frames);

     all_sift_desc = cat(2, all_sift_desc, sift_desc);
     all_loc_pos_x = cat(1, all_loc_pos_x, loc_pos_x);
     all_loc_pos_y = cat(1, all_loc_pos_y, loc_pos_y);
  end
  
  cluster_occurrences = [];
  
  for i=1:size(all_sift_desc,2)
    for j=1:size(cluster_centers,2)
        if (norm(double(all_sift_desc(:,i)) - cluster_centers(:,j)) <  PARAMS.match_tresh)
           rel_loc = [all_loc_pos_x(i) all_loc_pos_y(i)];
           activation_index = j;
           cluster_occurrences = [cluster_occurrences; activation_index rel_loc];          
        end
    end
  end
  end
end