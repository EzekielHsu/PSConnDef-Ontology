% Load image
img = imread('C:\Users\admin\Desktop\Sleeve10.png');

% Convert to HSV color space for better color segmentation
hsvImg = rgb2hsv(img);

% Thresholding for red color (adjust values if needed)
redMask = (hsvImg(:,:,1) > 0.9 | hsvImg(:,:,1) < 0.1) & hsvImg(:,:,2) > 0.5 & hsvImg(:,:,3) > 0.5;

% Label connected components in the binary mask
[labels, numRegions] = bwlabel(redMask);

% Initialize variables to store results
rowCounts = zeros(1, numRegions);  % Number of rows for each red area
middleRowDistances = zeros(1, numRegions);  % Row distances from top to middle of each red area
[rows, ~] = size(img);  % Total number of rows in the image

% Process each labeled region
for i = 1:numRegions
    % Find rows occupied by each red region
    [regionRows, ~] = find(labels == i);
    rowCounts(i) = numel(unique(regionRows));  % Count unique rows in the region

    % Calculate distance from top to middle row of each region
    middleRow = round(mean(regionRows));
    middleRowDistances(i) = middleRow;
end

% Calculate proportions
proportionRowCounts = rowCounts / rows;  % Proportion of red area row counts
proportionMiddleRowDistances = middleRowDistances / rows;  % Proportion of middle row distances

% Calculate scaled values (proportions multiplied by 180)
scaledRowProportions = proportionRowCounts * 180;
scaledDistanceProportions = proportionMiddleRowDistances * 180;

% Display results
disp('Total number of valid areas:');
disp(numRegions);

if numRegions >= 1
    disp('Length of each valid area:');
    disp(scaledRowProportions);
    
    disp('Location of each valid area:');
    disp(scaledDistanceProportions);
end

