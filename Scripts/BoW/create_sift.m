function image_feats = create_sift(image_paths, dict, index)

% Find out how many images we are processing
total_image = size(image_paths, 1);

% Get the size of the vocab i.e No of clusters
dictionary_size = size(dict, 1);

% Create a matrix to store the counts of each vocab in an image (histogram)
image_feats = zeros(total_image, dictionary_size);


% Loop theough every image in the file
for image_count = 1:total_image

    % Read the image and turn it into grayscale
    image = rgb2gray(imread(cell2mat(image_paths(image_count))));

    % Make the image of type single to work with the function vl_dsift()
    image = single(image);

    % Extract the SIFT Features and Descriptors
%     [~, descriptors] = vl_dsift(image, 'step', step, 'size', size_);
    [~, descriptors] = vl_sift(single(image),'peakThresh',5);
%       [~, descriptors] = vl_dsift(image, 'Fast');

%     % Convert the descriptors to single data type
%     descriptors = double(descriptors)';
    
    % Find the nearrest vocab to each descriptor found
    [indices, ~] = knnsearch(double(dict), double(descriptors'));
%     [~, indices] = min(vl_alldist(double(descriptors), dict)) ;

test = index(indices,:);
    
    % find how many times the nth visual cluster apeared in an image
    image_feats(image_count, :) = histcounts(test, dictionary_size);

%     % Normalize the histogram
%     image_feats(image_count, :) = image_feats(image_count, :) / sum(image_feats(image_count, :));

%     fprintf('Progress: %d%%\n', round((image_count/total_image)*100));
end
