function MoveiVel(pp, setPos, startPos, startTime, toffset)
%MOVEIVEL Summary of this function goes here
%   Detailed explanation goes here

constants;

% makes sure pos's are vertical arrays
setPos = reshape(setPos, [3,1]);
startPos = reshape(startPos, [3,1]);

nextjPos=zeros(1, 3, 'single');

setjPos = ikin(setPos);

% setPos and prevPos are task space locations, giving task space
% velocity
velToSet=(setPos-startPos)/toffset; %velocity in mm/sec
jointVels=pivel(startPos, velToSet);

now = toc;
timeSpan = now - startTime;

% Set up the next setpoint using the velocity found above
% and integrate the velocity using the timespan
for j=1:3
    nextjPos(j)=setjPos(j)+jointVels(j)*timeSpan;
end

% Move the robot to the setpoint and increase runtime
Setpoint(pp,nextjPos(1), nextjPos(2), nextjPos(3));

end

