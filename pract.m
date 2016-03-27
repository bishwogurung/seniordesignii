for i=1:2
    img = imread(['/Users/Bishwo/Downloads/101_ObjectCategories/starfish2/image' num2str(i) '.jpg']);
    if size(img, 3)==3
        img = rgb2gray(img);
    end
    img = im2single(img);
    cellSize = 8;
    hog = vl_hog(img, cellSize, 'verbose');
    %following two commands visualize the features
    imhog = vl_hog('render', hog, 'verbose') ;
    clf ; imagesc(imhog) ; colormap gray ;
    

end