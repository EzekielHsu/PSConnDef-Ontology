% Load the image
img = imread('File path');

% Convert image to grayscale for processing
gray_img = rgb2gray(img);

% Smooth the image to reduce noise
gray_img_smoothed = imgaussfilt(gray_img, 2); % Gaussian filter with sigma = 2

% Display the smoothed image for visualization
figure;
imshow(gray_img_smoothed);
title('Smoothed Grayscale Image');

% Task 1: Identify sleeve areas
% Sum pixel values column-wise to find potential sleeve area centers
column_sums = sum(gray_img_smoothed);

% Ignore potential sleeve areas near the left and right edges
edge_margin = 170;
column_sums(1:edge_margin) = 0;
column_sums(end-edge_margin:end) = 0;

% Find peaks representing the sleeve areas
[~, peak_columns] = findpeaks(column_sums, 'MinPeakDistance', 100, 'NPeaks', 10);

% Plot the detected sleeve area centers
figure;
plot(column_sums);
hold on;
plot(peak_columns, column_sums(peak_columns), 'ro');
title('Detected Sleeve Area Centers');
xlabel('Column Index');
ylabel('Sum of Pixel Values');

% Task 2: Calculate distances between sleeve area centers and scale
num_columns = size(gray_img_smoothed, 2);
reference_column = peak_columns(1);
distances_from_reference = peak_columns - reference_column;

% Scale the distances and multiply by 1500
scaled_distances = (distances_from_reference / num_columns) * 1500;

% Display the scaled distances
fprintf('Scaled Distances from the First Sleeve Area:\n');
disp(scaled_distances);

% Task 3: Segment and save each sleeve area
output_folder = 'Sleeve_Areas';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

for i = 1:length(peak_columns)
    % Define the column range for each sleeve area (centered at peak)
    col_start = max(1, peak_columns(i) - 50); % Adjust range if needed
    col_end = min(num_columns, peak_columns(i) + 50);
    sleeve_segment = img(:, col_start:col_end, :);
    
    % Save the segmented sleeve image
    filename = sprintf('%s/Sleeve%d.png', output_folder, i);
    imwrite(sleeve_segment, filename);
end

fprintf('Segmented sleeve areas have been saved to the folder: %s\n', output_folder);
