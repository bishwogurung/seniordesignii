rootFolder = fullfile('/Users/Bishwo/Downloads/101_ObjectCategories');

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


% minSetCount = min([imgSets.Count]);
minSetCount = 10;

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

% categoryClassifier = trainImageCategoryClassifier(trainingSets, trainingFeatures);
% confMatrix = evaluate(categoryClassifier, testSets)
% testpic = imread('http://d111vui60acwyt.cloudfront.net/product_photos/3169638/Profile(1)_original.jpg');%cup
% testpic = imread('http://thumbs.dreamstime.com/z/caribbean-starfish-26107095.jpg');%starfish
% testpic = imread('test_image1.jpg'); %starfish
testpic = imread('http://cdn.history.com/sites/2/2013/12/egyptian-pyramids-hero-H.jpeg'); %pyramid
% testpic = imread('test_image5.jpeg'); %pyramids
% testpic = imread('img2.jpg'); %dollar-bill snapshot from webcam
% testpic = imread('test_image1.jpg');

testpic = imresize(testpic, train_img_size);
lvl = graythresh(testpic);
testpic = im2bw(testpic, lvl);
[testfeature, testlabelz] = extractHOGFeatures(testpic, 'CellSize', cellSize);
testlabel = 'answer';
testlabel = cellstr(testlabel);

paroptions = statset('UseParallel', true);

tic
treeModel = TreeBagger(30, trainingFeatures, trainingLabels, 'Method', 'classification', 'Options', paroptions);                                                                                                              
toc
% delete(gcp('nocreate')) %terminates current parpool session
% tic
% treeModel = TreeBagger(20, trainingFeatures, trainingLabels, 'Method', 'classification');                                                                                                               
% toc
predictedlabel = predict(treeModel, testfeature);

% predictedlabel = predict(classifier, testfeature);
confMat = confusionmat(testlabel, predictedlabel);

[c, order] = confusionmat(testlabel, predictedlabel);
order{2}
answer = ['say ' order{2}];
system(answer);
% clearvars