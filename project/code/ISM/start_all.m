trainPath = 'F:/DistractedDrivers/train';
testPath = 'C:/Users/Damaris/Documents/MATLAB/hlcv/project/data/test';
scale = 0.2;

mkdir('codebook_variables');
mkdir('codebook_variables_patches');

for qq = 0:9
    mkdir(strcat(trainPath,'/c',num2str(qq),'_patch'));
end

%% Addpath
addpath('./vlfeat-0.9.9/toolbox/kmeans');
addpath('./vlfeat-0.9.9/toolbox/sift');
addpath(['./vlfeat-0.9.9/toolbox/mex/' mexext]);
addpath('./functions/');
addpath(trainPath);
addpath(testPath);

%% Codebook creation for ISM
num_clusters = 200;
[cluster_centers, assignments, feature_patches] = create_codebook(trainPath, num_clusters,scale);
save('codebook_variables/cluster_centers.mat', 'cluster_centers');

%% Occurrence Creation for ISM - Wheel and Seat
load('codebook_variables/cluster_centers');
cluster_occurrences_seat = create_occurrences_seat(trainPath, cluster_centers,scale);
save('codebook_variables/cluster_occurences_seat.mat', 'cluster_occurrences_seat','-v7.3');
cluster_occurrences_wheel = create_occurrences_wheel(trainPath, cluster_centers,scale);
save('codebook_variables/cluster_occurences_wheel.mat', 'cluster_occurrences_wheel','-v7.3');

%% Apply ISM - Find Seat and Wheel and crop image patches

load('codebook_variables/cluster_centers');
load('codebook_variables/cluster_occurences_seat');
load('codebook_variables/cluster_occurences_wheel');

for ll=0:9
    vImgNames = dir(fullfile(strcat(trainPath,'/c',num2str(ll)), '*.jpg'));

    boxes = zeros(10,4);

    for imageID=1:length(vImgNames)
      if(mod(imageID,50)==0)
          strcat('Find Seat/Wheel for patch codebook, img ',num2str(imageID))
      end

      img = single(imread(fullfile(strcat(trainPath,'/c',num2str(ll)), vImgNames(imageID).name)));
      img = imresize(img,scale);

      [wheel,seat]=apply_ism(cluster_centers,cluster_occurrences_wheel,cluster_occurrences_seat, img);

      line_x = linspace(wheel(1),seat(1),5);
      line_y = linspace(wheel(2),seat(2),5);

      boxes(1,:) = [line_x(1) line_y(1),ceil(size(img,2)/3),ceil(size(img,1)/1.8)];
      boxes(2,:) = [line_x(2)-ceil(size(img,2)/13) line_y(2)+ceil(size(img,1)/13),ceil(size(img,2)/3),ceil(size(img,1)/3.5)];
      boxes(3,:) = [line_x(4) line_y(4)-ceil(size(img,2)/13),ceil(size(img,2)/2.5),ceil(size(img,1)/1.8)];
      boxes(4,:) = [line_x(2)-ceil(size(img,2)/13) line_y(2),ceil(size(img,2)/3),ceil(size(img,1)/3.5)];
      boxes(5,:) = [line_x(4)+ceil(size(img,2)/13) line_y(4),ceil(size(img,2)/4.5),ceil(size(img,1)/3.5)];
      boxes(6,:) = [line_x(1)+ceil(size(img,2)/13) line_y(1)+ceil(size(img,1)/3),ceil(size(img,2)/4.5),ceil(size(img,1)/2)];
      boxes(7,:) = [line_x(3) line_y(3),ceil(size(img,2)/4),ceil(size(img,1)/3)];
      boxes(8,:) = [line_x(5) line_y(5)+ceil(size(img,1)/2),ceil(size(img,2)/3),ceil(size(img,1)/4)];
      boxes(9,:) = [line_x(3) line_y(3),ceil(size(img,2)/1.7),ceil(size(img,1)/1.5)];
      boxes(10,:) =[line_x(4) line_y(4)-ceil(size(img,2)/13),ceil(size(img,2)/2.5),ceil(size(img,1)/2)];

      patch = crop2patch(img,boxes(ll+1,:));

      imwrite(patch/255,strcat(trainPath,'/c',num2str(ll),'_patch/',vImgNames(imageID).name),'jpg');
    end
