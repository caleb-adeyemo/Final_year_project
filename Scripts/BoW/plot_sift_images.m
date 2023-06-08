function [] = plot_sift_images(image1_path, image2_path)
    % Read images
    img1 = imread(cell2mat(image1_path));
    img2 = imread(cell2mat(image2_path));
    
    % Turn the images to grey scale
    img1 = rgb2gray(img1);
    img2 = rgb2gray(img2);

    img1 = imresize(img1, [1000,1000]);
    img2 = imresize(img1, [1000,1000]);
    
    % get sift points
    [centre1, descriptors1] = vl_sift(single(img1),'peakThresh',10);
    [centre2, descriptors2] = vl_sift(single(img2),'peakThresh', 10);
    
    % Matches and scores
    [matches, ~] = vl_ubcmatch(descriptors1, descriptors2, 5);
    
    
    %% Plot keypoints and matches
    
    % Display images
    figure;
    imshow([img1, img2]);
    
    
    hold on;
    
    % Plot matches
    for i = 1:size(matches, 2)
        % Get the matching keypoints' indices
        idx1 = matches(1, i);
        idx2 = matches(2, i);
        
        % Get the locations of the matching keypoints
        loc1 = centre1(1:2, idx1);
        loc2 = centre2(1:2, idx2); 
        loc2(1) = loc2(1) + size(img1, 2); % Add offset to x-coordinate of image 2 keypoints
        
        % Draw a line connecting the matching keypoints
        line([loc1(1) loc2(1)], [loc1(2) loc2(2)], 'Color', 'g', 'LineWidth', 3);
    end
    
    hold off;
end

