function [images] = readInImages(imgType, imgPath)
% reads in all the images in the folder specified by 'imgPath' and all its
% subfolders of the type 'imgType' and retuns them as a cell array 
% 'imgType' should be a string like 'jpg'
    allSubFolders = genpath(imgPath);
    imgType = ['*.', imgType];
    
    % Read in the images from all the subfolders
    remain = allSubFolders;
    listOfFolderNames = {};
    while true
        [singleSubFolder, remain] = strtok(remain, ';');
        if isempty(singleSubFolder)
            break;
        end
        listOfFolderNames = [listOfFolderNames singleSubFolder];
    end
    numberOfFolders = length(listOfFolderNames);
    
    images = {};
    
    for i = 1:numberOfFolders
        curPath = listOfFolderNames{i};
        imagesMeta  = dir([curPath '\' imgType]);
        imagesNew = cell(length(imagesMeta),1);
        for j = 1:length(imagesMeta)
           imagesNew{j} = imread([curPath '\' imagesMeta(j).name]); 
        end
        images = cat(1,images,imagesNew);
    end
end

 