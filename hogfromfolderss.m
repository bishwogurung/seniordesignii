clearvars

% Assign the image folder you want to use (keep it small because it will display all of them as figures)
starfishpath = 'C:\Users\Shona\Desktop\seniordesignii\starfish';
anchorpath = 'C:\Users\Shona\Desktop\seniordesignii\anchor';
% Read all the images
filenames = dir(fullfile(starfishpath, '*.jpg'));
filenames1 = dir(fullfile(anchorpath, '*.jpg'));
% Count the total number of images in the folder
total = numel(filenames);
total1 = numel(filenames1);

for n = 1:total
    
    % Specify the images with full path
    id = fullfile(starfishpath, filenames(n).name);
    
    % Read images
    img = imread(id);
    img = rgb2gray(img);
    img = im2single(img);
    cellSize = 8;
    hog = vl_hog(img, cellSize, 'verbose');
    figure (n)
    
    % Visualize the features
    imhog = vl_hog('render', hog, 'verbose');
    clf;
    imagesc(imhog);
    colormap gray ;
    
end

for n = 1:total1
    
    % Specify the images with full path
    id = fullfile(anchorpath, filenames1(n).name);
    
    % Read images
    img = imread(id);
    img = rgb2gray(img);
    img = im2single(img);
    cellSize = 8;
    hog = vl_hog(img, cellSize, 'verbose');
    figure (n +3)
    
    % Visualize the features
    imhog = vl_hog('render', hog, 'verbose');
    clf;
    imagesc(imhog);
    colormap gray ;
    
end