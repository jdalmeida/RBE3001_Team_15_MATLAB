init;
pp = PacketProcessor(myHIDSimplePacketComs);
writer=CSVWriter();
fileName=writer.BeginCsv('step3b');
PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.0025 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

LivePlot3D([0,0,0], true);
pause(.5);

point1 = [200, 150, 55];
point2 = [115, -122, 110];

angles1 = ikin(point1);
angles2 = ikin(point2);

Setpoint(pp, angles1(1), angles1(2), angles1(3));
tic
for i = 1:150*5
    [anglePos, ~, ~]= GetStatus(pp);
    anglePos = TIC_TO_ANGLE * anglePos;
    endPos = LivePlot3D(anglePos, false, true);
    time = toc;
    time_joint_pos = [time endPos anglePos];
    writer.AppendCsv(fileName, time_joint_pos);
    pause(.01);
end
disp('finished first run');
pause(1);
Setpoint(pp, angles2(1), angles2(2), angles2(3));

for i = 1:150*5
    [anglePos, ~, ~]= GetStatus(pp);
    anglePos = TIC_TO_ANGLE * anglePos;
    endPos = LivePlot3D(anglePos, false, true);   
    time = toc;
    time_joint_pos = [time endPos anglePos];
    writer.AppendCsv(fileName, time_joint_pos);
    pause(.01);
end


pp.shutdown();
clear