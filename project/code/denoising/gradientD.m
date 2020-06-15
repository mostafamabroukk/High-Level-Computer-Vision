% outputs the gradient operator D for a given image (we just need the dimensions)
% D is a ((Nx * Ny * 2) x (Nx * Ny))-matrix
% edgemat a boolean matrix which has the same size as the image. A 1 means
% here that the pixel is a edge pixel. Can be given as the empty array if
% no edgeconstraints should be removed

function [D] = gradientD(img)
    Nx = size(img,1);
    Ny = size(img,2);

    % construct D as matrices Dx, Dy which are put one below the other
    
    % First construct Dysimple as central building block of Dx => -1 on the
    % main diagonal and 1 on the upper minor diagonal
    Dysimple = speye(Nx) * -1;
    pos = find(Dysimple) + Nx; % positions for the minor diagonal
    pos = pos(1:end-1); % prevent from running outside the matrix
    Dysimple(pos) = 1;
    Dysimple(Nx*Nx) = 0; % the last line is a zero line
    
    
    %  we just repeat Dysimple n times on the main diagonal to get a
    %  (Nx*Ny) x (Nx*Ny)-matrix
    Dy = speye(Ny);
    Dysimple = sparse(Dysimple);
    Dy = kron(Dy, Dysimple);
    
    % Construct Dy by repeating a (Nx x Nx) -unit matrix on the main 
    % diagonal and a (Nx x Nx) unit matrix on the upper minor diagonal 
    % (Ny-2) times with Nx offset each time. Append then Ny 0 rows
    Dxmain = speye(Ny);
    Dxmain(Ny*Ny) = 0;
    Dxmain = kron(Dxmain, -speye(Nx));
    
    Dxminor = eye(Ny);
    pos = find(Dxminor) + Ny;
    pos = pos(1:end-1); % prevent from running outside the matrix
    Dxminor = zeros(Ny);
    Dxminor(pos) = 1;
    Dxminor = kron(sparse(Dxminor), speye(Nx));
    
    Dx = Dxmain + Dxminor;

   
    D = [Dx; Dy];
end

