function [trueRes] = validateExtra(results,class)

trueRes = 0;
for i = 1:size(results,1)
     scale = 0.3;
     %index = find(strcmp(A(:,1), 'p002'))
     name = results(i,2);
     
     if class==results{i,1}
         trueRes = trueRes + 1/size(results,1);
     end
end
