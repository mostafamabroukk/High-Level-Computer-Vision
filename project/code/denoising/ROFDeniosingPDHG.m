function [img_trans] = ROFDeniosingPDHG(img, max_iter, tau, sigma, theta, lambda)
% img = gray value image (or file path to an image that is than converted 
% to gray value image)
% max_iter = maximal number of iterations
% tau, sigma = step sizes for the primal/dual step
% theta = step size for the extra gradient step
% lambda = parameter of the functional (weights TV)

    if (ischar(img)) % assume that the image is given as file path
        img = rgb2gray(imread(img));
    end

    N = numel(img);
    D = gradientD(img);
    DStar = D';
    img_vec = double(img(:));

    % start vectors
    u_kp1 = zeros(N,1);
    p_kp1 = zeros(N*2,1);
    
    for i=1:max_iter
        % New iteration => shift variables
        u_k = u_kp1;
        p_k = p_kp1;
        
        % Primal update step
        u_kp1 = (u_k - tau * (DStar * p_k - img_vec)) / (1 + tau);
        
        % Extragradient step
        ubar_kp1 = u_kp1 + theta*(u_kp1 - u_k);
        
        % Dual update step
        pbar_k = p_k + sigma * (D * ubar_kp1);
        % projection on circles
        pbar_k = reshape(pbar_k, [N, 2]);
        denom = max(1, sqrt(pbar_k(:,1).^2 + pbar_k(:,2).^2) / lambda);
        p_kp1 = zeros(N,2);
        p_kp1(:,1) = pbar_k(:,1) ./ denom;
        p_kp1(:,2) = pbar_k(:,2) ./ denom;
        p_kp1 = p_kp1(:);
    end

    img_trans = uint8(reshape(u_kp1, size(img)));
end

