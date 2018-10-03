function MoveToPoint(pp, q)
%MOVETOPOINT Takes in the pp and a taskspace positions and
% moves the robot arm to that position

task = ikin(q);

Setpoint(pp, task(1), task(2), task(3));

pause(1.5);

end

