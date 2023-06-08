function [data_paths, labels] = create_data_label(TEC1_path, TEC2_path, TEC3_path, Sci_path, outliers_path, num_split)
tec1_idx = randperm(length(TEC1_path), num_split(1));
tec2_idx = randperm(length(TEC2_path), num_split(2));
tec3_idx = randperm(length(TEC3_path), num_split(3));
sci_idx = randperm(length(Sci_path), num_split(4));
outliers_idx = randperm(length(outliers_path), num_split(5));

% Data Path
idx = cumsum(num_split);
% Tec1
data_paths(1:idx(1), 1) = TEC1_path(tec1_idx);
labels(1:idx(1), 1) = "TEC1";
% Tec2
data_paths(idx(1)+1:idx(2), 1) = TEC2_path(tec2_idx);
labels(idx(1)+1:idx(2), 1) = "TEC2";
% Tec3
data_paths(idx(2)+1:idx(3), 1) = TEC3_path(tec3_idx);
labels(idx(2)+1:idx(3), 1) = "TEC3";
% Sci
data_paths(idx(3)+1:idx(4), 1) = Sci_path(sci_idx);
labels(idx(3)+1:idx(4), 1) = "SCI";
% outliers
data_paths(idx(4)+1:idx(5), 1) = outliers_path(outliers_idx);
labels(idx(4)+1:idx(5), 1) = "OUT";
end