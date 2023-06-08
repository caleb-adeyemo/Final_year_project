function [train_image_path] = ... 
image_paths(dataPath)


% TRAIN PATH
fileInfo = dir(dataPath);
train_image_path = {};
num = 1;
for i = 1:length(fileInfo)
    if ~fileInfo(i).isdir && fileInfo(i).name ~= ".DS_Store"
        train_image_path{num} = fullfile(dataPath,fileInfo(i).name);
        num = num+1;
    end
end
train_image_path = train_image_path';

end

