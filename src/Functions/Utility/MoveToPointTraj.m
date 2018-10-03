function MoveToPointTraj(pp, setPos)
%MOVETOPOINTCONTROL Takes in setpoint and moves arm using velocity control
constants;

setPos = reshape(setPos, [3,1]);
% setjPos = ikin(setPos);

t0 = 0;
tf = 0;
q0 = 0;
qf = 0;
v0 = 30.0;   %this .5, .5 makes it run way smoother
vf = v0;
a0 = 1;
af = 1;


conds = [t0, tf, q0, qf, v0, vf, a0, af];

%creates 3xcond size for joints (joints = rows)
condsMat = [conds; conds; conds];

[curPos, ~, ~]= GetStatus(pp);
curPos=TIC_TO_ANGLE * curPos';

prevPos = fwkin(curPos(1), curPos(2), curPos(3));

distance = abs(norm(prevPos) - norm(setPos));

toffset = distance / vf;    %difference between t0 and tf

if toffset < 1.25
    toffset = 1.25;
end

tic;
posn = zeros(1,3, 'single'); % to hold end positions
angles = zeros(1,3, 'single');

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
    
    angles = ikin(posn);
    % Go to the setpoint based on the equation
    Setpoint(pp, angles(1), angles(2), angles(3));
    
    % Update 3D Model
    UpdateStickModel;
    pause(.1);
end


end

