init;
pp = PacketProcessor(myHIDSimplePacketComs);

%% Initialize Servers and Points
writer=CSVWriter();
fileName=writer.BeginCsv('ExtraCred');

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.0025 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

LivePlot3D([0,0,0], true);
pause(.5);
Path = csvread('path2draw.csv');
[rows, cols] = size(Path);

%% Initialize it to 3rd Setpoint
% To make the csv cleaner
qvals = ikin(Path(1, :));
Setpoint(pp, qvals(1), qvals(2), qvals(3));
pause(.5);

%% Run through setpoints
tolerance = 4;
notCompleted = true;

% loops through each setpoint of the arm
tic
for i=2:rows
    
    qvals = ikin(Path(i, :));
    
    %gets position and sets point
    Setpoint(pp, qvals(1), qvals(2), qvals(3));
    notCompleted = true;
    
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
            if abs(angles(j) - qvals(j)) > tolerance
                notCompleted = true;
            end
        end
        
        %         pause(.01);
    end
end


% Clear up memory upon termination
pp.shutdown();
clear