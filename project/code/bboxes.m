%%%% README %%%%%

%  This is a script that lets you draw and save bounding boxes in the
%  driver images. For each driver, it displays 10 different images
%  sequentially. After you draw the box in the last one, it saves all the
%  drawn boxes as a .mat file.

% Before you run this script, please make sure you are in the 
% hlcv-saar/project/code/ directory, i. e. where this script is located.


% Please draw the box tight around the steering wheel. All pixels of the
% steering wheel should be in the box, but the box should not be any bigger
% than it needs to be to fit the steering wheel. If the edge of the wheel
% is obscured by something (e. g. hand, cup,..), make a good guess where
% the steering wheel should end and draw the box there. If the wheel
% touches the edge of the image, draw the box all the way to the edge. 

% Once you are finished with a box, double click it to advance to the next
% image. When you are finished with a driver, the script will save your
% bounding boxes and move on to the next driver. Once you are finished with
% all 'your' assigned drivers, please push all your .mat files to the git.

% To select your set of drivers to work on, please uncomment your line
% below. Otherwise two of us will work on the same images, which is a waste
% of time.


byDriverDir = '../data/train/by_driver/';

%Jakub:
%driverDirectories = ['p014'; 'p015'; 'p016'; 'p021'; 'p022'; 'p024'];

%Mostafa:
%driverDirectories = ['p026'; 'p035'; 'p039'; 'p041'; 'p042'; 'p045'];

%Damaris:
%driverDirectories = ['p047'; 'p049'; 'p050'; 'p051'; 'p052'; 'p056'];

%Thomas:
%driverDirectories = ['p061'; 'p064'; 'p066'; 'p072'; 'p075'; 'p081'];

for d = 1:length(driverDirectories)
  
  driverDir = [byDriverDir, driverDirectories(d, :), '/']
  driverImgs = dir([driverDir '*.jpg']);
  bboxes_sw = zeros(length(driverImgs), 4);
  
  for i = 1:length(driverImgs)
    imshow([driverDir '/' driverImgs(i).name]);
    [patch, bB] = imcrop();
    bboxes_sw(i, :) = bB;
    clf;
  end
  matname = sprintf('../data/train/wheel_pos_%s.mat', driverDirectories(d, :));
  save(matname, 'bboxes_sw');
  
end

