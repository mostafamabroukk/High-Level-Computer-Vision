%
% Visualization of the training data, support vectors, and linear SVM decision boundary.
% 
% The linear SVM decision boundary is defined by f(x) = w'*x + w0
%
% parameters:
%
% X - matrix of training points (one row per point), you can assume that points are 2 dimensional
% y - vector of point labels (+1 or -1)
% model.w and model.w0 are parameters of the decision function
% model.alpha is a vector of Lagrange multipliers

function vis_svm(X, y, model)

  hold on;
  % visualize positive and negative points 
  % ...
  a = 25;
  
  pos = X(find(y==1), :);
  posX = pos(:, 1);
  posY = pos(:, 2);
  scatter(posX, posY, a, 'red', '+');
  
  neg = X(find(y==-1), :);
  negX = neg(:, 1);
  negY = neg(:, 2);
  scatter(negX, negY, a, 'blue', 'o');
  
  
  % visualize support vectors
  % ...
  
  % This is how this line should really look like:
  % svs = X(find(model.alpha > threshold), :);
  % but we have no way to calculate the threshold since C is not passed. So
  % we improvize:
  
  [alphaSorted, alphaSortIdx] = sort(model.alpha, 'descend');
  svs = X(alphaSortIdx(1:model.nsv), :);  
  
  scatter(svs(:, 1), svs(:, 2), 3*a, 'magenta', 'o');
  

  % visualze decision boundary 
  % ...
  

  min_x1 = min(X(:, 1));
  max_x1 = max(X(:, 1));
  min_x2 = min(X(:, 2));
  max_x2 = max(X(:, 2));
  
  lineX = [min_x2, max_x2]
  lineY = -(model.w(1, 1) * lineX + model.w0) / model.w(2, 1)
  line(lineX, lineY)
  

  axis equal;
  axis([1.5*min_x1, 1.5*max_x1, 1.5*min_x2, 1.5*max_x2]);
  hold off;

