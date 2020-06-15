function [scores, names] = get_ddd_scores(imageDir, modelPath)
%GET_DESCRIPTORS gets 1000-dim vectors obtained by removing the last layer of googlenet

%TODO replace with run(fullfile(fileparts(mfilename('fullpath')), '..', '...))



%run ../matconvnet-1.0-beta20/matlab/vl_setupnn

%vl_compilenn('EnableGpu', true);


tmp = load(modelPath);
tmpnet = tmp.net; 
net = tmpnet;
net.layers = tmpnet.layers(1:36);

net = vl_simplenn_move(net, 'gpu');

fprintf('net_loaded\n');

maxBatchSize = 1000;


contents = dir([imageDir '/im*']);
contentsCell = struct2cell(contents);
namesCell = contentsCell(1, :);

totalImages = size(namesCell, 2);

scores = zeros(totalImages, 10);

for i = 1:totalImages
    tmpstr = fullfile(imageDir, namesCell(i));
    namesCell(i) = tmpstr;
end
numBatches = ceil(totalImages / maxBatchSize);

for b = 1:numBatches
    fprintf('running batch %d\n', b);
    batch_lower = (b-1) * maxBatchSize + 1;
    batch_upper = min(b * maxBatchSize, totalImages);

    batch_namesCell = namesCell(batch_lower:batch_upper);
   
    fprintf('in imread\n'); 
    images = vl_imreadjpeg(batch_namesCell);
    fprintf('imread finished\n');
    for i = 1:size(images, 2);
    
        if (mod(i, 100) == 0) 
            i 
        end;
        im_ = images{i};

        w = size(im_, 2);
        h = size(im_, 1);

        factor = [net.meta.normalization.imageSize(1)/h, net.meta.normalization.imageSize(2)/w];
        im_ = imresize(im_, 'scale', factor) ;
        im_(:, :, 1) = im_(:, :, 1) - net.meta.normalization.averageImage(1);
        im_(:, :, 2) = im_(:, :, 2) - net.meta.normalization.averageImage(2);
        im_(:, :, 3) = im_(:, :, 3) - net.meta.normalization.averageImage(3);
        
        res = vl_simplenn(net, gpuArray(im_));

        raw_scores = gather(squeeze(res(end).x)');
        scores(batch_lower+i-1, :) = exp(raw_scores)/sum(exp(raw_scores));

    end;
end;
%}

names = namesCell;
