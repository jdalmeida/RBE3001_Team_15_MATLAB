init;
pp = PacketProcessor(myHIDSimplePacketComs);

%% Initialize Servers and Points
writer=CSVWriter();
fileName=writer.BeginCsv('step7QuinticTriangle');

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
firstPoint_Angles = ikin(Triangle(3, :));
Setpoint(pp, firstPoint_Angles(1), firstPoint_Angles(2), firstPoint_Angles(3));
pause(.5);


%% Trajectory Generated Loop
t0 = 0;
tf = 0;
q0 = 0;
qf = 0;
v0 = 0;
vf = 0;
a0 = 0;
af = 0;

conds = [t0, tf, q0, qf, v0, vf, a0, af];
%creates 3xcond size for joints (joints = rows)
condsMat = [conds; conds; conds];

toffset = .5;    %difference between t0 and tf

angles = zeros(1,3, 'single'); % to hold end positions 

% Initial point is the 3rd vertex of the triangle
prevPoint = Triangle(3, :);

tic;

% iterate through each setpoint in triangles
for i = 0:3
    %% Using end effector postion
    index = mod(i,3) + 1; % continuously cycle through points of the triangle
    
    % initial and final joint angles required for the trajectory
    % converts the tip position into angles
    prevAngles = ikin(prevPoint);
    setAngles = ikin(Triangle(index, :));
    
    now = toc;  % current timestamp  
    startTime = now; % to keep track of when the trajectory is starting
    
    %% Working in joint angles
    % iterates through each of the joints to get conditions
    for joint = 1:3
        condsMat(joint, 1) = startTime;           %t0
        condsMat(joint, 2) = startTime + toffset; %tf
        condsMat(joint, 3) = prevAngles(joint);   %q0
        condsMat(joint, 4) = setAngles(joint);    %qf
    end
    
    % loop across the trajectory
    while now < (startTime + toffset)
        now = toc;       % update current time each loop iteration
        
        % generate the positions for each joint
        for j = 1:3
            angles(j) = QuinticTraj(now, condsMat(j, :));
        end
        
        % Go to the setpoint based on the equation
        Setpoint(pp, angles(1), angles(2), angles(3));
        
        % Update 3D Model
        [anglePos, ~, ~]= GetStatus(pp);
        anglePos = TIC_TO_ANGLE * anglePos;
        tipPos = LivePlot3D(anglePos, false, true);
        
        % Adds to CSV
        data = [now tipPos anglePos];
        writer.AppendCsv(fileName, data);
        
    end
    
    prevPoint=Triangle(index, :);
end
    
% Clear up memory upon termination
pp.shutdown();
clear