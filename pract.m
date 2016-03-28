% for i=1:2
%     img = imread(['/Users/Bishwo/Downloads/101_ObjectCategories/starfish2/image' num2str(i) '.jpg']);
%     if size(img, 3)==3
%         img = rgb2gray(img);
%     end
%     img = im2single(img);
%     cellSize = 8;
%     hog = vl_hog(img, cellSize, 'verbose');
%     %following two commands visualize the features
%     imhog = vl_hog('render', hog, 'verbose') ;
%     clf ;   imagesc(imhog) ;     colormap gray ;
%     
% 
% end
clearvars
for i=1:4
%     jpgFileName = strcat('/Users/Bishwo/Downloads/101_ObjectCategories/starfish2/image', num2str(i), '.jpg');
%     if exist(jpgFileName, 'file')
% %         clearvars
%         imageData = imread(jpgFileName)
% %         imshow(imageData{i});
%     else
%         fprintf('File %s does not exist.\n', jpgFileName);
%         
%     
%     end
    img{i} = imread(['/Users/Bishwo/Downloads/101_ObjectCategories/starfish2/image' num2str(i) '.jpg'])
    figure (i)
%     imshow(img{i})
%     img{i} = imread(['/Users/Bishwo/Downloads/101_ObjectCategories/starfish2/image',i,'.jpg']);
%     imshow(imageData{i})
%     img{i} = imread(['/Users/Bishwo/Downloads/101_ObjectCategories/starfish2/image' num2str(i) '.jpg']);
%     imshow(img{i})
    if size(img{i}, 3)==3
        img{i} = rgb2gray(img{i});
    end
    img{i} = im2single(img{i});
    cellSize = 8;
    hog{i} = vl_hog(img{i}, cellSize, 'verbose');
    %following two commands visualize the features
    imhog = vl_hog('render', hog{i}, 'verbose') ;
    clf ;   imagesc(imhog) ;     colormap gray ;
    
end