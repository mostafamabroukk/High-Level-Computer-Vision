function [res] = DiffusionFilter(img, g, lambda, tau, num_iter)
% takes an image 'img' and a cost function 'g' (a string) and performs 
% non-linear diffusion filtering according to the numerical scheme 
% described by Weickert in 'Lecture 16: Nonlinear Filters III: Nonlinear 
% Diffusion Filtering'
% possible values for 'g':
% 'img' = gray value image (or file path to an image that is than converted 
% to gray value image)
% 'pm' = Perona-Malik diffusivity
% 'c' = Charbonnier diffusivity
% 'lambda' = parameter for the Perona-Malik or Charbonnier diffusivity
% 'tau' = temporal step size
% 'num_iter' = number of iterations which equals the amount of time the
% diffusion evolves
    
    if (ischar(img)) % assume that the image is given as file path
        img = imread(img);
    end
    if (size(img,3)==3)
        img = rgb2gray(img);
    end

    % At the image borders, introduce an additional one-pixel 
    % layer by mirroring.
    % This ensures reflecting boundary conditions.
    res_ex = double(padarray(img,[1,1],'replicate'));

    [Nx,Ny] = size(img);
    res = zeros(Nx,Ny);
    
    
    for k=1:num_iter
        if (strcmp(g,'pm'))
            cost =  PeronaMalikCostFunction(res_ex, lambda);
        elseif (strcmp(g,'c'))
            cost =  CharbonnierCostFunction(res_ex, lambda);
        else
            error('g is not a valid string!');
        end
        
        for i = 1:Nx
           for j = 1:Ny
              % apply the diffusion filter as a discrete convolution with a 3x3
              % kernel that depends on the cost map 
              % coordinates in the extended image
              i_ex = i+1;
              j_ex = j+1;
              % The diffusivity approximation g^k_{i+1/2,j} is the arithmetic 
              % mean of g^k_{i,j} and g^k_{i+1,j} (k is the time step)
              gip05j = (cost(i_ex,j_ex) + cost(i_ex + 1,j_ex)) / 2;
              gim05j = (cost(i_ex,j_ex) + cost(i_ex - 1,j_ex)) / 2;
              gijp05 = (cost(i_ex,j_ex) + cost(i_ex,j_ex + 1)) / 2;
              gijm05 = (cost(i_ex,j_ex) + cost(i_ex,j_ex - 1)) / 2;

              res(i,j) = tau * gip05j * res_ex(i_ex+1, j_ex)...
                  + tau * gim05j * res_ex(i_ex-1, j_ex)...
                  + tau * gijp05 * res_ex(i_ex, j_ex+1)...
                  + tau * gijm05 * res_ex(i_ex, j_ex-1)...
                  + (1 - tau * (gip05j + gim05j + gijp05 + gijm05))...
                    * res_ex(i_ex,j_ex);
           end
        end
        res_ex = padarray(res,[1,1],'replicate');
    end
    
end

