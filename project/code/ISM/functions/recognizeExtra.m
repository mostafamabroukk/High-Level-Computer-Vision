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
  
  for ll=2:2

      image_idx_list=[1:27];
      maxScore = 0; class = 0;
      maxScoreBow = 0; classBow = 0;
      results = cell(numel(image_idx_list),2);
      resultsBow = cell(numel(image_idx_list),2);
      sDir = strcat('../../data/extractedImages/by_class/c',num2str(ll),'/')
      vImgNames = dir(fullfile(sDir, '*.jpg'));

      for imageID=image_idx_list
          [imageID ll]
          
          img = single(data_cropped{imageID});
          img = imresize(img,0.3);
              for k = 0:9
                  kk = num2str(k);
                  [score,scoreBow]=apply_ism(eval(strcat('cc', kk)),eval(strcat('co', kk)), img);

                  if(score > maxScore) 
                      maxScore = score;
                      class = k;
                  end

                  if(scoreBow > maxScoreBow) 
                      maxScoreBow = scoreBow;
                      classBow = k;
                  end

              end
              results(imageID,:)={strcat('c',num2str(class)),vImgNames(imageID).name};
              resultsBow(imageID,:)={strcat('c',num2str(classBow)),vImgNames(imageID).name};
              class = 0;
              maxScore = 0;
              classBow = 0;
              maxScoreBow = 0;
      end
      eval_results(ll+1,1) = validateExtra(results,strcat('c',num2str(ll)));
      eval_results(ll+1,2) = validateExtra(resultsBow,strcat('c',num2str(ll)));
      eval_results

  end
 