end

%% Codebook creation for every single category (only for corresponding patch)
load('codebook_variables/mean_num_act');
load('codebook_variables/cluster_centers');
load('codebook_variables/cluster_occurences_seat');
load('codebook_variables/cluster_occurences_wheel');

num_clusters = 20;

for ll=0:9
    strcat('Create patch code book, category ',num2str(imageID))
    
    [cluster_centers, assignments, feature_patches,num_img] = create_codebook_patches(strcat(trainPath,'/c',num2str(ll),'_patch'), num_clusters,scale);
    
    Histogram = zeros(num_clusters,1);
    for i = 1:num_clusters
        Histogram(i) = size(feature_patches(:, :, assignments == i),3);
    end
    Histogram = Histogram/num_img;
    
    if ll==0
        Histogram_0 = Histogram; 
        cluster_centers_0 = cluster_centers;
    end
    if ll==1
        Histogram_1 = Histogram;
        cluster_centers_1 = cluster_centers;
    end
    if ll==2
        Histogram_2 = Histogram;
        cluster_centers_2 = cluster_centers;
    end
    if ll==3
        Histogram_3 = Histogram;
        cluster_centers_3 = cluster_centers;
    end
    if ll==4
        Histogram_4 = Histogram;
        cluster_centers_4 = cluster_centers;
    end
    if ll==5
        Histogram_5 = Histogram;
        cluster_centers_5 = cluster_centers;
    end
    if ll==6
        Histogram_6 = Histogram;
        cluster_centers_6 = cluster_centers;
    end
    if ll==7
        Histogram_7 = Histogram;
        cluster_centers_7 = cluster_centers;
    end
    if ll==8
        Histogram_8 = Histogram;
        cluster_centers_8 = cluster_centers;
    end
    if ll==9
        Histogram_9 = Histogram;
        cluster_centers_9 = cluster_centers;
    end
    
    %figure('Name','Histogram');
    %bar(Histogram);
    save(strcat('codebook_variables_patches/cluster_centers_',num2str(ll),'.mat'), strcat('cluster_centers_',num2str(ll)));
    save(strcat('codebook_variables_patches/Histogram_',num2str(ll),'.mat'), strcat('Histogram_',num2str(ll)));

end

%% Search average number of activations per category

for kk = 0:9
    load(strcat('codebook_variables_patches/cluster_centers_',num2str(kk)));
    load(strcat('codebook_variables_patches/Histogram_',num2str(kk)));
end

num_act = zeros(10,1);
mean_num_act = zeros(10,1);
count = zeros(10,1);

for rr = 0:9
    
vImgNames = dir(fullfile(strcat(trainPath,'/c',num2str(rr),'/'), '*.jpg'));
count_old = count(rr+1);
 
