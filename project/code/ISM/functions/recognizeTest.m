addpath('./vlfeat-0.9.9/toolbox/kmeans');
addpath('./vlfeat-0.9.9/toolbox/sift');
addpath(['./vlfeat-0.9.9/toolbox/mex/' mexext]);

load(strcat('codebook_variables/cluster_centers_c0'));
load(strcat('codebook_variables/cluster_occurences_c0'));
cc0 = cluster_centers;
co0 = cluster_occurrences;
load(strcat('codebook_variables/cluster_centers_c1'));
load(strcat('codebook_variables/cluster_occurences_c1'));
cc1 = cluster_centers;
co1 = cluster_occurrences;
load(strcat('codebook_variables/cluster_centers_c2'));
load(strcat('codebook_variables/cluster_occurences_c2'));
cc2 = cluster_centers;
co2 = cluster_occurrences;
load(strcat('codebook_variables/cluster_centers_c3'));
load(strcat('codebook_variables/cluster_occurences_c3'));
cc3 = cluster_centers;
co3 = cluster_occurrences;
load(strcat('codebook_variables/cluster_centers_c4'));
load(strcat('codebook_variables/cluster_occurences_c4'));
cc4 = cluster_centers;
co4 = cluster_occurrences;
load(strcat('codebook_variables/cluster_centers_c5'));
load(strcat('codebook_variables/cluster_occurences_c5'));
cc5 = cluster_centers;
co5 = cluster_occurrences;
load(strcat('codebook_variables/cluster_centers_c6'));
load(strcat('codebook_variables/cluster_occurences_c6'));
cc6 = cluster_centers;
co6 = cluster_occurrences;
load(strcat('codebook_variables/cluster_centers_c7'));
load(strcat('codebook_variables/cluster_occurences_c7'));
cc7 = cluster_centers;
co7 = cluster_occurrences;
load(strcat('codebook_variables/cluster_centers_c8'));
load(strcat('codebook_variables/cluster_occurences_c8'));
cc8 = cluster_centers;
co8 = cluster_occurrences;
load(strcat('codebook_variables/cluster_centers_c9'));
load(strcat('codebook_variables/cluster_occurences_c9'));
cc9 = cluster_centers;
co9 = cluster_occurrences;
    
%data_cropped = croppingDatabase();
eval_results = zeros(10,2);
  
      prob = zeros(10,1);
      probBow = zeros(10,1);
      
      image_idx_list=[55137:79726];
      maxScore = 0; class = 0;
      maxScoreBow = 0; classBow = 0;
      results = cell(numel(image_idx_list),2);
      resultsBow = cell(numel(image_idx_list),2);
      sDir = '../../data/test/';
      vImgNames = dir(fullfile(sDir, '*.jpg'));

      for imageID=image_idx_list
          
          img = single(imread(strcat(sDir, vImgNames(imageID).name)));
          img = imresize(img,0.3);
              for k = 0:9
                  kk = num2str(k);
                  [score,scoreBow]=apply_ism(eval(strcat('cc', kk)),eval(strcat('co', kk)), img);

                  probBow(k+1) = scoreBow; 
                  
                  if(score > maxScore) 
                      maxScore = score;
                      class = k;
                  end

                  if(scoreBow > maxScoreBow) 
                      maxScoreBow = scoreBow;
                      classBow = k;
                  end
              end
              
              probBow = probBow - min(probBow);
              
              summ = sum(probBow); 
              if(summ ~= 0)
                p = round(probBow/summ,1);
              else
                p = ones(10,1)*0.1;
                p = round(p,1);
              end
%               if sum(p)~=0 
%                   vImgNames(imageID).name
%                   diff = 1-sum(p);
%                   r = randi(10);
%                   p(r)=p(r)+diff;
%               end
              fileID = fopen('submission.csv','a');
              fprintf(fileID,strcat(vImgNames(imageID).name,',%g,%g,%g,%g,%g,%g,%g,%g,%g,%g\n'),p(1),p(2),p(3),p(4),p(5),p(6),p(7),p(8),p(9),p(10));
              fclose(fileID);
              
              results(imageID,:)={strcat('c',num2str(class)),vImgNames(imageID).name};
              resultsBow(imageID,:)={strcat('c',num2str(classBow)),vImgNames(imageID).name};
              class = 0;
              maxScore = 0;
              classBow = 0;
              maxScoreBow = 0;
              probBow = zeros(10,1);

  end
 