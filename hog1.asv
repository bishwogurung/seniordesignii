%Note: this example uses HOG

%REFERENCE: 
% http://www.mathworks.com/help/vision/ref/extracthogfeatures.html?refresh=true#btypoih
% http://www.mathworks.com/help/vision/ref/detectfastfeatures.html

I2 = imread('pyramids.jpg');
 corners   = detectFASTFeatures(rgb2gray(I2));
 
 figure(1);
 %uses FAST algorithm here
 imshow(I2); hold on;
plot(corners.selectStrongest(50));
   
 strongest = selectStrongest(corners,3);
[hog2, validPoints, ptVis] = extractHOGFeatures(I2,strongest);
 

figure(2);
%showing strongest points founded by hog
    imshow(I2); hold on;
    plot(ptVis,'Color','red');
    
figure(3);
%extract hog features using cellsize
[hog1, visualization] = extractHOGFeatures(I2,'CellSize',[32 32]);

 subplot(1,2,1);
    imshow(I2);
    subplot(1,2,2);
    plot(visualization);
    
    figure(4);
    %hog features
    [featureVector, hogVisualization] = extractHOGFeatures(I2);
    
    imshow(I2); hold on;
    plot(hogVisualization);
    