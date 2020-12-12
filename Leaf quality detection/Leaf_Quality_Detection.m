% Read in a gray scale demo image.
folder = pwd;
baseFileName = uigetfile('*.jpg');
img=imread(baseFileName);
figure(1);imshow(img);
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
grayImage = imread(fullFileName);


% Step 1
[rows, columns, numberOfColorChannels] = size(grayImage);
if numberOfColorChannels > 1
  % It's not really gray scale like we expected - it's color.
  % Use weighted sum of ALL channels to create a gray scale image.
  grayImage = rgb2gray(grayImage); 
  % ALTERNATE METHOD: Convert it to gray scale by taking only the green channel,
  % which in a typical snapshot will be the least noisy channel.
  % grayImage = grayImage(:, :, 2); % Take green channel.
end
% Display the image.
subplot(2, 2, 1);
imshow(grayImage, []);
title('Original Grayscale Image');


% Step 2
binaryImage = grayImage < 210;
% Fill holes.
binaryImage = imfill(binaryImage, 'holes');
% Get the leaf area
leafArea = sum(binaryImage(:))
% Display the image.
subplot(2, 2, 2);
imshow(binaryImage, []);
title('Binary Image, leaf mask');

%step 3-Masking (elementwise AND operator and gives out )
grayImage = uint8(binaryImage).*grayImage

%Step 4
% Get the disease
diseaseImage = grayImage > 128; % Binarize
% Get rid of background
diseaseImage = imclearborder(diseaseImage);
% Display the image.
subplot(2, 2, 3);
imshow(diseaseImage, []);
title('Disease');
% Get the disease area
diseaseArea = sum(diseaseImage(:))

%Step 5
message = sprintf('The leaf area = %d pixels.\nThe disease Area = %d pixels = %.1f%%',...
  leafArea, diseaseArea, diseaseArea/leafArea*100);
   uiwait(msgbox(message));
if (diseaseArea/leafArea*100) <= 2 
    message = sprintf('This is healthy leaf');
    uiwait(msgbox(message));
else
    (diseaseArea/leafArea*100) >= 2
    message = sprintf('This is diseased leaf');
    uiwait(msgbox(message));
end