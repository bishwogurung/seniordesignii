clearvars

% % Assign the image folder you want to use (keep it small because it will display all of them as figures)
% starfishpath = 'C:\Users\Shona\Desktop\seniordesignii\starfish';
% anchorpath = 'C:\Users\Shona\Desktop\seniordesignii\anchor';




%  parentLevelFolder = uigetdir(parentfolderpath);
 
%  allSubFolders = genpath(parentLevelFolder);
%  
%  remain = allSubFolders;
%  listOfFolderNames = {};
%  
%  while true
%      [singleSubFolder, remain] = strtok(remain, ';');
%      if isempty(singleSubFolder)
%          break;
%      end
%      listOfFolderNames = [listOfFolderNames singleSubFolder];
%  end
%  numberOfFolders = length(listOfFolderNames);
 


%  parentfolderpath = 'C:\Users\Shona\Desktop\seniordesignii\parentfolder';
 
 dirinfo = dir();
 dirinfo(~[dirinfo.isdir]) = [];
 
 subdirinfo = cell(length(dirinfo));
 
 for k = 1: length(dirinfo)
    thisdir = dirinfo(k).name;
    subdirinfo{k} = dir(fullfile(thisdir, '*.jpg'));
    
    subthisdir = subdirinfo{k}.name;
    
    filenames = dir(fullfile(subthisdir, '*.jpg'));
    
    total = numel(filenames); 
    
    id = fullfile(thisdir , subdirinfo{k}.name);
    
    % Read images
    img = imread(id);
    img = rgb2gray(img);
    img = im2single(img);
    cellSize = 8;
    hog = vl_hog(img, cellSize, 'verbose');
    figure (k)
    
    % Visualize the features
    imhog = vl_hog('render', hog, 'verbose');
    clf;
    imagesc(imhog);
    colormap gray ;
 end




% Read all the images
% filenames = dir(fullfile(starfishpath, '*.jpg'));
% filenames1 = dir(fullfile(anchorpath, '*.jpg'));
% Count the total number of images in the folder
% total = numel(dirinfo(k));
% total1 = numel(filenames1);

% for n = 1:total
%     
%     % Specify the images with full path
%     id = fullfile(starfishpath, filenames(n).name);
%     
%     % Read images
%     img = imread(id);
%     img = rgb2gray(img);
%     img = im2single(img);
%     cellSize = 8;
%     hog = vl_hog(img, cellSize, 'verbose');
%     figure (n)
%     
%     % Visualize the features
%     imhog = vl_hog('render', hog, 'verbose');
%     clf;
%     imagesc(imhog);
%     colormap gray ;
%     
% end
% 
% for n = 1:total1
%     
%     % Specify the images with full path
%     id = fullfile(anchorpath, filenames1(n).name);
%     
%     % Read images
%     img = imread(id);
%     img = rgb2gray(img);
%     img = im2single(img);
%     cellSize = 8;
%     hog = vl_hog(img, cellSize, 'verbose');
%     figure (n +3)
%     
%     % Visualize the features
%     imhog = vl_hog('render', hog, 'verbose');
%     clf;
%     imagesc(imhog);
%     colormap gray ;
%     
% end