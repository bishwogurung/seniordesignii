% % %%# Read an image
% % I = imread('bread.jpg');
% % %# Create the gaussian filter with hsize = [5 5] and sigma = 2
% % G = fspecial('gaussian',[40 40],40);
% % %# Filter it
% % Ig = imfilter(I,G,'same');
% % %# Display
% % imshow(Ig)
% 
% 
% 
% % imshow('cameraman.tif')
% 
% 
% 
% 

I = imread('gingerbread.jpg');
if size(I, 3)==3
    I=rgb2gray(I);
end
% I=imresize(I,[256,256]);
% I = imresize(I, 0.3);
% I = imgaussfilt(I, 2);
% imshow(I)
% S = imshow(I)
% i=1;
% imshow(I)
% while i~=5
%     B=imresize(I, 0.5);
% %     imshowpair(I, B, 'montage')
% imshow(B)
%     i=i+1;
% % end
sigma = sqrt(2);
% 
% blur_1 = imgaussfilt(I, sigma);
% 
% blur_2 = imgaussfilt(blur_1, sigma);
% 
% blur_3 = imgaussfilt(blur_2, sigma);
% 
% blur_4 = imgaussfilt(blur_3, sigma);
% 
% subplot(3,2,1); imshow(I)
% subplot(3,2,2); imshow(blur_1)
% subplot(3,2,3); imshow(blur_2)
% subplot(3,2,4); imshow(blur_3)
% subplot(3,2,5); imshow(blur_4)

max_octave = 5;
for i=1:max_octave
    I= imresize(I, 1/2*i);
    blur_1 = imgaussfilt(I, sigma);

    blur_2 = imgaussfilt(blur_1, sigma);

    blur_3 = imgaussfilt(blur_2, sigma);

    blur_4 = imgaussfilt(blur_3, sigma);

    subplot(3,2,1); imshow(I)
    subplot(3,2,2); imshow(blur_1)
    subplot(3,2,3); imshow(blur_2)
    subplot(3,2,4); imshow(blur_3)
    subplot(3,2,5); imshow(blur_4)
    
    
        figure;
   
    
    DoG_1 = I-blur_1;
    subplot(2,2,1); imshow(DoG_1)
    DoG_2 = blur_1-blur_2;
    subplot(2,2,2); imshow(DoG_1)
    DoG_3 = blur_2-blur_3;
    subplot(2,2,3); imshow(DoG_1)
    DoG_4 = blur_3-blur_4;
    subplot(2,2,4); imshow(DoG_1)
        
       if i~=5
           figure;
       end



    
end