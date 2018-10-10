%% This function should be called with angle measurements for each of
%The joints, it will then move the joints as such
function angles = Setpoint(pp, joint1, joint2, joint3)
global PID_ID
ANGLE_TO_TIC = 4096.0/360.0;

try
    packet = zeros(15, 1, 'single');
    packet(1) = ANGLE_TO_TIC * joint1;
    packet(4) = ANGLE_TO_TIC * joint2;
    packet(7) = ANGLE_TO_TIC * joint3;
    
    statusPacket = pp.command(PID_ID, packet);
    
    
    angles = statusPacket([1,4,7]);
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
end
