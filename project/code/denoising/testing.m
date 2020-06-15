function [] = testing(func, params, param_structure, test_id)
% apply given denoising with a series of parameteres to an given image
% 'func' = function pointer (--> call using @<functionname>)
% 'params' = function parameters (cell array of cell arrays --> all 
% parameter combinations will be tried out using allcombs)
% images should be specified using a file paths and should always be the
% first parameter
% 'param_structure' = cell array of strings specifying the names of the
% passed parameter values for example 
% {'img', 'g', 'lambda', 'tau', 'num_iter'} for 'func' = @DiffusionFilter
% used to construct the file names for the images
% 'testid' = string that specifies an id for the test run --> used to
% label an output folder inside testresults folder
    if (length(params) ~= length(param_structure))
       error(strcat('testing: The number of parameter vectors in',...
           '"params" and the number of different parameters in',...
           '"param_structure" should have the same length!')) ;
    end
    
    % Build output folder
    ouput_folder = strcat('testresults/run_', test_id, '/');
    mkdir(ouput_folder);
    
    % Construct all parameter combinations
    param_combs = allcombs(params{:});
    width_par_combs = size(param_combs,2);
    
    fprintf(['testing.m: Total number of tests will be ',...
        num2str(size(param_combs,1)),'\n\n']);
    
    tic;
    % Perform the tests
    for i = 1: size(param_combs,1)
       fprintf(['testing.m: Running test number ',num2str(i),'\n\n']);
       cur_params = cell(1, width_par_combs);
       for j = 1:width_par_combs
           cur_params{j} = param_combs{i,j};
       end
       tic;
       cur_img = func(cur_params{:});
       elapsed_time = toc;
       % Construct the file name
       filename = strcat(func2str(func),'_');
       img_path = cur_params{1};
       img_name = regexprep(img_path,'.*\','');
       strcat(filename, param_structure{1}, '=',...
               img_name, '_');
       for j = 2:width_par_combs
           cur_par = cur_params{j};
           if (isfloat(cur_par))
              cur_par = num2str(cur_par);
           end
           filename = strcat(filename, param_structure{j}, '=',...
               cur_par, '_');
       end
       filename = strcat(filename,'time=',num2str(elapsed_time),'s');
       % Write image to file
       imwrite(uint8(cur_img),strcat(ouput_folder, filename, '.png'));
    end
    total_time = toc;
    fprintf(['Total time = ',total_time,' s']);
end

