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
tec1_elements = length(tec1_path);
tec2_elements = 0;
tec3_elements = 0;
sci_elements = 0;
outliers_elements = length(outliers);
[data_path, data_label] = create_data_label(tec1_path, tec2_path, tec3_path, ...
    sci_path, outliers_path, [tec1_elements,tec2_elements,tec3_elements, ...
    sci_elements,outliers_elements]);

% find promenent label, Count the occurrences of each unique string
[counts, ~, idx] = unique(data_label);
frequency = accumarray(idx, 1);

% Find the string that occurs the most
[~, maxIndex] = max(frequency);
mostOccurredString = counts(maxIndex);

% Create an array with 1 for the most occurred string and 0 for the rest
data_label = (data_label == mostOccurredString);

FEATURE = "bag of sift";

CLASSIFIER = "compare";

% Build DICTIONARY
% dictionary_size = [50, 100, 200, 500, 1000];
dictionary_size = 100;


% std_sens = [0, 0.1, 0.5];
std_sens = 0.1;


for dict_size = 1:size(dictionary_size,2)
    for std_size = 1:size(std_sens, 2)
        if ~exist(sprintf('dictionary_%d.mat', dictionary_size(dict_size)), 'file')
            [index, dict] = create_dictionary(data_path, dictionary_size(dict_size));
            save(sprintf('dictionary_%d.mat', dictionary_size(dict_size)), "index",'dict')
        else
            load(sprintf('dictionary_%d.mat', dictionary_size(dict_size)))
        end

        % Feature extraction
        switch lower(FEATURE)
            case "bag of sift"
                % bags of sifts features
                if ~exist(sprintf('training_bag_%d.mat', dictionary_size(dict_size)), 'file')
                    train_image_features = create_sift(data_path, dict, index);
                    save(sprintf('training_bag_%d.mat', dictionary_size(dict_size)), 'train_image_features');
                end

                if exist(sprintf('training_bag_%d.mat', dictionary_size(dict_size)), 'file')
                    load(sprintf('training_bag_%d.mat', dictionary_size(dict_size)));
                end

        end

        % Classifier
        switch lower(CLASSIFIER)
            case "compare"
                % Create comparison Matrix
                campare_matrix = zeros(length(data_path), length(data_path));

                % Initialise similarity values
                for i = 1:length(data_path)
                    for j = 1:length(data_path)
                        campare_matrix(i,j) = compare_histograms(train_image_features(i,:), train_image_features(j,:));
                    end
                end

                % Find in matrix the row that has the lowest difference
                [~, index_of_min_image] = min(sum(campare_matrix,2));
                prediction_row = campare_matrix(index_of_min_image,:);


                % Calculate the mean and standard deviation of the similarity scores
                mean_score = mean(prediction_row);
                std_score = std(prediction_row);

                % Set the threshold as a multiple of the standard deviation from the mean
                k = std_sens(std_size); % Adjust this value to control the sensitivity
                threshold = mean_score - k * std_score;

                % Classify histograms based on the threshold
                similar_histograms = (prediction_row <= threshold)';


                similar_histograms = double(similar_histograms);
                
                tp = 0;
                tn = 0;
                fp = 0;
                fn = 0;

                for i = 1:length(similar_histograms)
                    if data_label(i) == 1 && similar_histograms(i) == 1
                        tp = tp + 1;  % True Positive
                    elseif data_label(i) == 0 && similar_histograms(i) == 0
                        tn = tn + 1;  % True Negative
                    elseif data_label(i) == 0 && similar_histograms(i) == 1
                        fp = fp + 1;  % False Positive
                    elseif data_label(i) == 1 && similar_histograms(i) == 0
                        fn = fn + 1;  % False Negative
%                         % Read the image and turn it into grayscale
%                         image1 = data_path(index_of_min_image);
%                         image2 = data_path(i);
%                         plot_sift_images(image1, image2);
                    end
                end

                accuracy = (tp + tn) / length(similar_histograms) * 100;
                confusion_matrix = [tp, fp; fn, tn];

                % Create confusion chart
                labels = {'Positive', 'Negative'};
                confusionchart(confusion_matrix, labels);

                fprintf('%d, %d, %d, %d, %d, %d, %d\n', dictionary_size(dict_size), std_sens(std_size), tp, tn, fp, fn, accuracy);
        end
    end
end
