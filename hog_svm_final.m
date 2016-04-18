<<<<<<< HEAD
%%
%We are using Caltech 101 image data set for our reference pictures.

url = 'http://www.vision.caltech.edu/Image_Datasets/Caltech101/101_ObjectCategories.tar.gz';
%using the link from the internet 

outputFolder = fullfile(tempdir, 'caltech101'); 
%downloading the caltech files 

if ~exist(outputFolder, 'dir') 
    disp('Downloading 126MB Caltech101 data set...');
    untar(url, outputFolder);
end
%'if' loop incase we re-run our code, this should download the images only once


rootFolder = fullfile(outputFolder, '101_ObjectCategories');
=======
rootFolder = fullfile('/Users/Bishwo/Downloads/101_ObjectCategories');
>>>>>>> faa04ab4d957ced937d41bb787168105acff0aee

imgSets = [ imageSet(fullfile(rootFolder, 'airplanes')), ...
            imageSet(fullfile(rootFolder, 'cup')), ...
            imageSet(fullfile(rootFolder, 'ferry')), ...
            imageSet(fullfile(rootFolder, 'dollar_bill')) ...
            imageSet(fullfile(rootFolder, 'pyramid')), ...
            imageSet(fullfile(rootFolder, 'starfish')) ]; 

% imgSets = imageSet(rootFolder);
        
% webcamlist;
% cam = webcam;
% %tells you about the webcam
% 
% preview(cam)
% pause(2)
% closePreview(cam)
% %opens the camera so you can see it
% %then closes it
% 
% img2 = snapshot(cam);
% imshow(img2)
% %takes a picture with the camera 
% 
%      imwrite(img2,'img2.jpg','jpg');
% 
% clear('cam');


minSetCount = min([imgSets.Count]);

imgSets = partition(imgSets, minSetCount, 'randomize');

[trainingSets, testSets] = partition(imgSets, 0.6, 'randomize');

img = read(trainingSets(1), 2);
train_img_size = [size(img, 1), size(img, 2)];

% Extract HOG features and HOG visualization
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);

cellSize = [4 4];
hogFeatureSize = length(hog_4x4);

trainingFeatures = [];
trainingLabels   = [];
<<<<<<< HEAD

=======
tic
>>>>>>> faa04ab4d957ced937d41bb787168105acff0aee
for pic = 1:numel(trainingSets)

    numImages = trainingSets(pic).Count;
    features  = zeros(numImages, hogFeatureSize, 'single');
  
    for i = 1:numImages
        img = read(trainingSets(pic), i);
        img = imresize(img, train_img_size);
        lvl = graythresh(img);
        img = im2bw(img, lvl);

        features(i, :) = extractHOGFeatures(img, 'CellSize', cellSize);
    end
    
    labels = repmat({trainingSets(pic).Description}, numImages, 1);
    
    trainingFeatures = [trainingFeatures; features];
    trainingLabels = [trainingLabels; labels];
end
<<<<<<< HEAD

classifier = fitcecoc(trainingFeatures, trainingLabels);
=======
toc

tic
classifier = fitcecoc(trainingFeatures, trainingLabels);
toc
>>>>>>> faa04ab4d957ced937d41bb787168105acff0aee
% categoryClassifier = trainImageCategoryClassifier(trainingSets, trainingFeatures);
% confMatrix = evaluate(categoryClassifier, testSets)
% testpic = imread('http://d111vui60acwyt.cloudfront.net/product_photos/3169638/Profile(1)_original.jpg');%cup
% testpic = imread('http://thumbs.dreamstime.com/z/caribbean-starfish-26107095.jpg');%starfish
% testpic = imread('test_image1.jpg'); %starfish
% testpic = imread('http://cdn.history.com/sites/2/2013/12/egyptian-pyramids-hero-H.jpeg'); %pyramid
% testpic = imread('test_image5.jpeg'); %pyramids
% testpic = imread('img2.jpg');
<<<<<<< HEAD
testpic = imread('test_image1.jpg');
=======
testpic = imread('test_image4.jpg');
>>>>>>> faa04ab4d957ced937d41bb787168105acff0aee

testpic = imresize(testpic, train_img_size);
lvl = graythresh(testpic);
testpic = im2bw(testpic, lvl);
[testfeature, testlabelz] = extractHOGFeatures(testpic, 'CellSize', cellSize);
testlabel = 'answer';
testlabel = cellstr(testlabel);

predictedlabel = predict(classifier, testfeature);
confMat = confusionmat(testlabel, predictedlabel);

[c, order] = confusionmat(testlabel, predictedlabel);
order{2}
<<<<<<< HEAD
% answer = ['say ' order{2}];
% system(answer);
% clearvars

%%%%%%%%%
%windows text to speech addition 
if isempty(predictedlabel)
	return;
end; 
caUserInput = char(predictedlabel); % Convert from cell to string.
NET.addAssembly('System.Speech');
obj = System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume = 100;
Speak(obj, caUserInput);
=======
answer = ['say ' order{2}];
system(answer);
% clearvars
>>>>>>> faa04ab4d957ced937d41bb787168105acff0aee
