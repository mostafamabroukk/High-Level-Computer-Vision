show_part_a = true;
show_part_b= true;


%setting up Matconvnet framework, downloading VGG_F and running a VGG-F demo(Can be commented after the first compilation)
%If your machine has GPU, you can speed up training CNNs 
%by uncommenting vl_compilenn('enableGpu', true) 
quickStartDemo()

%
% Question 5 part a
%

if show_part_a
    
% load the pre-trained CNN
net = load('imagenet-vgg-f.mat') ;
net = vl_simplenn_tidy(net) ;

%% extract deCAF feature for each image
% Choose only 100 images for train and 100 images for test for each class
% make sure your training set and test set is the same as previous parts.
% Supplement Code Here

% sample code for extracting deCAF feature for one image.
% sample load and preprocess an image
% im = imread('peppers.png') ;
% im_ = single(im) ; % note: 0-255 range
% im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
% im_ = bsxfun(@minus, im_, net.meta.normalization.averageImage) ;
% 
% % run the CNN
% res = vl_simplenn(net, im_) ;
% deCAF{iIndex}={imgSets.ImageLocation(iIndex) ,res(20).x};
% disp(['image:',num2str(iIndex)])


%% apply Linear SVM for classification
%deCAF variable contain deCAF features for each image and the corresponding
%lable. make sure your training set and test set is the same as previous
%parts. LinearSVMClassifier should be suplemented.
LinearSVMClassifier(deCAF)


end
%
% Question 5 part b
%
if show_part_b

bonus_options;

%configure the Net

net = bonus_cnn_init();

% Prepare data

imdb = bonus_setup_data(net.normalization.averageImage);


%Train

[net, info] = cnn_train(net, imdb, @getBatch_bonus, ...
    opts, ...
    'val', find(imdb.images.set == 2)) ;

end