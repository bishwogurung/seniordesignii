rootFolder = fullfile('/Users/Bishwo/Downloads/101_ObjectCategories');

imgSets = [ imageSet(fullfile(rootFolder, 'airplanes')), ...
            imageSet(fullfile(rootFolder, 'ferry')), ...
            imageSet(fullfile(rootFolder, 'starfish')) ];      

minSetCount = min([imgSets.Count]);

imgSets = partition(imgSets, minSetCount, 'randomize');

[trainingSets, testSets] = partition(imgSets, 0.3, 'randomize');

img = read(trainingSets(1), 2);
train_img_size = [size(img, 1), size(img, 2)];

for pic = 1:numel(testSets)
    numImages = testSets(pic).Count;
    
    for i = 1:numImages
        img = read(testSets(pic), i);
        img = imresize(img, train_img_size);
        lvl = graythresh(img);
        img = im2bw(img, lvl);
    end
end

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

classifier = fitcecoc(trainingFeatures, trainingLabels);

[testFeatures, testLabels] = helperExtractHOGFeaturesFromImageSet(testSets, hogFeatureSize, cellSize);
% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

% helperDisplayConfusionMatrix(confMat)
