% computes a cell array consisting of all combinations of the contents of
% an arbitrary number of input cell arrays
% source: http://stackoverflow.com/questions/8492277/matlab-combinations-of-an-arbitrary-number-of-cell-arrays

function combMat = allcombs(varargin)
  sizeVec = cellfun('prodofsize', varargin);
  indices = fliplr(arrayfun(@(n) {1:n}, sizeVec));
  [indices{:}] = ndgrid(indices{:});
  combMat = cellfun(@(c,i) {reshape(c(i(:)), [], 1)}, ...
                    varargin, fliplr(indices));
  combMat = [combMat{:}];
end