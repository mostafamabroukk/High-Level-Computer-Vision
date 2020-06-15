function [] = denoiseImages()
addpath(genpath('../dataAugmentation'));
images = readInImages('jpg','../../data/night_images_jpeg/by_class/c9_TalkingToPassenger');

% denoise the images using PDHG algorithm with suitable parameters
N = numel(images);
lambdas = num2cell(ones(N,1) * 1.3);
max_iters = num2cell(ones(N,1) * 500);
taus = num2cell(ones(N,1) * 0.3);
sigmas = num2cell(ones(N,1) * 0.3);
thetas = num2cell(ones(N,1) * 0.5);

im_PDGH = cellfun(@(i,l,mi,t,s,th) P53_PDHG(i, l, mi, t, s, th),...
    images, lambdas, max_iters, taus, sigmas, thetas, 'un', 0);


% destroy the level sets a bit using a Diffusion Filter
[gs{1:N}] = deal('c');
gs = gs';
lambdas = num2cell(ones(N,1) * 10);
taus = num2cell(ones(N,1) * 0.1);
num_iters = num2cell(ones(N,1) * 50);

im_diff = cellfun(@(i, g, l, t, ni) DiffusionFilter(i, g, l, t, ni),...
    im_PDGH, gs, lambdas, taus, num_iters, 'un', 0);



% use affine rescaling to bring the endresult in the range [0,255]
low_bounds = num2cell(zeros(N,1));
up_bounds = num2cell(ones(N,1) * 255);

res = cellfun(@(i, lb, ub) uint8(affineRescaling(i, lb, ub)),...
    im_diff, low_bounds, up_bounds, 'un', 0);

outputPath = './NightDenoised/c9';
writeImages(res, outputPath);
end
