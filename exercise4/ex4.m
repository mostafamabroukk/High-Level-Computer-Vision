show_q1 = false;
show_q2 = false;
show_q3 = true;

% order of addpath is important
addpath('./vlfeat-0.9.9/toolbox/kmeans');
addpath('./vlfeat-0.9.9/toolbox/sift');
addpath(['./vlfeat-0.9.9/toolbox/mex/' mexext]);

%
% Question 1: codebook generation
%

if show_q1
  num_clusters = 200;

  [cluster_centers, assignments, feature_patches] = create_codebook('./cars-training', num_clusters);
  %save('codebook.mat', 'cluster_centers', 'assignments', 'feature_patches')
  cluster_idx = 1;
  show_cluster_patches(feature_patches, assignments, cluster_idx);
    
end

%
% Question 2: occurrence generation
%

if show_q2
  %load('codebook.mat')
  cluster_occurrences = create_occurrences('./cars-training', cluster_centers);
  %save('cluster_occurrences.mat', 'cluster_occurrences')
  %load('cluster_occurrences.mat')
  cluster_idx = 1;
  show_occurrence_distribution(cluster_occurrences, cluster_idx);
    
end

%
% Question 3: Recognition
%

if show_q3
  %load('codebook.mat')
  %load('cluster_occurrences.mat')
  image_idx_list=[1:20];
  apply_ism('./cars-test',cluster_centers,cluster_occurrences, image_idx_list);

end