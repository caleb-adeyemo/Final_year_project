%%
clear;
clc;

Tec1 = '../../../Dataset/TEC1';
Tec2 = '../../../Dataset/TEC2';
Tec3 = '../../../Dataset/TEC3';
Sci = '../../../Dataset/SCI';
outliers = '../../../Dataset/outliers';

% Initialise the image names 
tec1_path = image_paths(Tec1);
tec2_path = image_paths(Tec2);
tec3_path = image_paths(Tec3);
sci_path = image_paths(Sci);
outliers_path = image_paths(outliers);

% Create experiment data and label
[data_path, data_label] = create_data_label(tec1_path, tec2_path, tec3_path, sci_path, outliers_path, [length(tec1_path),length(tec2_path),length(tec3_path),length(sci_path),length(outliers_path)]);

% find promenent label
% Count the occurrences of each unique string
[counts, ~, idx] = unique(data_label);
frequency = accumarray(idx, 1);

% Find the string that occurs the most
[~, maxIndex] = max(frequency);
mostOccurredString = counts(maxIndex);

% Create an array with 1 for the most occurred string and 0 for the rest
data_label = (data_label == mostOccurredString);

res = false(length(data_path), length(data_path));

% Row
for i = 1:length(data_path)
    % col
    for j = 1:length(data_path)
        % Read images
        img1 = imread(cell2mat(data_path(i)));
        img2 = imread(cell2mat(data_path(j)));
    
        val = sift_Compare(img1, img2, 10, 5, 5);

        res(i,j) = val;

        fprintf('Done: %d,%d\n', i, j);
    end
end
%%
save('sift_only_logical_10_5_5.mat', 'res');


%%
function [result] = sift_Compare(image1, image2, sift_thresh, match_thresh, thresh_num)
    %  Turn the images to grey scale
    img1_gray = rgb2gray(image1);
    img2_gray = rgb2gray(image2);

    % Get sift points
    [~, descriptors1] = vl_sift(single(img1_gray),'peakThresh',sift_thresh);
    [~, descriptors2] = vl_sift(single(img2_gray),'peakThresh', sift_thresh);

    % Matches and scores
    [matches, ~] = vl_ubcmatch(descriptors1, descriptors2, match_thresh);

    no_matches = size(matches, 2);

    if no_matches > thresh_num
        result = true;
    else
        result = false;
    end
end