function toffset = Findtoffset(startPos, setPos, setVel)
%FINDTOFFSET takes in 2 arrays and a velocity 
%   Returns the time to travel between them

%  distance needed to travel
distance = abs(norm(startPos) - norm(setPos));

% time to travel based on distance and vel
toffset = distance / setVel;

% minimum time needs to be 1 or else everything break
% idk y tho
if toffset < 1
    toffset = 1;
end

end

