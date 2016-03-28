% img = imread('gingerbread.jpg');
% [featureVector, hogVisualization] = extractHOGFeatures(img);
% figure;
% imshow(img); hold on;
% plot(hogVisualization);

% [hog1, visualization] = extractHOGFeatures(img, 'CellSize', [64 128]);
% subplot(1,2,1);
% imshow(img);
% subplot(1,2,2);
% plot(visualization);

% corners = detectFASTFeatures(rgb2gray(img));
% strongest = selectStrongest(corners, 3);
% [hog2, validPoints, ptVis] = extractHOGFeatures(img, strongest);
% figure;
% imshow(img); hold on;
% % plot(ptVis, 'Color', 'green');
im = imread('dog.jpg');
img = im2single(im);
% cellsize = 8;
% % hog = vl_hog(img, cellsize, 'verbose');
% % imhog = vl_hog('render', hog, 'verbose') ;
% % clf ; imagesc(imhog) ; colormap gray ;
% % size(hog)
% 
% cellSize = 8 ;
% hog = vl_hog(img, cellSize, 'verbose', 'variant', 'dalaltriggs') ;
% imhog = vl_hog('render', hog, 'verbose', 'variant', 'dalaltriggs') ;
% imshow(imhog)



% 
% 
% cellSize = 8 ;
% hog = vl_hog(im, cellSize, 'verbose') ;
% 
% imhog = vl_hog('render', hog, 'verbose') ;
% clf ; imagesc(imhog) ; colormap gray ;
clearvars
img = imread('bread.jpg');
imshow(img)