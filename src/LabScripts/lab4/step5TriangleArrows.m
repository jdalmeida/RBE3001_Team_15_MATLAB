init;
pp = PacketProcessor(myHIDSimplePacketComs);

%% Initialize Servers and Points

handleGetter=GraphSingleton();
writer=CSVWriter();
fileName=writer.BeginCsv('step5TriangleArrows');

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

LivePlot3D([0,0,0], true);
pause(.1);
%% Inject the reader here

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
v0 = .5;   %this .5, .5 makes it run way smoother
vf = .5;
a0 = 0;
af = 0;

conds = [t0, tf, q0, qf, v0, vf, a0, af];
%creates 3xcond size for joints (joints = rows)
condsMat = [conds; conds; conds];

toffset = .75;    %difference between t0 and tf

posn = zeros(1,3, 'single'); % to hold end positions 
angles = zeros(1,3, 'single'); 
% Initial point is the 3rd vertex of the triangle
prevPos = Triangle(3, :);

q = quiver3(0,0,0,0,0,0);

tic;

% iterate through each setpoint in triangles
for i = 0:3
    index = mod(i,3) + 1; % continuously cycle through points of the triangle
    
    % initial and final joint angles required for the trajectory
    % converts the tip position into angles
%     prevAngles = ikin(prevPoint);
%     setAngles = ikin(Triangle(index, :));
    setPos = Triangle(index, :);
    
    now = toc;  % current timestamp  
    startTime = now; % to keep track of when the trajectory is starting
    
    % iterates through each of the axes to get conditions
    for axis = 1:3
        condsMat(axis, 1) = startTime;           %t0
        condsMat(axis, 2) = startTime + toffset; %tf
        condsMat(axis, 3) = prevPos(axis);       %q0
        condsMat(axis, 4) = setPos(axis);        %qf
    end
    
    % loop across the trajectory
    while now < (startTime + toffset)
        now = toc;       % update current time each loop iteration
        
        % generate the positions for each joint
        for j = 1:3
            posn(j) = QuinticTraj(now, condsMat(j, :)); %this is a 1x3 that stores x y z of tip position
        end
%         disp(posn);
        angles = ikin(posn);
        % Go to the setpoint based on the equation
        Setpoint(pp, angles(1), angles(2), angles(3));
        
        % Update 3D Model
        [jPos, jVel, ~]= GetStatus(pp);
        
        jPos = TIC_TO_ANGLE * jPos;
        jVel = TIC_TO_ANGLE * jVel;
        disp(jVel);
        tipPos = LivePlot3D(jPos, false, true);
        
        % Calculate and graph tip velocities
        tipVel = fwVel(jPos, jVel);
        jac = jacob0(jPos);
        
        x = tipPos(1);
        y = tipPos(2);
        z = tipPos(3);
        
        u = double(tipVel(1));
        v = double(tipVel(2));
        w = double(tipVel(3));
        
        
        quiver = handleGetter.getVelArrowHandle();
        quiver3(0,0,0,0,0,0);
        
        % Adds to CSV
        data = [now tipPos jPos];
        writer.AppendCsv(fileName, data);
        now = toc;
    end
    pause(.25);
    prevPos=setPos;
end
    
% Clear up memory upon termination
pp.shutdown();
clear