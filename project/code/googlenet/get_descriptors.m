function [descriptors, names] = get_descriptors(imageDir)
%GET_DESCRIPTORS gets 1000-dim vectors obtained by removing the last layer of googlenet

%TODO replace with run(fullfile(fileparts(mfilename('fullpath')), '..', '...))



run ../matconvnet-1.0-beta20/matlab/vl_setupnn

%vl_compilenn('EnableGpu', true);

modelPath = '../matconvnet-1.0-beta20/data/models/imagenet-googlenet-dag.mat' ;

if ~exist(modelPath)
  mkdir(fileparts(modelPath)) ;
  urlwrite(...
  'http://www.vlfeat.org/matconvnet/models/imagenet-googlenet-dag.mat', ...
    modelPath) ;
end

net = dagnn.DagNN.loadobj(load(modelPath)) ;
net.removeLayer('softmax')


net.move('gpu')

maxBatchSize = 10000;


contents = dir([imageDir '/im*']);
contentsCell = struct2cell(contents);
namesCell = contentsCell(1, :);

totalImages = size(namesCell, 2);

for i = 1:totalImages
    tmpstr = fullfile(imageDir, namesCell(i));
    namesCell(i) = tmpstr;
end
numBatches = ceil(totalImages / maxBatchSize);
%{
for b = 1:numBatches
    fprintf('running batch %d\n', b);
    batch_lower = (b-1) * maxBatchSize + 1;
    batch_upper = min(b * maxBatchSize, totalImages);

    batch_namesCell = namesCell(batch_lower:batch_upper);
   
    fprintf('in imread\n'); 
    images = vl_imreadjpeg(batch_namesCell);
    
        
    for i = 1:size(images, 2);
    
        if (mod(i, 100) == 0) 
            i 
        end;
        im_ = images{i};
        im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
        im_ = im_ - net.meta.normalization.averageImage ;
        net.eval({'data', gpuArray(im_)}) ;

     scores = squeeze(gather(net.vars(end).value)) ;
     descriptors(batch_lower + i, :) = scores' ;

    end;

end;
%}

descriptors = [];
names = namesCell;
