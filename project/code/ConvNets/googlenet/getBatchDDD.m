function fn = getBatchDDD(opts, meta)
  bopts.averageImage = meta.normalization.averageImage;
  bopts.imageSize = meta.normalization.imageSize;
  bopts.augmentation.flipping = opts.augmentation.flipping;
  bopts.augmentation.cropping = opts.augmentation.cropping;
  bopts.augmentation.illumChanges = opts.augmentation.illumChanges;
  bopts.augmentation.rotation = opts.augmentation.rotation;
  fn = @(x, y) getBatchInternal(bopts, x, y);

