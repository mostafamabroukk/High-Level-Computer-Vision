% meta script that calls several instances of 'testing'-script

%{
% test run 001: DiffusionFilter Carbonnier Cost Function with different
% lambdas, taus and num_iters
images = {'..\..\data\night_images\by_driver\dn_01\img_1.png'};
cost_functions = {'c'};
lambdas = {5,10,15,20};
taus = {0.1,0.2,0.5};
param_structure = {'img', 'g', 'lambda', 'tau', 'num_iter'};
num_iters = {100, 200, 300, 500, 1000};

testing(@DiffusionFilter,{images,cost_functions,lambdas,taus,num_iters},...
    param_structure,'001');
%}

%{
% test run 002: DiffusionFilter Perona-Malik COst Function with different
% lambdas, taus and num_iters
images = {'..\..\data\night_images\by_driver\dn_01\img_1.png'};
cost_functions = {'pm'};
lambdas = {5,10,15,20};
taus = {0.1,0.2,0.3};
param_structure = {'img', 'g', 'lambda', 'tau', 'num_iter'};
num_iters = {100, 200, 300, 500, 700};

testing(@DiffusionFilter,{images,cost_functions,lambdas,taus,num_iters},...
    param_structure,'002');
%}

%{
% test run 003: L1-denoising with different
% theta and number of iterations
images = {'..\..\data\night_images\by_driver\dn_01\img_1.png'};
lambdas = {10};
max_iters = {500, 1000, 2000, 5000};
taus = {0.5};
sigmas = {0.5};
thetas = {0.1, 0.3, 0.5, 0.7, 1.0, 1.5};

param_structure = {'img', 'lambda', 'max_iter', 'tau', 'sigma', 'theta'};


testing(@P53_PDHG,{images,lambdas,max_iters,taus,sigmas,thetas},...
    param_structure,'003');
%}

%{
% test run 004: L1-denoising with different
% taus and number of iterations
images = {'..\..\data\night_images\by_driver\dn_01\img_1.png'};
lambdas = {10};
max_iters = {500, 1000, 2000, 3000};
taus = {0.1, 0.3, 0.5, 0.7, 1.0, 1.5};
sigmas = {0.5};
thetas = {0.5};

param_structure = {'img', 'lambda', 'max_iter', 'tau', 'sigma', 'theta'};


testing(@P53_PDHG,{images,lambdas,max_iters,taus,sigmas,thetas},...
    param_structure,'004');
%}


% cancled due to poor results.. lambda to high?
%{
% test run 004 (again): L1-denoising with different
% taus and number of iterations
% tau * sigma < 1/8
images = {'..\..\data\night_images\by_driver\dn_01\img_1.png'};
lambdas = {7,10,13,18,25};
max_iters = {500, 1000, 2000, 3000};
taus = {0.1, 0.2, 0.3};
sigmas = {0.1, 0.2, 0.3};
thetas = {0.5, 0.75, 1.0};

param_structure = {'img', 'lambda', 'max_iter', 'tau', 'sigma', 'theta'};


testing(@P53_PDHG,{images,lambdas,max_iters,taus,sigmas,thetas},...
    param_structure,'004');
%}


%{
% test run 005: L1-denoising with different
% taus and number of iterations
% tau * sigma < 1/8, but smaller lambdas
images = {'..\..\data\night_images\by_driver\dn_01\img_1.png'};
lambdas = {0.8, 1, 1.3, 1.7, 2.2};
max_iters = {500, 1000, 2000, 3000};
taus = {0.1, 0.2, 0.3};
sigmas = {0.1, 0.2, 0.3};
thetas = {0.5, 0.75, 1.0};

param_structure = {'img', 'lambda', 'max_iter', 'tau', 'sigma', 'theta'};


testing(@P53_PDHG,{images,lambdas,max_iters,taus,sigmas,thetas},...
    param_structure,'005');
%}


%{
% test run 006: L1-denoising with  sutiable parameters:
% lambda = 1.3 max_iter = 500 tau = 0.3 sigma = 0.3 theta = 0.5
% on different images

images = getAllFiles('..\..\data\night_images\by_driver\dn_01');
lambdas = {1.3};
max_iters = {500};
taus = {0.3};
sigmas = {0.3};
thetas = {0.5,};

param_structure = {'img', 'lambda', 'max_iter', 'tau', 'sigma', 'theta'};


testing(@P53_PDHG,{images,lambdas,max_iters,taus,sigmas,thetas},...
    param_structure,'006');
%}


%{
% test run 007: Postprocessing with Perona-Malik Diffusion 
% 
images = {'testresults\run_006\P53_PDHG_lambda=1.3_max_iter=500_tau=0.3_sigma=0.3_theta=0.5_time=14.951s.png'};
cost_functions = {'pm'};
lambdas = {10,15,20,25};
taus = {0.1,0.2};
param_structure = {'img', 'g', 'lambda', 'tau', 'num_iter'};
num_iters = {100, 200, 300, 500, 1000};

testing(@DiffusionFilter,{images,cost_functions,lambdas,taus,num_iters},...
    param_structure,'007');
%}


% test run 008: Postprocessing with Perona-Malik Diffusion with parameters
% that do not smooth that much
images = {'testresults\run_006\P53_PDHG_lambda=1.3_max_iter=500_tau=0.3_sigma=0.3_theta=0.5_time=14.951s.png'};
cost_functions = {'pm'};
lambdas = {5,7,10,15};
taus = {0.1,0.2};
param_structure = {'img', 'g', 'lambda', 'tau', 'num_iter'};
num_iters = {50, 100, 150, 200};

testing(@DiffusionFilter,{images,cost_functions,lambdas,taus,num_iters},...
    param_structure,'008');