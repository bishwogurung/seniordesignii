clearvars
format long g;
format compact;

 parentfolderpath = 'C:\Users\Shona\Desktop\seniordesignii\parentfolder';
 parentLevelFolder = uigetdir(parentfolderpath);
 
 allSubFolders = genpath(parentfolderpath);
 
 remain = allSubFolders;
 listOfFolderNames = {};
 
 while true
     [singleSubFolder, remain] = strtok(remain, ';');
     if isempty(singleSubFolder)
         break;
     end
     listOfFolderNames = [listOfFolderNames singleSubFolder];
 end
 numberOfFolders = length(listOfFolderNames);
 
 for k = 1 : numberOfFolders
     thisFolder = listOfFolderNames{k};
     disp(thisFolder);
     filenames = dir(fullfile(thisFolder,'*.jpg'));
     disp(filenames);

      total = length(filenames);
     
%      total = numel(filenames);
         
     for n = 1:total
    
    % Specify the images with full path
    id = fullfile(thisFolder, filenames(n).name);
    
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
     
 end
 