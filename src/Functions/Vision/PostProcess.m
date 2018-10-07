function [BWProcessed] = PostProcess(BWin)
%POSPROCESS Provide a Bw image and will return a cleaned image
%   Detailed explanation goes here
% se = strel('sphere',6);
% 
% BWProcessed=imerode(BWin, se);
% BWProcessed = imdilate(BWProcessed,se);
% BWProcessed=imfill(BWProcessed,'holes');
%% Filter image
% gets rid of everthing less than 100 pixels in area
BWProcessed = bwpropfilt(BWin, 'Area', [100 + eps(100), Inf]);

%% Get centroid.
% [y, x] = ndgrid(1:size(BW_out, 1), 1:size(BW_out, 2));
% BWProcessed = mean([x(logical(BW_out)), y(logical(BW_out))]);
end

