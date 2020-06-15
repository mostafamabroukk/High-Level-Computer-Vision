function [img_trans] = P53_PDHG(img, lambda, max_iter, tau, sigma, theta)
% solves the functional specified in task P5.3 using the Primal Dual Hybrid
% Gradient Algorithm
% the functional: min_u max_{p_{i,j} leq lambda} scP(Du, p) + norm(u-f)_1
% Notice that this is the same as ROF-denoising with the small differecne
% that we use here the 1-norm instead of the 2-norm. This will in comparison
% to ROF-denoising only affect the primal update step of the PDHG algorithm

% img = gray value image (or file path to an image that is than converted 
% to gray value image)
% max_iter = maximal number of iterations
% tau, sigma = step sizes for the primal/dual step
% theta = step size for the extra gradient step
% lambda = parameter of the functional (weights TV)

    if (ischar(img)) % assume that the image is given as file path
        img = imread(img);
    end
    if (size(img,3)==3)
        img = rgb2gray(img);
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
        u_help = u_k - (tau * DStar * p_k) - img_vec; % time saver
        to_max = cat(2, abs(u_help) - tau, zeros(N,1));
        u_kp1 = img_vec + max(to_max,[],2) .* sign(u_help); % rowwise max
        
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

