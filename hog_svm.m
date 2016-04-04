rootFolder = fullfile('/Users/Bishwo/Downloads/101_ObjectCategories');

imgSets = [ imageSet(fullfile(rootFolder, 'airplanes')), ...
            imageSet(fullfile(rootFolder, 'ferry')), ...
            imageSet(fullfile(rootFolder, 'laptop')) ];      

minSetCount = min([imgSets.Count]);

imgSets = partition(imgSets, minSetCount, 'randomize');

% for image = 1:numel(imgSets)
%     image = imresize(image, [20 20]);
% end
    %numel - total number of array elements

[trainingSets, testSets] = partition(imgSets, 0.6, 'randomize');


img = read(trainingSets(3), 33);

% Extract HOG features and HOG visualization
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);

% Show the original image
% figure;
% subplot(2,3,1:3); imshow(img);
% 
% % Visualize the HOG features
% subplot(2,3,4);
% plot(vis2x2);
% title({'CellSize = [2 2]'; ['Feature length = ' num2str(length(hog_2x2))]});
% 
% subplot(2,3,5);
% plot(vis4x4);
% title({'CellSize = [4 4]'; ['Feature length = ' num2str(length(hog_4x4))]});
% 
% subplot(2,3,6);
% plot(vis8x8);
% title({'CellSize = [8 8]'; ['Feature length = ' num2str(length(hog_8x8))]});

cellSize = [4 4];
hogFeatureSize = length(hog_4x4);

trainingFeatures = [];
trainingLabels   = [];

for image = 1:numel(trainingSets)

    numImages = trainingSets(image).Count;
    features  = zeros(numImages, hogFeatureSize, 'single');
  
    
    for i = 1:numImages
        img = rgb2gray(read(trainingSets(image), i));
        img = imbinarize(img);
        
% %         img = read(trainingSets(image), i);
% %         lvl = graythresh(img);
% %         img = im2bw(img, lvl);
%         img = im2single(img);

%         img =imresize(img, [25 25]);
        first = extractHOGFeatures(img, 'CellSize', cellSize);
        display('first')
        size(first)
        display('hog_4x4')
        size(hog_4x4)
        features(i, :) = extractHOGFeatures(img, 'CellSize', cellSize);
        size(features)
    end
    
    labels = repmat(trainingSets(image).Description, numImages, 1);
    
    trainingFeatures = [trainingFeatures; features];
    trainingLabels = [trainingLabels; labels];
end

classifier = fitcecoc(trainingFeatures, trainingLabels);
   
[testFeatures, testLabels] = helperExtractHOGFeaturesFromImageSet(testSets, hogFeatureSize, cellSize);

% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

helperDisplayConfusionMatrix(confMat)
