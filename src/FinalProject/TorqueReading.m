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

Setpoint(pp, 0, 35, -25);
pause(1);
    
k = 1;
while 1
    disp('Calculating');
%     pause(1);
    total = zeros(1,3,'single');
    totalF = zeros(1,3,'single');
    
    for j = 1:count
        [pos, ~, torq] = GetStatus(pp);
        torq = torq * 4096;
        pos = TIC_TO_ANGLE * pos;
        
        actualTorque=RawToTorque(torq);
        
        tipForce=statics3001(pos, actualTorque);
        totalF = totalF + tipForce';
        total = total + torq;
        pause(.01);
    end
    
    force = total / count;
    disp('Raw ADC');
    disp(force);
    
    n = norm(force);
    disp('Norm Raw');
    disp(n);
    
    tf = totalF / count;
%     disp('Tip Force');
%     disp(tf);
    
    
    if n < 3.93e+03
        disp('light');
    else
        disp('heavy');
    end
    
    waitforbuttonpress;
end
% x = mean(force(:, 1));
% y = mean(force(:, 2));
% z = mean(force(:, 3));
% 
% norm([x,y,z]);

pp.shutdown();