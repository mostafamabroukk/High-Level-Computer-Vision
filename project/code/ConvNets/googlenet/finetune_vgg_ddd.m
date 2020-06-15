%ALWAYS RUN DIRECT FROM CONTAINING FOLDER

%structure:

% project 
%   |
%   |--code
%   |   |
%   |   |--$containing_folder_of_this_script
%   |   |   |
%   |   |   |--cnn_train.m
%   |   |   |
%   |   |   |--setup_data_ddd.m
%   |   |   |
%   |   |   |--getBatchDDD.m
%   |   |   |
%   |   |   |--getBatchInternal.m
%   |   |   ...
%   |   |--$matconvnet_folder
%   |   |   |
%   |   |   |--data
%   |   |   ... |
%   |   |       |--models
%   |   |       ... |
%   |   |           |--imagenet-vgg-verydeep-16.mat
%   |   |           ...
%   |   |--$vlfeat_folder
%   |   | 
%   |   |--all data augmentation scripts (cropping.m, illuminationColorShift.m,...)
%   |   
%   |--data
%   ... |
%       |--train
%       |   |
%       |   |--c0
%       |   |
%       |   |--c1
%       |   |
%       |   |--c...
%       |   ...
%       |   |--c9
%       |
%       |--test
%       ...
rng(2560794);
addpath(genpath('../'));
run('../vlfeat-0.9.20/toolbox/vl_setup.m');
run('../matconvnet-1.0-beta20/matlab/vl_setupnn.m');
imdb = setup_data_ddd('../../data');

modelPath = '../matconvnet-1.0-beta20/data/models/imagenet-vgg-verydeep-16.mat' ;

net = load(modelPath);
fprintf('net loaded\n');

%magic constant
f = 1/20000;
%replace last fc layer with appropriate number of output neurons
net.layers{end-1}.weights{1} = f*randn(1, 1, 4096, 10, 'single');
net.layers{end-1}.weights{2} = zeros(10, 1, 'single');
net.layers{end-1}.size = [1 1 4096 10];
%replace last layer with softmaxloss
net.layers{end} = struct('name', 'prob', 'type', 'softmaxloss', 'precious', 0) 
fprintf('fc layer replaced\n');

fprintf('training...\n');

opts.gpus = [2];

opts.augmentation.flipping = 0.0;
opts.augmentation.cropping = 0.1;
opts.augmentation.illumChanges = 0.1
opts.augmentation.rotation = 0.1;
opts.expDir = fullfile('data', 'exp-aug-v3');


[~,info]=cnn_train(net, imdb, getBatchDDD(opts, net.meta), opts) ;

fprintf('trained\n');
