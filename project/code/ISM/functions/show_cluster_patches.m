function show_cluster_patches(feature_patches, assignments, cluster_idx)

relevant_patches = feature_patches(:, :, assignments == cluster_idx);

max_display = 40;
figure(cluster_idx);
hold on;

for i=1:min(max_display, size(relevant_patches, 3))
  patch = relevant_patches(:, :, i);
  subplot(5, 8, i);
  imshow(patch/255);
  
  s = size(patch);
  patch3(:,:,1) = patch(:,1:s(2)/3);
  patch3(:,:,2) = patch(:,s(2)/3+1:s(2)*2/3);
  patch3(:,:,3) = patch(:,s(2)*2/3+1:s(2));
  imshow(patch3/255);
  
end
hold off
  


% ...