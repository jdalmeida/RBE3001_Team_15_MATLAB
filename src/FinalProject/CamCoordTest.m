if ~exist('cam', 'var') % connect to webcam iff not connected
    cam = webcam();
    pause(1); % give the camera time to adjust to lighting
end

%% Request two points from user to define bounding box
while 1
%% Data acquisiton and enhancement
%img = imread('camTest.png');
img = snapshot(cam);

%% Segment on color
[BWBlue,~]=FindBlue(img);
[BWYellow,~]=FindYellow(img);
[BWGreen, ~]=FindGreen(img);

%% post process with dilation
% se = strel('sphere',6);
%Yellow
BWYellow=PostProcess(BWYellow);
%Blue
BWBlue=PostProcess(BWBlue);
%Green
BWGreen=PostProcess(BWGreen);

%% information extraction
sBlue = regionprops(BWBlue,'centroid');
centrBlue = cat(1, sBlue.Centroid);
sYellow = regionprops(BWYellow,'centroid');
centrYellow = cat(1, sYellow.Centroid);
sGreen = regionprops(BWGreen,'centroid');
centrGreen = cat(1, sGreen.Centroid);

%% Show on live feed
BW = imfuse(BWBlue, BWYellow);
BW = imfuse(BW, BWGreen);
BW = imfuse(BW, img);
imshow(BW);
hold on
if size(centrBlue)>0
    plot(centrBlue(:,1),centrBlue(:,2), 'b*');
    disp(centrBlue(1));
end
if size(centrYellow)>0
    plot(centrYellow(:,1),centrYellow(:,2), 'y*');
    disp(centrYellow(1));
end
if size(centrGreen)>0
    plot(centrGreen(:,1),centrGreen(:,2), 'g*');
    disp(centrGreen(1));
end
hold off
pause(.2);
end
clear;