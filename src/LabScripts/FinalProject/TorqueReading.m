init;
pp = PacketProcessor(myHIDSimplePacketComs);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);
%30/45/-18
Setpoint(pp, 20, 45, -10);
pause(2);

tipForce = [0,0,0];
actualTorque = [0,0,0];

limit = 2.8;
while 1
    [pos, ~, torq] = GetStatus(pp);
    pos = TIC_TO_ANGLE * pos;
%     disp('Raw');
%     disp(torq);
    
    actualTorque=RawToTorque(torq);
%     disp('joint torque');
%     disp(actualTorque);
    
    tipForce=statics3001(pos, actualTorque);
    disp('Force');
    disp(tipForce');
    
    % normalized force can see the difference between the light and heavy
    n = norm(tipForce);
    disp(n);
    
    if n < limit
        disp('LIGHT');
    else 
        disp('HEAVY');
    end
    
    waitforbuttonpress;   
end

pp.shutdown();