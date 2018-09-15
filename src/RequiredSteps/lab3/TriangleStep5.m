init;
pp = PacketProcessor(myHIDSimplePacketComs);

%% Initialize Servers and Points
writer=CSVWriter();
fileName=writer.BeginCsv('step5Triangle');


PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.0025 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

LivePlot3D([0,0,0], true);
pause(.5);

Triangle=[170 100 60;...
          170 -50 60;...
          240 -50 60];

%% Initialize it to 3rd Setpoint
% To make the csv cleaner
qVals = ikin(Triangle(3, :));
Setpoint(pp, qVals(1), qVals(2), qVals(3));
pause(.5);

%% Run through setpoints
tolerance = 4;
notCompleted = true;

% loops through each setpoint of the arm 
tic
for i=0:3
    pointInd=mod(i,3) + 1;
    nextInd=mod(pointInd, 3)+1; %This is the next setpoint
    
    qVals = Triangle(pointInd, :);
    nextQVals= Triangle(nextInd, :);
    qDiff= (nextQVals-qVals)/10;
    % This need to check the pointInd and +1 to see what the difference/10 in
    % x, y, z is; this should then do diff*10+pointInd to get the setpoint
   for k= 1:10
        qPoints=qVals+qDiff*k;
        qToSet=ikin(qPoints);
        %gets position and sets point
        Setpoint(pp, qToSet(1), qToSet(2), qToSet(3));
        notCompleted = true;
        disp(k);
        % loops until the arm reaches the setpoint
        while notCompleted
            [angles, ~, ~]= GetStatus(pp);
            angles = TIC_TO_ANGLE * angles;
            tipPos = LivePlot3D(angles, false, true);
            time = toc;
            
            writer.AppendCsv(fileName, [time tipPos angles]);
            % will continue in loop until all angles are within tolerance
            notCompleted = false;
            for j = 1:3
                if abs(angles(j) - qToSet(j)) > tolerance
                    notCompleted = true;
                end
            end
            
            %pause(.01);
        end
    end
    
    pause(.1);
end


% Clear up memory upon termination
pp.shutdown();
clear