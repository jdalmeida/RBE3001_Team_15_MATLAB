%% This sets up the pid values for each of the arms
init;
pp = PacketProcessor(myHIDSimplePacketComs);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.0025 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

LivePlot3D([0,0,0], true);
pause(.5);
tic;

%% Setpoints for part 6
% pointsPart6 = [24.4, 14.8, 12.9;...
%     -0.2,82.2,-20.1;...
%     -29.2, 14.2, 8.8;...
%     32.9, 50.3, -3.3;...
%     -31.2, 54, -.6];

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

% Matrix of all the the setpoint joint angles (j1, j2, j3)
trianglePts = [0, 0, 0;...
    0, 71.7, -20.7;...
    0, -1.2, 29.5;...
    0, 2.2, -3.5];

%% Go to the points
[rows, ~] = size(trianglePts);
v0 = 0;
vf = 0;

tic;

% iterate through each setpoint in triangles
for i = 2:rows
    
    toffset = 1;
    now = toc;  % Current timestamp
    coeffiecients = zeros(3, 4, 'single'); % joints -> rows; ai -> cols
    angles = zeros(1,3, 'single'); % to hold end positions
    
    % iterate through each joints for each setpoints
    % to get the coeffiecents for the trajectory
    for j = 1:3
        q0 = trianglePts(i-1, j);
        qf = trianglePts(i, j);
        coeffiecients(j, :) = TrajectoryGen(now, now + toffset, q0, qf, v0, vf);
    end
    
    startTime = now;
    
    % loop for each trajectory 
    while now < startTime + toffset
        now = toc;       % reset current time each loop iteration
        
        % generate the positions for the 
        for j = 1:3
            angles(j) = trajectoryPosition(coeffiecients(j,:), now);
        end
        
        
    end
    
end

% loop
% q(toc)
% setpoint (q1(toc))
%     while (toc - lastToc < .1)
    
% Clear up memory upon termination
pp.shutdown();
clear

function q = trajectoryPosition(a, t)
    q = a(1) + a(2)*t + a(3)*t^2 + a(4)*t^3;
end