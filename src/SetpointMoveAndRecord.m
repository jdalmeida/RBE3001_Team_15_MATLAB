%% This sets up the pid values for each of the arms
init;
%the following values work well:
% jToSet1=[.0025 0 0];
% jToSet2=[.0025 0 .028];
% jToSet3=[.0025 0 .02];

pp = PacketProcessor(myHIDSimplePacketComs);
PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.0025 0 .02];
PIDConfig(pp, PID1, PID2, PID3);
%pause(1);
LivePlot3D([0,0,0], true);
Setpoint(pp, 25.2,   78.7,  -32.5);

pause(2);
Setpoint(pp, 0,0,0);

pause(2);
Setpoint(pp, -80, 40, 0);

pause(2);
Setpoint(pp, 0,0,0);
% Clear up memory upon termination
pp.shutdown();
clear