%%listing all the folders within a directory
% listing = dir('animals/');
% Folders = listing(~strncmpi('.', {listing.name}, 1));
% sub_categories = {Folders.name}


clearvars
<<<<<<< HEAD
my_dir = '/Users/Bishwo/Documents/102_objectcategories/animals/';
=======
my_dir = 'animals/other_animals/';
>>>>>>> 8587d2db6893a61b0c6518d24cabc6f22c6a1337
imgSets = imageSet(fullfile(my_dir), 'recursive');
% imgSets=imageSet(fullfile(my_dir));
               
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

% [trainingSets, testSets] = partition(imgSets, 0.6, 'randomize');
trainingSets = partition(imgSets, .8, 'randomize');

img = read(trainingSets(1), 2);
train_img_size = [size(img, 1), size(img, 2)];

% Extract HOG features and HOG visualization
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);

cellSize = [4 4];
hogFeatureSize = length(hog_4x4);

trainingFeatures = [];
trainingLabels   = [];
tic
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
toc

tic
classifier = fitcecoc(trainingFeatures, trainingLabels);
toc
% categoryClassifier = trainImageCategoryClassifier(trainingSets, trainingFeatures);
% confMatrix = evaluate(categoryClassifier, testSets)
% testpic = imread('http://d111vui60acwyt.cloudfront.net/product_photos/3169638/Profile(1)_original.jpg');%cup
% testpic = imread('http://thumbs.dreamstime.com/z/caribbean-starfish-26107095.jpg');%starfish
% testpic = imread('test_image1.jpg'); %starfish
% testpic = imread('http://cdn.history.com/sites/2/2013/12/egyptian-pyramids-hero-H.jpeg'); %pyramid
% testpic = imread('test_image5.jpeg'); %pyramids
% testpic = imread('img2.jpg');

% testpic = imread('ENTER URL HERE');
% pic = 'http://images.dailystar.co.uk/dynamic/1/photos/306000/Shawn-Hanson-cougar-Dachshund-dog-puppy-Salmon-Beach-British-Columbia-257306.jpg'; %ant
% pic = 'ant2.jpg';
% pic = (ENTER PIC OR URL HERE); 
pic = 'http://www.rosecityhedgehogs.com/uploads/ppet1_1456179c.jpg';
testpic = imread(pic); %dollar bill

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
answer = ['say ' order{2}];
system(answer);
% clearvars
system('say Is this correct?');
confirm = input('Is this correct? (Enter y for yes or n for no):', 's');
if confirm == 'n'
    system('say What is the correct class for this object?');
    correct_answer = input('What is the correct class for this object? ', 's');
    
    %saving url content to current directory with a shorter name
    [str, status] = urlread(pic);
    if status
        url = pic;
        filename = 'testing_url_pic.jpg';
        outfilename = websave(filename, url);
        pic = filename;
    else
        disp('error');
    end
    
    target_location = strcat(my_dir,correct_answer);
    if exist(target_location, 'file')~=7
        mkdir(target_location)
        for i=1:20
%             display(target_location)
            copyfile(pic, [strcat(target_location, '/'), 'testimage_', num2str(i), '.jpg']);
        end
    else
        for i=1:20
            copyfile(pic, [strcat(target_location, '/'), 'testimage_', num2str(i), '.jpg']);
        end
    end
 
    display('Thank you for your input. Now, please run the program to try again.')
    system('say Thank you for your input. Now, please run the program to try again.');
    
end    


