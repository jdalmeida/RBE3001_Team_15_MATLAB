%% Calibrate arm to home position
Calibrate;

init;
pp = PacketProcessor(myHIDSimplePacketComs);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);


%% Move to directly overhead to get all offsets
% No Mass on the end 
Setpoint(pp, 0, 90, 0);
pause(1);
Setpoint(pp, 0, 90, 90);
pause(1);

y0total = zeros(1,3, 'single');

counts = 100;
for i = 1:counts
[pos, vel, torq] = GetStatus(pp);
disp(torq)

y0total = y0total + torq;
pause(.01);
end

% offset in terms of adc values
avgoffset = y0total / counts;


%% Find torque due to link 3

Setpoint(pp, 0, 90, 0);
pause(1);
Setpoint(pp, 0, 0, 0);
pause(1);
Setpoint(pp, 0, 0, 90);
pause(1);


totaltorq = zeros(1,3, 'single');
for i = 1:counts
[pos, vel, torq] = GetStatus(pp);
disp(torq)

totaltorq = totaltorq + torq;

pause(.01);
end





Setpoint(pp, 0, 90, 0);
pause(1);

totaltorq = zeros(1,3, 'single');
for i = 1:counts
[pos, vel, torq] = GetStatus(pp);
disp(torq)

totaltorq = totaltorq + torq;

pause(.01);
end

avgtorq = totaltorq/counts;
avgkx = avgtorq - avgoffset;

j2k = avgkx(2) / (.25 * 9.8 * (175+169.28));
j3k = avgkx(3) / (.25 * 9.8 * (169.28));

disp('offset');
disp(avgoffset);

disp('joint 2 scale factor');
disp(j2k);
disp('joint 3 scale factor');
disp(j3k);


pp.shutdown();
