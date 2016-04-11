% clearvars

% uint8('hello')

rootFolder = fullfile('/Users/Bishwo/Downloads/101_ObjectCategories');
imgSets = [ imageSet(fullfile(rootFolder, 'airplanes')), ...
            imageSet(fullfile(rootFolder, 'cup')), ...
            imageSet(fullfile(rootFolder, 'ferry')), ...
            imageSet(fullfile(rootFolder, 'starfish')) ];      

minSetCount = min([imgSets.Count]);

imgSets = partition(imgSets, minSetCount, 'randomize');

[trainingSets, testSets] = partition(imgSets, 0.3, 'randomize');

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

% testFeatures = [];
% testLabels   = [];
% for pic = 1:numel(testSets)
%     numImages = testSets(pic).Count;
%     tfeatures  = zeros(numImages, hogFeatureSize, 'single');
%     
%     for i = 1:numImages
%         img = read(testSets(pic), i);
%         img = imresize(img, train_img_size);
%         lvl = graythresh(img);
%         img = im2bw(img, lvl);
%         tfeatures(i, :) = extractHOGFeatures(img, 'CellSize', cellSize);
%     end
%     
%     tlabels = repmat({testSets(pic).Description}, numImages, 1);
%     
%     testFeatures = [testFeatures; tfeatures];
%     testLabels = [testLabels; tlabels];
% end
classifier = fitcecoc(trainingFeatures, trainingLabels);
% categoryClassifier = trainImageCategoryClassifier(trainingSets, trainingFeatures);
% confMatrix = evaluate(categoryClassifier, testSets)
% aa = imread('http://d111vui60acwyt.cloudfront.net/product_photos/3169638/Profile(1)_original.jpg');%cup
aa = imread('http://thumbs.dreamstime.com/z/caribbean-starfish-26107095.jpg');%starfish

aa = imresize(aa, train_img_size);
lvl = graythresh(aa);
aa = im2bw(aa, lvl);
[testfeature, testlabelz] = extractHOGFeatures(aa, 'CellSize', cellSize);
testlabel = 'answer';
testlabel = cellstr(testlabel);

predictedlabel = predict(classifier, testfeature);
confMat = confusionmat(testlabel, predictedlabel);

[c, order] = confusionmat(testlabel, predictedlabel);
order{2}
answer = ['say ' order{2}];
system(answer);
clearvars