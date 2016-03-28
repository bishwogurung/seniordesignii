% clearvars
outputFolder = fullfile(tempdir, 'caltech101'); % define output folder
rootFolder = fullfile(outputFolder, '101_ObjectCategories');
imgSets = [ imageSet(fullfile(rootFolder, 'airplanes')), ...
            imageSet(fullfile(rootFolder, 'ferry')), ...
            imageSet(fullfile(rootFolder, 'laptop')) ];
{ imgSets.Description }
[imgSets.Count]

minSetCount = min([imgSets.Count]);

imgSets = partition(imgSets, minSetCount, 'randomize');
[trainingSets, validationSets] = partition(imgSets, 0.3, 'randomize');
imshow(trainingSets);
% trainset = im2single(trainingSets);
% 
% cellSize = 8;
% hog = vl_hog(trainset, cellSize, 'verbose');