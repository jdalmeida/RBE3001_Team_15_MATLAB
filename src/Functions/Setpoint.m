%% This function should be called with angle measurements for each of
%The joints, it will then move the joints as such
function Setpoint(pp, joint1, joint2, joint3)
constants;

try
    packet = zeros(15, 1, 'single');
    packet(1) = ANGLE_TO_TIC * joint1;
    packet(4) = ANGLE_TO_TIC * joint2;
    packet(7) = ANGLE_TO_TIC * joint3;
    pp.write(PID_ID, packet);
    pause(0.003);
    returnPacket = pp.read(PID_ID);
    
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
end