strcat('Search average number, category ',num2str(imageID))
 
    for imageID=1:ceil(length(vImgNames)/50)
        count(:) = count(:)+1;
        count(rr+1) = count_old;
        
        boxes = zeros(10,4);
        num = zeros(10,1);
        err = zeros(10,1);

      img = single(imread(fullfile(strcat(trainPath,'/c',num2str(rr),'/'), vImgNames(imageID).name)));
      img = imresize(img,scale);

      [wheel,seat]=apply_ism(cluster_centers,cluster_occurrences_wheel,cluster_occurrences_seat, img);

      line_x = linspace(wheel(1),seat(1),5);
      line_y = linspace(wheel(2),seat(2),5);

      boxes(1,:) = [line_x(1) line_y(1),ceil(size(img,2)/3),ceil(size(img,1)/1.8)];
      boxes(2,:) = [line_x(2)-ceil(size(img,2)/13) line_y(2)+ceil(size(img,1)/13),ceil(size(img,2)/3),ceil(size(img,1)/3.5)];
      boxes(3,:) = [line_x(4) line_y(4)-ceil(size(img,2)/13),ceil(size(img,2)/2.5),ceil(size(img,1)/1.8)];
      boxes(4,:) = [line_x(2)-ceil(size(img,2)/13) line_y(2),ceil(size(img,2)/3),ceil(size(img,1)/3.5)];
      boxes(5,:) = [line_x(4)+ceil(size(img,2)/13) line_y(4),ceil(size(img,2)/4.5),ceil(size(img,1)/3.5)];
      boxes(6,:) = [line_x(1)+ceil(size(img,2)/13) line_y(1)+ceil(size(img,1)/3),ceil(size(img,2)/4.5),ceil(size(img,1)/2)];
      boxes(7,:) = [line_x(3) line_y(3),ceil(size(img,2)/4),ceil(size(img,1)/3)];
      boxes(8,:) = [line_x(5) line_y(5)+ceil(size(img,1)/2),ceil(size(img,2)/3),ceil(size(img,1)/4)];
      boxes(9,:) = [line_x(3) line_y(3),ceil(size(img,2)/1.7),ceil(size(img,1)/1.5)];
      boxes(10,:) =[line_x(4) line_y(4)-ceil(size(img,2)/13),ceil(size(img,2)/2.5),ceil(size(img,1)/2)];

      patch_0 = crop2patch(img,boxes(1,:));
      patch_1 = crop2patch(img,boxes(2,:));
      patch_2 = crop2patch(img,boxes(3,:));
      patch_3 = crop2patch(img,boxes(4,:));
      patch_4 = crop2patch(img,boxes(5,:));
      patch_5 = crop2patch(img,boxes(6,:));
      patch_6 = crop2patch(img,boxes(7,:));
      patch_7 = crop2patch(img,boxes(8,:));
      patch_8 = crop2patch(img,boxes(9,:));
      patch_9 = crop2patch(img,boxes(10,:));

      %% Apply BoW
      [err(1),num(1)] = apply_bow(cluster_centers_0, Histogram_0, patch_0);   
      [err(2),num(2)] = apply_bow(cluster_centers_1, Histogram_1, patch_1);
      [err(3),num(3)] = apply_bow(cluster_centers_2, Histogram_2, patch_2);
      [err(4),num(4)] = apply_bow(cluster_centers_3, Histogram_3, patch_3);
      [err(5),num(5)] = apply_bow(cluster_centers_4, Histogram_4, patch_4);
      [err(6),num(6)] = apply_bow(cluster_centers_5, Histogram_5, patch_5);
      [err(7),num(7)] = apply_bow(cluster_centers_6, Histogram_6, patch_6);
      [err(8),num(8)] = apply_bow(cluster_centers_7, Histogram_7, patch_7);
      [err(9),num(9)] = apply_bow(cluster_centers_8, Histogram_8, patch_8);
    [err(10),num(10)] = apply_bow(cluster_centers_9, Histogram_9, patch_9);
    
    num(rr+1) = 0;
    mean_num_act = mean_num_act+num;
    end
end
mean_num_act = mean_num_act./count;
save(strcat('codebook_variables_patches/mean_num_act.mat'),'mean_num_act');

%% Find Distraction class for Test Images

fileID = fopen('submission_patches.csv','w');
fprintf(fileID,'img,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9\n');
fclose(fileID);

load('codebook_variables/mean_num_act');
load('codebook_variables/cluster_centers');
load('codebook_variables/cluster_occurences_seat');
load('codebook_variables/cluster_occurences_wheel');

for kk = 0:9
    load(strcat('codebook_variables_patches/cluster_centers_',num2str(kk)));
    load(strcat('codebook_variables_patches/Histogram_',num2str(kk)));
end
    
vImgNames = dir(fullfile(strcat(testPath,'/'), '*.jpg'));


for imageID = 1:length(vImgNames)
    boxes = zeros(10,4);
    num = zeros(10,1);
    err = zeros(10,1);
    
  if(mod(imageID,100)==0)
     strcat('Find distraction class for test images, img ',num2str(imageID))
  end
  img = single(imread(fullfile(testPath, vImgNames(imageID).name)));
  img = imresize(img,scale);

  [wheel,seat]=apply_ism(cluster_centers,cluster_occurrences_wheel,cluster_occurrences_seat, img);

  line_x = linspace(wheel(1),seat(1),5);
  line_y = linspace(wheel(2),seat(2),5);

