%% This function should be called with angle measurements for each of
%The joints, it will then move the joints as such
function angles = Setpoint(pp, joint1, joint2, joint3)
global PID_ID
global weightOnTip

if isempty(weightOnTip)
    weightOnTip = 0;
end


ANGLE_TO_TIC = 4096.0/360.0;

g = 9.8;
l2 = .175; %m
l3 = .16928; %m
mass1 = 1; %kg
mass2 = .100;
maxTorques=[1.8641, .6636];

try
    curPos = GetCurrentPos(pp);
    q2 = curPos(2);
    q3 = curPos(3);
    
    j2in = l2 * cosd(q2) * mass1 * g;
    
    j3in = (l2 * cosd(q2) + l3 * cosd(q3 - 90 + q2)) * (mass2 + weightOnTip) * g;
    
    j2out = j2in/maxTorques(1)/10;
    j3out = j3in/maxTorques(2)/10;
   
    packet = zeros(15, 1, 'single');
    packet(1) = ANGLE_TO_TIC * joint1;
    packet(4) = ANGLE_TO_TIC * joint2;
    packet(5) = j2out;
    packet(7) = ANGLE_TO_TIC * joint3;
    packet(8) = j3out;
    
    statusPacket = pp.command(PID_ID, packet);
    
    angles = statusPacket([1,4,7]);
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
end
