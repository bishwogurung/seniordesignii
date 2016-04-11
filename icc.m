%Image category classification with bag of features
%We are trying to show how any particular image can be categorized. 

%%
%We are using Caltech 101 image data set for our reference pictures.

url = 'http://www.vision.caltech.edu/Image_Datasets/Caltech101/101_ObjectCategories.tar.gz';
%using think from th internet 

outputFolder = fullfile(tempdir, 'caltech101'); 
%downloding the caltech files 

if ~exist(outputFolder, 'dir') 
    disp('Downloading 126MB Caltech101 data set...');
    untar(url, outputFolder);
end
%if loop incase we re-run our code, this should download the images only once

%% 
%we are loading the image sets onto our project.
%the images with the 'focus' covers most of the surface area in each of the
%images.

rootFolder = fullfile(outputFolder, '101_ObjectCategories');

%%
%We selected 3 categories from Caltech 101 by using imageset which pulls
%the right amount of files needed.

imgSets = [ imageSet(fullfile(rootFolder, 'starfish')), ...
            imageSet(fullfile(rootFolder, 'rhino')), ...
            imageSet(fullfile(rootFolder, 'cup')) ];
%we used the starfish, rhino, cup categories from the caltech database. 

%%
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

starfish = read(trainingSets(1),1);
rhino    = read(trainingSets(2),1);
cup      = read(trainingSets(3),1);

figure

subplot(1,3,1);
imshow(starfish)
hold on
subplot(1,3,2);
imshow(rhino)
hold on
subplot(1,3,3);
imshow(cup)
%we are using subplots to put all three categories images into one figure.

%% 
%we want to train the classifier with 'bag of words' by extracting
%features by using SURF for each category 

bag = bagOfFeatures(trainingSets);
%uses function 'bagoffeatures' -takes the SURF features from each category
%and minimizes it by using k-means clustering technique

img = read(imgSets(1), 1);
featureVector = encode(bag, img);
%counts how many features are in an image 

figure
bar(featureVector)
title('image word occurrences')
xlabel('image word index')
ylabel('number of repetitions')
%histogram of image word occurrences to show for the images
%gives an idea for training a classifier 

%%
%we used linear SVM here with machine learning to create a classifer

categoryClassifier = trainImageCategoryClassifier(trainingSets, bag);
%uses the data from the encode command to create feature vectors for each
%image category from the array of imagesets created before

%% 
%we have to test the classifier with the training set (.3 of data) and the
%validation set (.7 of data)

confMatrix = evaluate(categoryClassifier, trainingSets);
confMatrix = evaluate(categoryClassifier, validationSets);
%using a confusion matrix

mean(diag(confMatrix));
%finds the amount of accuracy

%%
%testing a image to see how the program works

img = imread(fullfile(rootFolder, 'starfish', 'image_0010.jpg'));
[labelIdx, scores] = predict(categoryClassifier, img);
categoryClassifier.Labels(labelIdx)
answ = categoryClassifier.Labels(labelIdx);
answer = ['say ' answ];
system(answer);
%gives more information about the image