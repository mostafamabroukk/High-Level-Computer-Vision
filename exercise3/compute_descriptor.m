%
% compute the HOG descriptor
%

function [DESC, CELLS] = compute_descriptor(PARAMS, img)

  [img_mag, img_ori] = image_grad(PARAMS, img);

  CELLS = cell(PARAMS.num_cells_height, PARAMS.num_cells_width);
  DESC = [];

  for by = 0:PARAMS.num_cells_height - 1
    for bx = 0:PARAMS.num_cells_width - 1
      cell_mag = get_cell(img_mag, PARAMS, bx, by);
      cell_ori = get_cell(img_ori, PARAMS, bx, by);
      
      %
      % Compute gradient orientation histogram for one cell of the HOG
      % descriptor in comp_cell_hist.m
      %
      h = comp_cell_hist(PARAMS, cell_mag, cell_ori);
      CELLS{by+1, bx+1} = h;
    end
  end

  assert(mod(PARAMS.num_cells_width, 2) == 0 && ...
         mod(PARAMS.num_cells_height, 2) == 0);
  assert( size(CELLS{1, 1},2)==1 ); %CELL elements must be column vectors

     
     
  %
  % L2 normalization for overlapping blocks 
  % Four cells are combined into one block
  % One cell maximumly contributes to 4 blocks
  %
  
  
  
  for by = 1:(PARAMS.num_cells_height-1)
      for bx = 1:(PARAMS.num_cells_width-1)
          
          cur_cell=CELLS(by,bx);
          r_cell=CELLS(by,bx+1);
          b_cell=CELLS(by+1,bx);
          br_cell=CELLS(by+1,bx+1);
          
          v = cell2mat([cur_cell r_cell b_cell br_cell]');
          %v = cellfun(@(x) x/norm(cell2mat(v')), v, 'un', 0);

          % add the L2 block-normalization step here
%           v = v / sqrt(sum(v.^2) + PARAMS.eps^2);
          
          DESC = [DESC; v];    
      end    
  end
  
end



