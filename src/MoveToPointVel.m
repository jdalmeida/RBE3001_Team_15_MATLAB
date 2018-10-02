function MoveToPointVel(pp, setPos)
%MOVETOPOINTCONTROL Takes in setpoint and moves arm using velocity control
constants;

setPos = reshape(setPos, [3,1]);

secPerPoint = 1.5;
totalTime = 0;
setjPos = ikin(setPos);
runTime=0;

% Get the velocity for each of the setpoints based off the time
% for each point
[curPos, ~, ~]= GetStatus(pp);
curPos=TIC_TO_ANGLE * curPos';

prevPos = curPos;
% setPos and prevPos are task space locations, giving task space velocity
velToSet=(setPos-prevPos)/secPerPoint; %velocity in mm/sec
jointVels=pivel(curPos, velToSet);

nextjPos=zeros(1, 3, 'single');

% While the time in the current setpoint is less than the time allotted
% for the setpoint
while runTime < secPerPoint
    % get the timestamp set up and let the arm move for a bit
    % using the pause
    tic;
    [curPos, ~, torq]= GetStatus(pp);
    curPos=TIC_TO_ANGLE * curPos;
    
    actualTorque=RawToTorque(torq);
    tipForce=statics3001(curPos, actualTorque);
    
    LivePlot3D(curPos, false, false, tipForce);
    
    timeSpan=toc;
    
    % Set up the next setpoint using the velocity found above
    % and integrate the velocity using the timespan
    for j=1:3
        nextjPos(j)=setjPos(j)+jointVels(j)*timeSpan;
    end
    
    % Move the robot to the setpoint and increase runtime
    Setpoint(pp,nextjPos(1), nextjPos(2), nextjPos(3));
    timeSpan=toc;
    runTime=runTime+timeSpan;
    totalTime=totalTime+timeSpan;
    
    %creates a csv with time, cartisian velocities, tip magnitude, and
    %joint velocities
    %data= [totalTime cartisianVel norm(cartisianVel) jointVels(1:3, 1)' ];
    % writer.AppendCsv(fileName, data);
end

end

