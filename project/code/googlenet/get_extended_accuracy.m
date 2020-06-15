function stats = get_extended_accuracy(modelPath, runDaylight, runNight)

% IMPORTANT: keep order of directories same as in ../../data/train
% there are no explicit labels given, class matching between datasets relies on ordering of directories!

%modelPath = 'data/exp/net-epoch-6.mat';

addpath(genpath('../'));
vl_setup;
vl_setupnn;
vl_compilenn;

fprintf('loading model...\n');
net = load(modelPath);

if isfield(net, 'net');
  net = net.net;
end

opts.isDag = isfield(net, 'params');

if (~opts.isDag)
  net.layers = net.layers(1:36);
end

if (opts.isDag)
  net = dagnn.DagNN.loadobj(net);
end

fprintf('net loaded\n');
opts.gpus = [];
%uncomment the following line to run on GPU
%opts.gpus = [2];

if (length(opts.gpus) > 0)
  if (opts.isDag)
    net.move('gpu');
  else
    net = vl_simplenn_move(net, 'gpu');
  end
  fprintf('net moved to gpu\n');
end



if (runDaylight)
  fprintf('running on daylight images\n');
  daylightDir = '../../data/validationDatabaseOrdered';
  opts.dayCrop = false;
  dayStats = get_accuracy_on_dir(daylightDir, net, opts);

  for dCl = 1:numel(dayStats.accuracy)
    fprintf('accuracy on class  %d is %.5f\n', dCl, dayStats.accuracy{dCl});
  end
  fprintf('overall daylight accuracy is %.5f\n', dayStats.totalAccuracy); 
  fprintf('total daylight logloss is %.5f\n', dayStats.totalLogLoss); 
  stats.day = dayStats;
end



if (runNight)
  fprintf('running on night images\n');
  nightDir = '../../data/night_images_jpeg';
  opts.dayCrop = false;
  nightStats = get_accuracy_on_dir(nightDir, net, opts);


  for nCl = 1:numel(nightStats.accuracy)
    fprintf('accuracy on class  %d is %.5f\n', nCl, nightStats.accuracy{nCl});
  end
  fprintf('overall nighttime accuracy is %.5f\n', nightStats.totalAccuracy); 
  fprintf('total nighttime logloss is %.5f\n', nightStats.totalLogLoss); 
  stats.night = nightStats;

end


% -----------------------------------------------------------
function stats = get_accuracy_on_dir(testSetDir, net, opts)



byClassDir = fullfile(testSetDir, 'by_class');

classes = dir(fullfile(byClassDir, 'c*'));

accuracy = cell(numel(classes),1);
errors = cell(numel(classes),1);
logloss = cell(numel(classes),1);

tCt = 0;
modelY = [];
trueY = [];
for dCl = 1:numel(classes)
  fprintf('running on class %d\n', dCl);
  errors{dCl} = 0;
  logloss{dCl} = 0.0;
  classDirContents_jpg = dir(fullfile(byClassDir, classes(dCl).name, '*.jpg'));
  
  contentsCell = struct2cell(classDirContents_jpg);
  
  namesCell = contentsCell(1, :);
  
  classImages = size(namesCell, 2);
  scores = zeros(classImages, 10);
  
  for i = 1:classImages
    tmpstr = fullfile(byClassDir, classes(dCl).name, namesCell(i));
    namesCell(i) = tmpstr;
  end
  images = vl_imreadjpeg(namesCell);
  N = size(images, 2);
  if (opts.dayCrop)
    tl_x = ones(N,1) * 20;
    tl_y = ones(N,1) * 220;
    width = ones(N,1) * 640;
    height = ones(N,1) * 480;    
    images_source = cropping(images', tl_x, tl_y, width, height);
  else 
    images_source = images;
  end
  for i = 1:N
    tCt = tCt + 1;
    im_ = images_source{i};
    w = size(im_, 2);
    h = size(im_, 1);
    factor = [net.meta.normalization.imageSize(1)/h, net.meta.normalization.imageSize(2)/w];
    im_ = imresize(im_, 'scale', factor); 

    if (length(size(im_)) < 3)
      im_ = cat(3, im_, im_, im_);
    end;
    
    im_(:, :, 1) = im_(:, :, 1) - net.meta.normalization.averageImage(1);
    im_(:, :, 2) = im_(:, :, 2) - net.meta.normalization.averageImage(2);
    im_(:, :, 3) = im_(:, :, 3) - net.meta.normalization.averageImage(3);

    if(length(opts.gpus) > 0) 
      if(opts.isDag)
        net.eval({'data', gpuArray(im_)});
        raw_scores = gather(squeeze(net.vars(net.layers(net.getLayerIndex('prob')).outputIndexes).value))';
      else 
        res = vl_simplenn(net, gpuArray(im_));
        raw_scores = gather(squeeze(res(end).x)');
      end
    else
      if(opts.isDag)
        net.eval({'data', im_});
        raw_scores = gather(squeeze(net.vars(net.layers(net.getLayerIndex('prob')).outputIndexes).value))';
      else
        res = vl_simplenn(net, im_);
        raw_scores = gather(squeeze(res(end).x)');
      end
    end

    scores = exp(raw_scores)/sum(exp(raw_scores));

    [m, argmax] = max(scores);
    if (argmax ~= dCl)
      errors{dCl} = errors{dCl} + 1;
    end
    modelY(tCt, 1) = argmax;
    trueY(tCt, 1) = dCl;    
    logloss{dCl} = logloss{dCl} + log(scores(dCl));
  end
  accuracy{dCl} = 1 - (errors{dCl} / N);
  %fprintf('accuracy on class  %d is %.5f\n', dCl, accuracy{dCl});
  %fprintf('logloss on class %d is %.5f\n', dCl, logloss{dCl}/N);
end
stats.accuracy = accuracy;
stats.logloss = logloss;
stats.totalAccuracy = sum(modelY == trueY)/size(modelY, 1);

stats.totalLogLoss = -1 * sum(cell2mat(logloss))/size(modelY, 1);
%fprintf('overall accuracy is %.5f\n', sum(modelY == trueY)/size(modelY, 1)); 
%fprintf('total logloss is %.5f\n', sum(cell2mat(logloss))/size(modelY, 1)  ); 

stats.confusion = confusionmat(trueY, modelY);

