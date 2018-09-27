%% Initialize Servers and Points
init;
pp = PacketProcessor(myHIDSimplePacketComs);

handleGetter=GraphSingleton();
writer=CSVWriter();
fileName=writer.BeginCsv('val9');

LivePlot3D([0,0,0], true);
pause(.1);
          
%% Initialize it to 3rd Setpoint
% To make the csv cleaner
firstPoint_Angles = [0,0,0];
Setpoint(pp, firstPoint_Angles(1), firstPoint_Angles(2), firstPoint_Angles(3));
pause(.5);

LivePlot3D(firstPoint_Angles, false, true);
prevPos = fwkin(0,0,0)';

secPerPoint=1;
totalTime=0;

%% Loop through each setpoint
while 1
    [setPos]=ginput3d(1);
    disp(setPos);
    % initial and final joint angles required for the trajectory
    % Gets the setPos in terms of x,y,z (not joint angles)
    setjPos = ikin(setPos);
    runTime=0;
    
    % Get the velocity for each of the setpoints based off the time
    % for each point
    [curPos, ~, ~]= GetStatus(pp);
    curPos=TIC_TO_ANGLE * curPos;
    % setPos and prevPos are task space locations, giving task space
    % velocity
    velToSet=(setPos-prevPos)/secPerPoint; %velocity in mm/sec
    jointVels=pivel(curPos, velToSet');
    
    nextjPos=zeros(1, 3, 'single');
    
    % While the time in the current setpoint is less than the time allotted
    % for the setpoint
    while runTime < secPerPoint
        % get the timestamp set up and let the arm move for a bit
        % using the pause
        tic;
        [curPos, ~, ~]= GetStatus(pp);
        curPos=TIC_TO_ANGLE * curPos;
        LivePlot3D(curPos, false, true);

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
    
    prevPos=setPos;
end
clear