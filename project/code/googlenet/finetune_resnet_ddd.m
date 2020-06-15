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

modelPath = '../matconvnet-1.0-beta20/data/models/imagenet-resnet-50-dag.mat' ;

net = dagnn.DagNN.loadobj(modelPath);
fprintf('net loaded\n');


fc10Block = dagnn.Conv('size', [1 1 2048 10], 'stride', 1, 'pad', 0, 'hasBias', true);
net.addLayer('fc10', fc10Block, {'pool5'}, {'fc10'}, {'fc10_filter', 'fc10_bias'});
net.setLayerInputs('prob', {'fc10'});
net.removeLayer({'fc1000'});

net.rebuild();

net.addLayer('loss', dagnn.Loss('loss', 'softmaxlog'), {'prob', 'label'}, 'objective');
net.addLayer('top1err', dagnn.Loss('loss', 'classerror'), {'prob', 'label'}, 'top1err');
net.addLayer('top5err', dagnn.Loss('loss', 'topkerror', 'opts', {'topK', 5}), {'prob', 'label'}, 'top5err');
net.getInputs()
net.getOutputs()


li = net.getLayerIndex('fc10');

fc10params = net.layers(li).block.initParams();
pi = net.getParamIndex(net.layers(li).params);
fc10params = cellfun(@gather, fc10params, 'UniformOutput', false);
[net.params(pi).value] = deal(fc10params{:});
%net.initParams();



%{
%magic constant
f = 1/20000;
%replace last fc layer with appropriate number of output neurons
net.layers{end-1}.weights{1} = f*randn(1, 1, 4096, 10, 'single');
net.layers{end-1}.weights{2} = zeros(10, 1, 'single');
net.layers{end-1}.size = [1 1 4096 10];
%replace last layer with softmaxloss
net.layers{end} = struct('name', 'prob', 'type', 'softmaxloss', 'precious', 0) 
fprintf('fc layer replaced\n');
%}
fprintf('training...\n');

opts.gpus = [2];

opts.augmentation.flipping = 0.0;
opts.augmentation.cropping = 0.1;
opts.augmentation.illumChanges = 0.1;
opts.augmentation.rotation = 0.1;
opts.expDir = fullfile('data', 'res-aug-v3');


[~,info]=cnn_train_dag(net, imdb, getDagBatchDDD(opts, net.meta), opts) ;

fprintf('trained\n');
