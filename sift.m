% %%# Read an image
% I = imread('bread.jpg');
% %# Create the gaussian filter with hsize = [5 5] and sigma = 2
% G = fspecial('gaussian',[40 40],40);
% %# Filter it
% Ig = imfilter(I,G,'same');
% %# Display
% imshow(Ig)



% imshow('cameraman.tif')





I = imread('cameraman.tif');
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
blur_1 = imgaussfilt(I, sigma);

blur_2 = imgaussfilt(blur_1, sigma);

blur_3 = imgaussfilt(blur_2, sigma);

blur_4 = imgaussfilt(blur_3, sigma);

subplot(3,2,1); imshow(I)
subplot(3,2,2); imshow(blur_1)
subplot(3,2,3); imshow(blur_2)
subplot(3,2,4); imshow(blur_3)
subplot(3,2,5); imshow(blur_4)

% while i~=6
%     blur = imgaussfilt(I, sigma);
%     imshow(blur)
%     3
%     i=i+1;
% end