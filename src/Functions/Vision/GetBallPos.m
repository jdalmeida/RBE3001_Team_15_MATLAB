function [ballInfo] = GetBallPos(usingPokemon, cam)
%GETBALLPOS Summary of this function goes here
%   Detailed explanation goes here
constants;

centroids = FindCentroid(cam);
fields = fieldnames(centroids);

ballInfo = zeros(3, 5, 'double');

% Loop to iterate through each centroids point to generate the graph
for i=1:numel(fields)
    myColor=centroids.(fields{i})*10;
    
    ballcolor = COLORS(i);
    
    % if none of that color, set to EMPTY
    if isempty(myColor)
        ballcolor = EMPTY;
        ballInfo(i, :) = [0,0,0, ballcolor, HEAVY];
        continue;
    end
        
    % for no pokemon
    % linear fit to fix scale of mn2xy
    z=0;
    if usingPokemon
        x = myColor(:, 1) * .908 + 193 + 17;
        if i == 3
            x = x - 20;
        elseif i==2
            z=-40;
            x=x-25;
        end
    else
        z = -20;
        x = myColor(:, 1) * .908 + 193;
    end
    y = myColor(:, 2) * .815 + .823 + 18;

    
    ballInfo(i, :) = [x, y, z, ballcolor, HEAVY];
    
    if abs(y) >= YBOUND || x >= XBOUND        
        ballcolor = EMPTY;
        ballInfo(i, :) = [0,0,0, ballcolor, HEAVY];
    end
end

end

