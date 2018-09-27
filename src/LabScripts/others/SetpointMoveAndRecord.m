%% This sets up the pid values for each of the arms
init;
pp = PacketProcessor(myHIDSimplePacketComs);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.0025 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

LivePlot3D([0,0,0], true);
pause(.5);
% tic;

%% Setpoints for part 6
% Setpoint(pp, 24.4, 14.8, 12.9);
% Setpoint(pp, -0.2,82.2,-20.1);
% Setpoint(pp, -29.2, 14.2, 8.8);
% Setpoint(pp, 32.9, 50.3, -3.3);
% Setpoint(pp, -31.2, 54, -.6);
% Plot6;


%% Setpoints for part 7
% Setpoint(pp, 0, 2.2, -3.5);
% Setpoint(pp, 0, 71.7, -20.7);
% Setpoint(pp, 0, -1.2, 29.5);
% Setpoint(pp, 0, 2.2, -3.5);
% PlotCSV7;


%% Trajectory planning with part 9

% Matrix of all the the setpoint joint angles (j1, j2, j3)
trianglePts = [0, 0, 0;...
               0, 15, -17.5;...
               0, 9.3, 16;...
               0, 40.5, 1.5;...
               0, 15, -17.5];

[rows, cols] = size(trianglePts);
v0 = 0;
vf = 0;
toffset = 1;    %difference between t0 and tf

angles = zeros(1,3, 'single'); % to hold end positions 

tic;

% iterate through each setpoint in triangles
for i = 2:rows
    
    coeffiecients = zeros(3, 4, 'single'); % joints -> rows; ai -> cols
    
    now = toc;  % Current timestamp
    
    % iterateisplays the time elapsed since the tic command  through each joints for each setpoints
    % to get the coeffiecents for the trajectory
    for j = 1:3
        q0 = trianglePts(i-1, j);
        qf = trianglePts(i, j);
        coeffiecients(j, :) = TrajectoryGen(now, now + toffset, q0, qf, v0, vf);
    end
    
    startTime = now; % to keep track of when the trajectory is starting
    
    % loop for each trajectory 
    while now < (startTime + toffset)
        now = toc;       % upd'trajectory_8.csv'ate current time each loop iteration
        % generate the positions for the 
        for j = 1:3
            angles(j) = trajectoryPosition(coeffiecients(j,:), now);
        end
        
        % Go to the setpoint based on the equation
        Setpoint(pp, angles(1), angles(2), angles(3));
        
        UpdateStickModel;
        pause(.05);
    end
    
end
% PlotCSV7;
    
% Clear up memory upon termination
pp.shutdown();
clear

function q = trajectoryPosition(a, t)
    q = a(1) + a(2)*t + a(3)*t^2 + a(4)*t^3;
end