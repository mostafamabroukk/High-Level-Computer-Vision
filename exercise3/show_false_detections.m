%
% show false negatives (misclassified positive examples) with smallest score
% show false positives (misclassified negative examples) with largest score
%
% parameters: 
%
% figidx - index of the figure used for visualization
%
% pos_test_list - cell array of positive image filenames
% pos_class_score - vector with classifier output on the images from pos_test_list
%
% neg_test_list - cell array of negative image filenames
% neg_class_score - vector with classifier output on the images from neg_test_list
%
% num_show - number of examples to be shown
%

function show_false_detections(figidx, pos_test_list, pos_class_score, neg_test_list, neg_class_score, num_show)

figure(figidx);
clf;
hold on;

[~,idx] = sort(pos_class_score, 'ascend');
first_num_show = idx(1:num_show);
for i = 1 : size(first_num_show)
    img = load_image(pos_test_list{first_num_show(i)});
    subplot(3,3,i);
    imagesc(img);
    colormap gray;
end
figure(figidx+1);
    
[~,idx] = sort(neg_class_score, 'descend');
first_num_show = idx(1:num_show);

for i = 1 : size(first_num_show)
    img = load_image(neg_test_list{first_num_show(i)});
    subplot(3,3,i);
    imagesc(img);
    colormap gray;
end

