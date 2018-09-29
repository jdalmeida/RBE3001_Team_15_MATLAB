init;
pp = PacketProcessor(myHIDSimplePacketComs);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);
%30/45/-18
Setpoint(pp, 0, 0, 90);
pause(3);

for i=1:10
    [pos, ~, torq] = GetStatus(pp);
    pos = TIC_TO_ANGLE * pos;
    disp('Pos');
    disp(pos);
    disp('Raw');
    disp(torq);
    actualTorque=RawToTorque(torq);
    disp('joint torque');
    disp(actualTorque);
    tipForce=statics3001(pos, actualTorque);
    disp('Force');
    disp(tipForce');
end
pp.shutdown();
clear