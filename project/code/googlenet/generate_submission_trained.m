function generate_submission_trained(smoothing, resultFile, outFile)

%resultfile should contain fields names (cellarray of names and scores (Nx10 array of scores)

load(resultFile);
outfileHandle = fopen(outFile, 'w');

scores(isnan(scores)) = 1.0;
fprintf(outfileHandle, 'img,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9\n');
for i=1:size(names, 2)

  name = names{i};
  fprintf(outfileHandle, '%s', name(17:length(name)));

  score = scores(i, :) + smoothing;
  score = score/sum(score);
  
  for j=1:10
    
    fprintf(outfileHandle, ',%.9f', score(1, j));
  end
  fprintf(outfileHandle, '\n');
 end

 fclose(outfileHandle);
