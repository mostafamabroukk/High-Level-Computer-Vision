% 
% compute euclidean distance between x and y
% 


function d = dist_l2(x,y)
    assert(sum(abs(size(x) - size(y))) == 0, 'histogram dimension mismatch');

    d = sum((x-y).^2);
    % ...
