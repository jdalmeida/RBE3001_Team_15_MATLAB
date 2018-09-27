%% Calibrate arm to home position
Calibrate;

init;
pp = PacketProcessor(myHIDSimplePacketComs);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

% init liveplot
LivePlot3D([0,0,0], true);
pause(.1);

%% Move to directly overhead
Setpoint(pp, 0, 90, 0);
pause(1);
Setpoint(pp, 0, 90, 90);
pause(1);

y0total = zeros(1,3, 'single');

counts = 100;
for i = 1:counts
[pos, vel, torq] = GetStatus(pp);
disp(torq)

pos = TIC_TO_ANGLE * pos;
LivePlot3D(pos, false, true);

y0total = y0total + torq;
end

avgy0 = y0total / counts;
disp('avg offset');
disp(avgy0);

Setpoint(pp, 0, 90, 0);
pause(1);
Setpoint(pp, 0, 0, 0);
pause(1);
Setpoint(pp, 0, 0, 90);
pause(1);

disp('PUT KNOWN WEIGHT ON END OF ARM');
pause(2);

totalkx = zeros(1,3, 'single');
for i = 1:counts
[pos, vel, torq] = GetStatus(pp);
disp(torq)

pos = TIC_TO_ANGLE * pos;
LivePlot3D(pos, false, true);

totalkx = torq - avgy0

pause(.05);
end

avgkx = totalkx/counts;

j2k = avgkx(2) / (.25 * 9.8 * (.175+.16928));
j3k = avgkx(3) / (.25 * 9.8 * (.16928));

disp('offset');
disp(avgy0);

disp('joint 2 scale factor');
disp(j2k);
disp('joint 3 scale factor');
disp(j3k);


pp.shutdown();
