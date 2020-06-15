
Cs = [0.001, 0.01, 0.1, 1];
N1 = 80;
N2 = 80;
[X, y] = get_train_dataset_2d(N1, N2, 15, 5);

a = 25;




for i = 1:size(Cs, 2)
  C = Cs(:, i);
  model = svmlearn(X, y, C);
  
  [alphaSorted, alphaSortIdx] = sort(model.alpha, 'descend');
  svs = X(alphaSortIdx(1:model.nsv), :);  
  hold on;
  subplot(2, 2, i);
  pos = X(find(y==1), :);
  posX = pos(:, 1);
  posY = pos(:, 2);
  scatter(posX, posY, a, 'red', '+');
  hold on;
  subplot(2, 2, i);
  neg = X(find(y==-1), :);
  negX = neg(:, 1);
  negY = neg(:, 2);
  scatter(negX, negY, a, 'blue', 'o');

  hold on;
  subplot(2, 2, i);
  scatter(svs(:, 1), svs(:, 2), 3*a, 'magenta', 'o');
  
  min_x1 = min(X(:, 1));
  max_x1 = max(X(:, 1));
  min_x2 = min(X(:, 2));
  max_x2 = max(X(:, 2));
  
  lineX = [min_x2, max_x2]
  lineY = -(model.w(1, 1) * lineX + model.w0) / model.w(2, 1)
  hold on;
  subplot(2, 2, i);
  line(lineX, lineY)
  axis equal;
  axis([1.5*min_x1, 1.5*max_x1, 1.5*min_x2, 1.5*max_x2]);
  
  title(['C = ', num2str(C)]);
  
  hold off;

  
end

tightfig;

