function [c] = FindCentroid()
%GETCENTROID Input is an image
% outputs the array of centroid coordinates in a 3d array
% Columns: (x, y, m, n)
% Rows: 1 set of coordinates for object
% Page: 1-Blue 2-Green 3-Yellow
persistent cam;
if isempty(cam) % connect to webcam iff not connected
    cam = webcam();
    pause(1); % give the camera time to adjust to lighting
end

img = snapshot(cam);

%% Segment on color
[BWBlue,~]=FindBlue(img);
[BWGreen, ~]=FindGreen(img);
[BWYellow,~]=FindYellow(img);


%% Post Process with dilation
BWBlue=PostProcess(BWBlue);
BWGreen=PostProcess(BWGreen);
BWYellow=PostProcess(BWYellow);

%% information extraction
sBlue = regionprops(BWBlue,'centroid');
centrBlue = cat(1, sBlue.Centroid);
sGreen = regionprops(BWGreen,'centroid');
centrGreen = cat(1, sGreen.Centroid);
sYellow = regionprops(BWYellow,'centroid');
centrYellow = cat(1, sYellow.Centroid);

empty = zeros(0,2, 'double');
blue = empty;
green = empty;
yellow = empty;

% checks if there are any bulbs to enter coords for
if size(centrBlue)>0
    blue = mn2xy(centrBlue(1),centrBlue(2));
end
if size(centrGreen)>0
    green = mn2xy(centrGreen(1),centrGreen(2));
end
if size(centrYellow)>0
    yellow = mn2xy(centrYellow(1),centrYellow(2));
end

c = struct('b', blue, 'g', green, 'y', yellow);
end

