% Get the triangle points and live plot set up
% calculate the jacobian 
% use the inverse to get the velocity
% Use that velocity x the time diff to get position
% write it to that position
% update the jacobian

%% Initialize Servers and Points
init;
pp = PacketProcessor(myHIDSimplePacketComs);

handleGetter=GraphSingleton();
writer=CSVWriter();
fileName=writer.BeginCsv('step7VelocityKinematics');

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

LivePlot3D([0,0,0], true);
pause(.1);

Triangle=[170 100 60;...
          170 -50 60;...
          240 -50 60];
fullPosition=[0 0 0;
              Triangle];
prevPoint=[0;0;0];
%% Initialize it to 3rd Setpoint
% To make the csv cleaner
firstPoint_Angles = ikin(Triangle(3, :));
Setpoint(pp, firstPoint_Angles(1), firstPoint_Angles(2), firstPoint_Angles(3));
pause(.5);
tic;
secPerPoint=2;
totalTime=0;
%% Loop through each setpoint
for i = 0:3
    index = mod(i,3) + 1; % continuously cycle through points of the triangle
    % Gets the cartisian velocity for the csv
    cartisianVel= (fullPosition(index+1, :)-fullPosition(index, :))/secPerPoint;
    
    % initial and final joint angles required for the trajectory
    % Gets the setPos in terms of x,y,z (not joint angles)
    setPos = ikin(Triangle(index, :));
    [curPos, ~, ~]= GetStatus(pp);
    curPos=TIC_TO_ANGLE * curPos;
    runTime=0;

    % Get the velocity for each of the setpoints based off the time
    % for each point

    velToSet=(setPos-prevPoint)/secPerPoint; %velocity in mm/sec
    jointVels=ivel(curPos, velToSet');
    nextPos=zeros(1, 3, 'single');
    
    % While the time in the current setpoint is less than the time allotted
    % for the setpoint
    while runTime < secPerPoint
        % get the timestamp set up and let the arm move for a bit
        % using the pause
        tic;
        
        [curPos, ~, ~]= GetStatus(pp);
        curPos=TIC_TO_ANGLE * curPos;
        
        LivePlot3D(curPos, false, true);
        pause(.1);
        timeSpan=toc;
        
        % Set up the next setpoint using the velocity found above
        % and integrate the velocity using the timespan
        for j=1:3
            nextPos(j)=setPos(j)+jointVels(j)*timeSpan;
        end
        
        % Move the robot to the setpoint and increase runtime
        Setpoint(pp,nextPos(1), nextPos(2), nextPos(3));        
        timeSpan=toc;
        runTime=runTime+timeSpan;
        totalTime=totalTime+timeSpan;
        
        %creates a csv with time, cartisian velocities, tip magnitude, and
        %joint velocities
        data= [totalTime cartisianVel norm(cartisianVel) jointVels(1:3, 1)' ];
        writer.AppendCsv(fileName, data);
    end
    
    % reset previous point for the next run
    prevPoint=setPos;
end
clear