%   figure('Name','image')
%   hold on
%   imshow(img/255);
%   line(line_x,line_y,'LineWidth',3,'Marker','o');
%   hold off
  
  boxes(1,:) = [line_x(1) line_y(1),ceil(size(img,2)/3),ceil(size(img,1)/1.8)];
  boxes(2,:) = [line_x(2)-ceil(size(img,2)/13) line_y(2)+ceil(size(img,1)/13),ceil(size(img,2)/3),ceil(size(img,1)/3.5)];
  boxes(3,:) = [line_x(4) line_y(4)-ceil(size(img,2)/13),ceil(size(img,2)/2.5),ceil(size(img,1)/1.8)];
  boxes(4,:) = [line_x(2)-ceil(size(img,2)/13) line_y(2),ceil(size(img,2)/3),ceil(size(img,1)/3.5)];
  boxes(5,:) = [line_x(4)+ceil(size(img,2)/13) line_y(4),ceil(size(img,2)/4.5),ceil(size(img,1)/3.5)];
  boxes(6,:) = [line_x(1)+ceil(size(img,2)/13) line_y(1)+ceil(size(img,1)/3),ceil(size(img,2)/4.5),ceil(size(img,1)/2)];
  boxes(7,:) = [line_x(3) line_y(3),ceil(size(img,2)/4),ceil(size(img,1)/3)];
  boxes(8,:) = [line_x(5) line_y(5)+ceil(size(img,1)/2),ceil(size(img,2)/3),ceil(size(img,1)/4)];
  boxes(9,:) = [line_x(3) line_y(3),ceil(size(img,2)/1.7),ceil(size(img,1)/1.5)];
  boxes(10,:) =[line_x(4) line_y(4)-ceil(size(img,2)/13),ceil(size(img,2)/2.5),ceil(size(img,1)/2)];

  patch_0 = crop2patch(img,boxes(1,:));
  patch_1 = crop2patch(img,boxes(2,:));
  patch_2 = crop2patch(img,boxes(3,:));
  patch_3 = crop2patch(img,boxes(4,:));
  patch_4 = crop2patch(img,boxes(5,:));
  patch_5 = crop2patch(img,boxes(6,:));
  patch_6 = crop2patch(img,boxes(7,:));
  patch_7 = crop2patch(img,boxes(8,:));
  patch_8 = crop2patch(img,boxes(9,:));
  patch_9 = crop2patch(img,boxes(10,:));

  %% Apply BoW
  [err(1),num(1)] = apply_bow(cluster_centers_0, Histogram_0, patch_0);   
  [err(2),num(2)] = apply_bow(cluster_centers_1, Histogram_1, patch_1);
  [err(3),num(3)] = apply_bow(cluster_centers_2, Histogram_2, patch_2);
  [err(4),num(4)] = apply_bow(cluster_centers_3, Histogram_3, patch_3);
  [err(5),num(5)] = apply_bow(cluster_centers_4, Histogram_4, patch_4);
  [err(6),num(6)] = apply_bow(cluster_centers_5, Histogram_5, patch_5);
  [err(7),num(7)] = apply_bow(cluster_centers_6, Histogram_6, patch_6);
  [err(8),num(8)] = apply_bow(cluster_centers_7, Histogram_7, patch_7);
  [err(9),num(9)] = apply_bow(cluster_centers_8, Histogram_8, patch_8);
[err(10),num(10)] = apply_bow(cluster_centers_9, Histogram_9, patch_9);

  for ll = 1:10
	  num(ll) = num(ll) - mean_num_act(ll);
  end

  if sum(num) ~= 0
    num = num-min(num)+1;
    num = num/sum(num);
  else 
    num(:) = 0.1;
  end
  %[[0 1 2 3 4 5 6 7 8 9]',num]
  
  fileID = fopen('submission_patches.csv','a');
  fprintf(fileID,strcat(vImgNames(imageID).name,',%g,%g,%g,%g,%g,%g,%g,%g,%g,%g\n'),num(1),num(2),num(3),num(4),num(5),num(6),num(7),num(8),num(9),num(10));
  fclose(fileID);
end