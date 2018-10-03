function MoveTraj(pp, setPos, startPos, startTime, toffset)
%MOVETRAJ takes setpoint and moves arm there

%% Generate Conditions
constants;

% makes sure pos's are vertical arrays
setPos = reshape(setPos, [3,1]);
startPos = reshape(startPos, [3,1]);

% Velocity of arm
setVel = 20;

% conditiosn for quintic of form:
%       t0,tf,q0,qf, v0,     vf,     a0, af
conds = [0, 0, 0, 0, setVel, setVel, 0, 0];

%creates 3xcond size for joints (joints = rows)
condsMat = [conds; conds; conds];

% to hold end positions
posn = zeros(1,3, 'single');
angles = zeros(1,3, 'single');

% iterates through each of the axes to set conditions
for axis = 1:3
    condsMat(axis, 1) = startTime;           %t0
    condsMat(axis, 2) = startTime + 1.5; %tf
    condsMat(axis, 3) = startPos(axis);       %q0
    condsMat(axis, 4) = setPos(axis);        %qf
end

now = toc;       % update current time each loop iteration

% generate the positions for each joint
for j = 1:3
    posn(j) = QuinticTraj(now, condsMat(j, :)); %this is a 1x3 that stores x y z of tip position
end

angles = ikin(posn);

% Go to the setpoint based on the equation
Setpoint(pp, angles(1), angles(2), angles(3));

end