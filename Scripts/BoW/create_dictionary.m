function [index, dictionary] = create_dictionary(image_paths, dictionary_size )

% Find out how many images we are processing
total_image = size(image_paths, 1);

% Number of visual Words
k_visual_words = dictionary_size;

% initialize empty matrix to store SIFT features
sift_features = [];


% Loop through every image in the dataset
for image_count = 1:total_image

    % Read the image and turn it into grayscale
    image_grayscale = rgb2gray(imread(cell2mat(image_paths(image_count))));

    % Extract the SIFT Features (F) and Descriptors (D)
    [~, descriptors] = vl_sift(single(image_grayscale),'peakThresh',10 );

    % concatenate descriptors to sift_features matrix
    sift_features = [sift_features descriptors];

    % Print the progress...so far...
    fprintf('Progress: %d%%\n', round((image_count/total_image)*100));
end

% Cluster the the descriptors to k clusters
% fprintf('clustering the centers')
[index, centers] = kmeans(double(sift_features)', k_visual_words, "MaxIter",1000);

% fprintf('done cliustering the centres')
dictionary = centers;

end