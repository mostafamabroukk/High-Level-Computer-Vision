% 
% compute intersection distance between x and y
% return 1 - intersection, so that smaller values also correspond to more similart histograms
% 

function d = dist_intersect(x, y)

    assert(sum(abs(size(x) - size(y))) == 0, 'histogram dimension mismatch');
    assert(size(x, 1) == 1 | size(x, 2) == 1, 'input not a vector');
    if (size(x, 2) == 1) % nx1 vector -> transform to 1xn
        x = x';
        y = y'; % we know both have the same dim
        
    end
    
    cmp = [x; y];
    d = 1-sum(min(cmp));
        
end

  