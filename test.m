%Image category classification with bag of features
%We are trying to show how any particular image can be categorized. 

%%
%We are using Caltech 101 image data set for our reference pictures.

%url = 'http://www.vision.caltech.edu/Image_Datasets/Caltech101/101_ObjectCategories.tar.gz';
%using the link from the internet 

%outputFolder = fullfile(tempdir, 'caltech101'); 
%downloading the caltech files 

% if ~exist(outputFolder, 'dir') 
%     disp('Downloading 126MB Caltech101 data set...');
%     untar(url, outputFolder);
% end
%'if' loop incase we re-run our code, this should download the images only once

%% 
%we are loading the image sets onto our project.
%the images with the 'focus' covers most of the surface area in each of the
%images.

% rootFolder = fullfile(outputFolder, '101_ObjectCategories');

%%
%We selected 3 categories from Caltech 101 by using imageset which pulls
%the right amount of files needed.

% imgSets = [ imageSet(fullfile(rootFolder, 'anchor')), ...
%             imageSet(fullfile(rootFolder, 'chair')), ...
%             imageSet(fullfile(rootFolder, 'starfish')) ];
%we used the starfish, rhino, cup categories from the caltech database. 

% %%
%we are displaying the data about each category. 

{ imgSets.Description } 
%displays given directory information about the images

[imgSets.Count]         
%tells how many images are in the category

%%
%adjusting the number of images in each category.

minSetCount = min([imgSets.Count]); 
%counts the smallest amount of images in a category

imgSets = partition(imgSets, minSetCount, 'randomize');
%uses partition to trim the set.

[imgSets.Count]
%each set has the same amount of images which is equal to the category
%which had the smallest available number of images 

%%
%separating training and validation information.
%.3 is used for traing; .7 is for validation

[trainingSets, validationSets] = partition(imgSets, 0.3, 'randomize');
%using partition method here again. 

%%
%displaying our three categories 
anchor = read(trainingSets(1),1);
chair   = read(trainingSets(2),1);
starfish      = read(trainingSets(3),1);

figure

subplot(1,3,1);
imshow(anchor)
hold on
subplot(1,3,2);
imshow(chair)
hold on
subplot(1,3,3);
imshow(starfish)
%we are using subplots to put all three categories images into one figure.

%% 
%we want to train the classifier with 'bag of words' by extracting
%features by using SURF for each category 

%bag = bagOfFeatures(trainingSets);
%uses function 'bagoffeatures' -takes the SURF features from each category
%and minimizes it by using k-means clustering technique

%img = read(imgSets(1), 1);
%featureVector = encode(bag, img);
%counts how many features are in an image 

%figure
%bar(featureVector)
%title('image word occurrences')
%xlabel('image word index')
%ylabel('number of repetitions')
%histogram of image word occurrences to show for the images
%gives an idea for training a classifier 

%%
%we used linear SVM here with machine learning to create a classifer

%categoryClassifier = trainImageCategoryClassifier(trainingSets, hog);
%uses the data from the encode command to create feature vectors for each
%image category from the array of imagesets created before

%%
clearvars
format long g;
format compact;

 parentfolderpath = 'C:\Users\Shona\Desktop\seniordesignii\101_ObjectCategories';
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
 
%% 
%we have to test the classifier with the training set (.3 of data) and the
%validation set (.7 of data)

confMatrix = evaluate(categoryClassifier, trainingSets);
confMatrix = evaluate(categoryClassifier, validationSets);
%using a confusion matrix

mean(diag(confMatrix));
%finds the amount of accuracy

categoryClassifier = trainImageCategoryClassifier(trainingSets, hog);
%%
%takes a snapshot with webcam 

webcamlist
cam = webcam
%tells you about the webcam

preview(cam)
pause(2)
closePreview(cam)
%opens the camera so you can see it
%then closes it

img1 = snapshot(cam);
imshow(img1)
%takes a picture with the camera 

     imwrite(img1,'img1.jpg','jpg')

clear('cam');
%saves the image just taken
%%
%testing a image to see how the program works

%img = imread(fullfile(rootFolder, 'starfish', 'image_0010.jpg'));
img = imread('img1.jpg');
[labelIdx, scores] = predict(categoryClassifier, img);
categoryClassifier.Labels(labelIdx)
%gives more information about the image