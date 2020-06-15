function init_matconvnet()

%code for Computer Vision, Georgia Tech by James Hays
%based off the MNIST and CIFAR examples from MatConvNet

addpath('matconvnet-1.0-beta16/matlab')

% setup Matconvnet
vl_setupnn

% compiling 

%vl_compilenn
% if GPU is available
vl_compilenn('enableGpu', true)


%It might actually be problematic to run vl_setup, because VLFeat has a
%version of vl_argparse that conflicts with the matconvnet version. You
%shouldn't need VLFeat for this project.
% run(fullfile('vlfeat-0.9.20', 'toolbox', 'vl_setup.m'));

end
