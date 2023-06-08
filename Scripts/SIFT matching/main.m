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

load("sift_only_logical_10_5_5.mat")

max_num = 0;
most_cat_index = 0;
for i = 1:length(res)
    num = sum(res(i, :));
    if num >= max_num
        most_cat_index = i;
        max_num = num;
    end
end

image1 = imread(cell2mat(train_image_path(most_cat_index)));

predicted_categories = res(most_cat_index, :)';

predicted_categories = categorical(double(predicted_categories));

correct = 0;
for i = 1:length(predicted_categories)
    if train_label(i) == predicted_categories(i)
        correct = correct+1;
    else
        figure;
        image2 = imread(cell2mat(train_image_path(i)));
        subplot(1, 2, 1);
        imshow(image1);
        title('Most Accepted image');

        subplot(1, 2, 2);
        imshow(image2);
        title('Accepted but wrong');

    end
end

accuracy = (correct/length(predicted_categories))*100;

%%  PLOTS
% for i = 1:length(ff)
%     if ff(i) == true
%         plot_sift_images(train_image_path(most_cat_index), train_image_path(i));
%     end
% end


% figure;
% imshow(imread(cell2mat(train_image_path(most_cat_index))));
