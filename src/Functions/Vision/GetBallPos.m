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
    z=-20;
    x = 0;
    y = 0;
    if usingPokemon
        x = myColor(:, 1) * .908 + 193 + 17;
        y = myColor(:, 2) * .815 + .823 + 18;
        z = -40; % height for pokemon
        
        if i == 3
            x = x - 40; % x adjust to grab pikachu tail
            
        elseif i==2
            z=-40;      % z adjust for bulbasaur height
            x = x -25;  % x to grab its bulb
            y = y-10;
            
        elseif i == 1
            x =  myColor(:, 1) * .905 + 188;
            
        end
        
    else
        y = myColor(:, 2) * .815 + .823 + 18;
        
        if y > 0
            x = myColor(:, 1) * .908 + 193 - 15;
            y = y - 10;
        else
            x = myColor(:, 1) * .908 + 193;
        end
    end
    
    
    ballInfo(i, :) = [x, y, z, ballcolor, HEAVY];
    
    if abs(y) >= YBOUND || x >= XBOUND
        ballcolor = EMPTY;
        ballInfo(i, :) = [0,0,0, ballcolor, HEAVY];
    end
end

end

