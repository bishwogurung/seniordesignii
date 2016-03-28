%{
%Objective---------
%take picture of intended search object, take picture of the
%background scene, identify strongest feature points in both
%images, find feature descriptors, show matched features, 
%find the object in the environment by placing a box over it

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%camera check

webcamlist
cam = webcam
%tells you about the webcam

preview(cam)
pause(2)
closePreview(cam)
%opens the camera so you can see it
%then closes it

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this part takes a snapshot of the intended object to be founded
%by taking a picture of it with the webcam 

     %%%%%%%%%hold up particular object to be founded%%%%%%%%%%%

object = snapshot(cam);
imshow(object)
%takes a picture with the camera 

imwrite(object,'object.jpg','jpg')
%saves the image of object

clear('cam');
%saves the image just taken

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pause is given to adjust camera if needed before a snapshot of the
%backgound is taken

pause(5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this part takes a snapshot of the background 
cam1  = webcam

background = snapshot(cam1);
imshow(background)
%takes a picture with the camera 

imwrite(background,'background.jpg','jpg')
%saves the image of background

clear('cam1');
%saves the image just taken


%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%show the object image

O = imread('object.jpg');
figure(1);
imshow(O);
title('Object');
%original image of object

figure(2);
DarkO = rgb2gray(O);
imshow(DarkO);
title('image of object gray scaled');
%image turned into black and white

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%show the background image

B = imread('background.jpg');
figure(3);
imshow(B);
title('Background');
%original image of background

figure(4);
DarkB = rgb2gray(B);
imshow(DarkB);
title('image of background gray scaled');
%image turned into black and white

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%commands used to detect feature points using SURF algorithm 
%showing both for the object and the background

objectpoints = detectSURFFeatures(DarkO);
backgroundpoints = detectSURFFeatures(DarkB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%showing the strongest features points from the object

figure(5); 
imshow(DarkO);
hold on;
plot(selectStrongest(objectpoints, 100));
title('100 Strongest Feature Points from Object');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%showing the strongest features points from the background

figure(6);
imshow(DarkB);
hold on;
plot(selectStrongest(backgroundpoints, 300));
title('300 Strongest Feature Points from Scene Image');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


