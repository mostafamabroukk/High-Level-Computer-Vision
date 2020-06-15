function PARAMS = get_ism_params

  % parameters of the Hessian interest point detector
  PARAMS.hessian_sigma = 2.0;
  %PARAMS.hessian_thresh = 530;
  PARAMS.hessian_thresh = 430;

  % parameters of the SIFT image descriptor
  PARAMS.feature_scale = 2.0;
  PARAMS.feature_ori = 0;

  % threshold for matching image feature to a codebook entry (assume l2 distance is used)
  PARAMS.match_tresh = 280;
  PARAMS.match_reco_tresh = 280;

  % threshold for matching image patch feature to a codebook entry (assume l2 distance is used)
  PARAMS.patch_match_tresh = 300;
  PARAMS.patch_match_reco_tresh = 320;
  
  % minimum detection score 
  PARAMS.min_det_score = 0.0;
