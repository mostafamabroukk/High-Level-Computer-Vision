function imdb = setup_data_2()

% The setup_data function loads the training and testing images into
% MatConvNet's imdb structure.

% The commented out code can cache the image database so it isn't rebuilt
% with each run. I found it fast enough to rebuild and less likely to cause
% errors when you change the way images are preprocessed.

% imdb_filename = 'imdb.mat';
% if exist(imdb_filename, 'file')
%   imdb = load(imdb_filename) ;
% else
%  imdb = setup_data();
%   save(imdb_filename, '-struct', 'imdb') ;
% end

%code for Computer Vision, Georgia Tech by James Hays


%This path is assumed to contain 'test' and 'train' which each contain 15
%subdirectories. The train folder has 100 samples of each category and the
%test has an arbitrary amount of each category. This is the exact data and
%train/test split.
SceneJPGsPath = '../data/15SceneData/';

num_train_per_category = 100;
num_test_per_category  = 100; %can be up to 110
total_images = 15*num_train_per_category + 15 * num_test_per_category;

image_size = [64 64]; %downsampling data for speed and because it hurts
% accuracy surprisingly little

imdb.images.data   = zeros(image_size(1), image_size(2), 1, total_images, 'single');
imdb.images.labels = zeros(1, total_images, 'single');
imdb.images.set    = zeros(1, total_images, 'uint8');
image_counter = 1;

categories = {'bedroom', 'coast', 'forest', 'highway', ...
              'industrial', 'insidecity', 'kitchen', ...
              'livingroom', 'mountain', 'office', 'opencountry', ...
              'store', 'street', 'suburb', 'tallbuilding'};
          
sets = {'train', 'test'};

fprintf('Loading %d train and %d test images from each category\n', ...
          num_train_per_category, num_test_per_category)
fprintf('Each image will be resized to %d by %d\n', image_size(1),image_size(2));

%Read each image and resize it to 224x224
for set = 1:length(sets)
    for category = 1:length(categories)
        cur_path = fullfile( SceneJPGsPath, sets{set}, categories{category});
        cur_images = dir( fullfile( cur_path,  '*.jpg') );
        
        if(set == 1)
            fprintf('Taking %d out of %d images in %s\n', num_train_per_category, length(cur_images), cur_path);
            cur_images = cur_images(1:num_train_per_category);
        elseif(set == 2)
            fprintf('Taking %d out of %d images in %s\n', num_test_per_category, length(cur_images), cur_path);
            cur_images = cur_images(1:num_test_per_category);
        end

        for i = 1:length(cur_images)

            cur_image = imread(fullfile(cur_path, cur_images(i).name));
            cur_image = single(cur_image);
            if(size(cur_image,3) > 1)
                fprintf('color image found %s\n', fullfile(cur_path, cur_images(i).name));
                cur_image = rgb2gray(cur_image);
            end
            cur_image = imresize(cur_image, image_size);
                       
            % Stack images into a large 224 x 224 x 1 x total_images matrix
            % images.data
            
            imdb.images.data(:,:,1,image_counter) = cur_image;            
            imdb.images.labels(  1,image_counter) = category;
            imdb.images.set(     1,image_counter) = set; %1 for train, 2 for test (val?)
            
            image_counter = image_counter + 1;
        end
        
         
        % I am very much convinced this is not the right place to "supplement
        % code". 
        
        % At this point images are loaded only for one category. To
        % subtract the mean image, we need to load all the images to
        % compute the mean, and only then we can subtract. I don't think
        % calculating the mean 'per category' is what is meant to do in
        % this exercise.
        
        % In other words, the code should be supplemented after all the
        % images are loaded (because we need to subtract the training mean
        % from both the training and testing images).
        
        % The following code is thus completely commented out.
        
        %{
         %%%%%%% Supplement Code.
         %%%% Supplement code here to do mean subtraction.
         %%%%%%%
         
         % 4D struct with width x height x channels x total_images
         % I assume to get gray images since the above code casts the
         % images to gray images
         im = imdb.images.data; 
         
         % an array of size total_images that contains a 1 of for each
         % image that is not the zero matrix otherwise 0
         nonz = squeeze(any(any(im,1),2));
         num_nz_ims = nnz(nonz); % number of nonzero images
         
         mean_im = sum(im,4) / num_nz_ims;
         
         % just a stack of images where the first 'num_nz_ims' ones are the
         % mean image and all other images are zero
         to_sub = cat(3, repmat(mean_im, 1, 1, num_nz_ims),...
             repmat(zeros(size(im,1), size(im,2)), 1, 1,...
             total_images - num_nz_ims));
         
         im = squeeze(im) - to_sub;
         
         imdb.images.data = im;
        
        %}
    end
    
    
     
      
end

train_image_mean = mean(imdb.images.data(:, :, 1, (imdb.images.labels == 1)), 4);
imdb.images.data = bsxfun(@minus, imdb.images.data, train_image_mean);




