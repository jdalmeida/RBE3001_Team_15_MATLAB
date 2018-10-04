function [ballInfo] = GetBallPos(cam)
%GETBALLPOS Summary of this function goes here
%   Detailed explanation goes here
constants; 

centroids = FindCentroid(cam);
fields = fieldnames(centroids);

% Loop to iterate through each centroids point to generate the graph
for i=1:numel(fields)
    myColor=centroids.(fields{i})*10;
    
    ballcolor = COLORS(i);
    
    if isempty(myColor)
        ballcolor = EMPTY;
        ballInfo(i, :) = [0,0,0, ballcolor, HEAVY];
        continue;
    end
    
    [rows, ~] = size(myColor);
    zPos = zeros(rows, 1, 'single');
    x = myColor(:, 1) * 2.34 - 236;
    y = myColor(:, 2) * 1.37 +2.12;
    z = 0;
    
    if abs(y) >= YBOUND || x >= XBOUND
        ballcolor = EMPTY;
        ballInfo(i, :) = [0,0,0, ballcolor, HEAVY];
    end
    
%     set(scatterHandles(i).handle, 'xdata', x, 'ydata', y,'zdata', z);
    ballInfo(i, :) = [x, y, z, ballcolor, HEAVY];
end

end

