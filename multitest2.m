clearvars
format long g;
format compact;
% % Assign the image folder you want to use (keep it small because it will display all of them as figures)
% starfishpath = 'C:\Users\Shona\Desktop\seniordesignii\starfish';
% anchorpath = 'C:\Users\Shona\Desktop\seniordesignii\anchor';



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
     
     filenames = dir(fullfile(listOfFolderNames{2},'*.jpg'));
     filenames1 = dir(fullfile(listOfFolderNames{3},'*.jpg'));
     filenames2 = dir(fullfile(listOfFolderNames{4},'*.jpg'));
     
%      total = numel(filenames);         

 
  total = length(filenames);
  total1 = length(filenames1);
  total2 = length(filenames2);
  
  grandTotal = total + total1 + total2;
  for n = 1:grandTotal
    
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