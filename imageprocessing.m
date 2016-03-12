%REFERENCE:
% https://icme.hpc.msstate.edu/mediawiki/index.php/Image_Processing_with_MATLAB_1


fname = uigetfile('SAND.tif');
     I = imread(fname);
     figure(1)
     imshow(I,[])
     
     figure(2)
     imhist(I)
     
     figure(3)
      J1 = I > 170;
     imshow(J1,[])
     
     figure(4)
      level = graythresh(I);
     pixel = level * 255;
     J2 = im2bw(I,level);
     imshow(J2)
     
     figure(5)
      nsize = 40; 
     I_background = ordfilt2(I,1,true(nsize),'symmetric');
     I_background = imerode(I,strel('square',nsize));
     imshow(I_background,[])
     
     figure(6)
      I_leveled = double(I) - double(I_background);
     imshow(I_leveled,[])
     
     figure(7)
      I_leveled = uint8((I_leveled - min(I_leveled(:)))/(max(I_leveled(:)) - min(I_leveled(:))) * 255);
     imhist(I_leveled)
     
     figure(8)
     manual_threshold = 120;
     J3 = I_leveled > manual_threshold;
     imshow(J3,[])
     
     figure(9)
    BW = J3;
     CC = bwconncomp(BW);
     L = labelmatrix(CC);
     stats  = regionprops(L);
     area = [stats.Area];
     size_thresh = 10;
     idx = find(area > size_thresh);
     BW2 = ismember(L, idx);
     imshow(BW2)
     
     figure(10)
     BW3 = imfill(BW2,'holes');
     imshow(BW3)
     
     figure(11)
     BW_trial = imdilate(BW3,strel('square',5));
     imshow(BW_trial)
     level = graythresh(I_leveled(BW_trial));
     pixel = level * 255;
     BW4 = im2bw(I_leveled,level);
     BW4(~BW_trial) = 0;
     BW4 = imfill(BW4,'holes');
     BW4 = bwareaopen(BW4,30);
     imshow(BW4,[])
     
     figure(12)
       BW5 = bwperim(BW4);
     imshow(BW5,[])
     I2 = I; I2(BW5) = 255;
     I_RGB = I2;
     I2 = I; I2(BW5) = 0;
     I_RGB(:,:,2) = I2;
     I2 = I; I2(BW5) = 0;
     I_RGB(:,:,3) = I2;
     imshow(I_RGB,[])
     
     imwrite(I_RGB,'image_RGB.tif','tif')
     imwrite(BW4,'image_binary.tif','tif')
     imwrite(I_leveled,'image_leveled.tif','tif')
     