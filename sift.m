% %%# Read an image
% I = imread('bread.jpg');
% %# Create the gaussian filter with hsize = [5 5] and sigma = 2
% G = fspecial('gaussian',[40 40],40);
% %# Filter it
% Ig = imfilter(I,G,'same');
% %# Display
% imshow(Ig)

I = imread('bread.jpg');
if size(I, 3)==3
    I=rgb2gray(I);
end
I = imresize(I, 0.1);
% I = imgaussfilt(I, 2);
% imshow(I)
% S = imshow(I)
i=1;


% imshow(I)
% while i~=5
%     B=imresize(I, 0.5);
% %     imshowpair(I, B, 'montage')
% imshow(B)
%     i=i+1;
% end
while i~=5
    blur = imgaussfilt(I, 2);
    imshow(I)
    i=i+1;
end