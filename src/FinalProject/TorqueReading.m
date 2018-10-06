init;
pp = PacketProcessor(myHIDSimplePacketComs);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

Gripper(pp, 0);

% j2 = 35 j1 = 25

tipForce = [0,0,0];
actualTorque = [0,0,0];
count = 100;

% force = zeros(5,3,'single');

% Setpoint(pp, jWorkPos(1), jWorkPos(2), jWorkPos(3));
Setpoint(pp, 0, 0, 90);
pause(1);
% Setpoint(pp, 0, 90, -30);
% pause(2);
% Setpoint(pp, 0, 90, 0);


k = 1;
while 1
    disp('Calculating');
    %     pause(1);
    total = zeros(1,3,'single');
    totalF = zeros(1,3,'single');
    
    for j = 1:count
        [~, ~, torq] = GetStatus(pp);
        total = total + torq * 4096;
        pause(.01);
    end
    
    force = total / count;
    
    disp('Joint 2 Torque');
    disp(force);
    
    actualTorque=RawToTorque(force);
    
    tipForce=statics3001(jWorkPos, actualTorque);
    disp('Z Force');
    disp(tipForce');
    
    waitforbuttonpress;
end

pp.shutdown();