init;
pp = PacketProcessor(myHIDSimplePacketComs);

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

for i = 1:150
    UpdateStickModel;
    pause(.05);
end

Setpoint(pp, angles2(1), angles2(2), angles2(3));

for i = 1:150
    UpdateStickModel;
    pause(.05);
end


pp.shutdown();
clear