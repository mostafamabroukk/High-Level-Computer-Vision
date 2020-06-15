
%code for Computer Vision, Georgia Tech by James Hays
%based off the MNIST example from MatConvNet

%opts.expDir is where trained networks and plots are saved.
opts.expDir = fullfile('..','data','bonus') ;

%opts.batchSize is the number of training images in each batch. You don't
%need to modify this.
opts.batchSize = 50 ;

% opts.learningRate is a critical parameter that can dramatically affect
% whether training succeeds or fails. For most of the experiments in this
% project the default learning rate is safe.
opts.learningRate = 0.0001 ;

% opts.numEpochs is the number of epochs. If you experiment with more
% complex networks you might need to increase this. Likewise if you add
% regularization that slows training.
opts.numEpochs = 90 ;

% An example of learning rate decay as an alternative to the fixed learning
% rate used by default. This isn't necessary but can lead to better
% performance.
% opts.learningRate = logspace(-4, -5.5, 300) ;
% opts.numEpochs = numel(opts.learningRate) ;

%opts.continue controls whether to resume training from the furthest
%trained network found in opts.batchSize. If you want to modify something
%mid training (e.g. learning rate) this can be useful. You might also want
%to resume a network that hit the maximum number of epochs if you think
%further training can improve accuracy.
opts.continue = false ;

%GPU support is off by default.
% opts.gpus = [] ;

% This option lets you control how many of the layers are fine-tuned.
% opts.backPropDepth = 2; %just retrain the last real layer (1 is softmax)
% opts.backPropDepth = 9; %just retrain the fully connected layers
% opts.backPropDepth = +inf; %retrain all layers [default]
