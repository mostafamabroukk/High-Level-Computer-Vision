function imdb = setup_data_ddd(dataDir)

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
SceneJPGsPath = dataDir;

num_train_per_category = 1500; % max 1900
num_test_per_category  = 400; %can be up to 110
total_images = 10*num_train_per_category+10*num_test_per_category;

image_size = [224 224]; %downsampling data for speed and because it hurts
% accuracy surprisingly little

%imdb.images.data   = zeros(image_size(1), image_size(2), 3, total_images, 'single');
imdb.images.labels = zeros(1, total_images, 'single');
imdb.images.set    = zeros(1, total_images, 'uint8');

imdb.images.name = cell(total_images);
imdb.images.label = cell(total_images);

image_counter = 1;

categories = {'c0', 'c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8', 'c9'};
          
sets = {'train', 'val'};

fprintf('Loading %d train images from each category\n', ...
          num_train_per_category)
fprintf('Each image will be resized to %d by %d\n', image_size(1),image_size(2));

%hack to work with getSimpleNNBatch
imdb.imageDir = '.';


%Read each image and resize it to 224x224
for set = 1:length(sets)
    for category = 1:length(categories)
        cur_path = fullfile( SceneJPGsPath, 'train', categories{category});
        cur_images = dir( fullfile( cur_path,  '*.jpg') );
        
        if(set == 1)
            fprintf('Taking %d out of %d images in %s\n', num_train_per_category, length(cur_images), cur_path);
            cur_images = cur_images(1:num_train_per_category);
        elseif(set == 2)
            fprintf('Taking %d out of %d images in %s\n', num_test_per_category, length(cur_images), cur_path);
            cur_images = cur_images(num_train_per_category+1:num_train_per_category+num_test_per_category);
        end

        for i = 1:length(cur_images)
            
            
%            cur_image = imread(fullfile(cur_path, cur_images(i).name));
%            cur_image = single(cur_image);
%            cur_image = imresize(cur_image, image_size);
                       
            % Stack images into a large 224 x 224 x 3 x total_images matrix
            % images.data
%            size(cur_image)
%            size(imdb.images.data(:, :, :, image_counter))
            %imdb.images.data(:,:,:,image_counter) = cur_image;            
            imdb.images.labels(  1,image_counter) = category;
            imdb.images.label{image_counter} = category;
            imdb.images.set(     1,image_counter) = set; %1 for train, 2 for test (val?)
            imdb.images.name{image_counter} = fullfile(cur_path, cur_images(i).name);
            image_counter = image_counter + 1;
%            sys.exit();
        end
    end
end


