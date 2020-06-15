% 
% compute chi2 distance between x and y
% 

function d = dist_chi2(x,y)

    assert(sum(abs(size(x) - size(y))) == 0, 'histogram dimension mismatch');

    d = sum( (x-y).^2./(x + y + 0.0000001 ));
  % ...
