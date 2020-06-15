function [trueRes] = validate(results)

trueRes = 0;
A = csvalpha('driver_imgs_list.csv');
for i = 1:size(results,1)
     scale = 0.3;
     %index = find(strcmp(A(:,1), 'p002'))
     name = results(i,2);
     index = find(strcmp(A(:,3), name));
     class = A{index,2};
     
     if class==results{i,1}
         trueRes = trueRes + 1/size(results,1);
     end
end
