%% This sets up the pid values for each of the arms
init;
pp = PacketProcessor(myHIDSimplePacketComs);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.0025 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

LivePlot3D([0,0,0], true);
pause(.5);
tic;

%% Setpoints for part 6
% Setpoint(pp, 24.4, 14.8, 12.9);
% Setpoint(pp, -0.2,82.2,-20.1);
% Setpoint(pp, -29.2, 14.2, 8.8);
% Setpoint(pp, 32.9, 50.3, -3.3);
% Setpoint(pp, -31.2, 54, -.6);
% Plot6;

%% Setpoints for part 7
Setpoint(pp, 0, 2.2, -3.5);
Setpoint(pp, 0, 71.7, -20.7);
Setpoint(pp, 0, -1.2, 29.5);
Setpoint(pp, 0, 2.2, -3.5);

% Clear up memory upon termination
pp.shutdown();
clear