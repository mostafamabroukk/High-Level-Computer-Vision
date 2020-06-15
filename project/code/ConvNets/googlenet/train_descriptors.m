

trainDir = '../../data/train';

classDirs = dir(fullfile(trainDir, 'c*'));

for i =1:length(classDirs)
    classDir = classDirs(i).name
    desc = get_descriptors(fullfile(trainDir, classDir));
    savename = [classDir, '.mat'];
    save(savename, 'desc');

end


