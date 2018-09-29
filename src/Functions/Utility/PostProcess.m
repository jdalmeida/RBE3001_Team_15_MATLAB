function [BWProcessed] = PostProcess(BWin)
%POSPROCESS Provide a Bw image and will return a cleaned image
%   Detailed explanation goes here
se = strel('sphere',6);
%Yellow
BWProcessed=imerode(BWin, se);
BWProcessed = imdilate(BWProcessed,se);
BWProcessed=imfill(BWProcessed,'holes');
end

