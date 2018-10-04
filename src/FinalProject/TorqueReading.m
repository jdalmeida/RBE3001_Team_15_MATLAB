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
count = 10;

% force = zeros(5,3,'single');

Setpoint(pp, jWorkPos(1), jWorkPos(2), jWorkPos(3));
pause(1);

k = 1;
while 1
    disp('Calculating');
    %     pause(1);
    total = zeros(1,3,'single');
    totalF = zeros(1,3,'single');
    
    for j = 1:count
        [~, ~, torq] = GetStatus(pp);
        torq = torq * 4096;
        
        %         totalF = totalF + tipForce';
        total = total + torq;
        pause(.01);
    end
    
    force = total / count;
    
    disp('Norm Raw');
    disp(force);
    
    actualTorque=RawToTorque(force);
    
    tipForce=statics3001(jWorkPos, actualTorque);
    disp('Tip Force');
    disp(tipForce');
    
    
%     if n < 3.93e+03
%         disp('light');
%     else
%         disp('heavy');
%     end
    
    waitforbuttonpress;
end

pp.shutdown();