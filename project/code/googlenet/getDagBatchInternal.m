% --------------------------------------------------------------------
function inputs = getBatchInternal(opts, imdb, batch)
%getBatch is called by cnn_train.

%'imdb' is the image database.
%'batch' is the indices of the images chosen for this batch.

%'im' is the height x width x channels x num_images stack of images. If
%opts.batchSize is 50 and image size is 64x64 and grayscale, im will be
%64x64x1x50.
%'labels' indicates the ground truth category of each image.
%This function is where you should 'jitter' data.

% Add jittering here before returning im
imagenames = imdb.images.name(batch) ;
im = vl_imreadjpeg(imagenames);

imo = single(zeros([opts.imageSize(1:3), numel(im)])); 
for i = 1:numel(im)
  imt = im{i};
  w = size(imt, 2);
  h = size(imt, 1);
  factor = [opts.imageSize(1)/h, opts.imageSize(2)/w];

  imt = imresize(imt, 'scale', factor);

  imt(:, :, 1) = imt(:, :, 1) - opts.averageImage(1);
  imt(:, :, 2) = imt(:, :, 2) - opts.averageImage(2);
  imt(:, :, 3) = imt(:, :, 3) - opts.averageImage(3);

  if (rand() < opts.augmentation.flipping)
    
    imt  = fliplr(imt);
  end 
  if (rand() < opts.augmentation.cropping)
    tl_x = randi([1, floor(opts.imageSize(1)/10)]);
    tl_y = randi([1, floor(opts.imageSize(2)/10)]); 
    crop_height = randi([ceil(0.9*(opts.imageSize(1) - tl_x)), (opts.imageSize(1) - tl_x)]);
    crop_width = randi([ceil(0.9*(opts.imageSize(2) - tl_y)), (opts.imageSize(2) - tl_y)]);
    imc = cropping({imt}, tl_x, tl_y, crop_width, crop_height);
%    factor_c = [opts.imageSize(1)/crop_height, opts.imageSize(2)/crop_width];
    imt = imresize(imc{1}, [opts.imageSize(1), opts.imageSize(2)]);

  end
  if (rand() < opts.augmentation.illumChanges)

    hue_shift = min(max(normrnd(0, 0.1), -0.25), 0.25);
    imc = illuminationColorShift({imt}, hue_shift);
    imt = imc{1};

  end
  imo(:, :, :, i) = single(imt);

end
  
im = gpuArray(imo);
labels = imdb.images.labels(1, batch) ;

inputs = {'data', im, 'label', labels};

