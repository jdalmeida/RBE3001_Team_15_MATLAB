init;

%% This sets up the pid values for each of the arms

%the following values work well:
% jToSet1=[.0025 0 0];
% jToSet2=[.0025 0 .028];
% jToSet3=[.0025 0 .02];

pp = PacketProcessor(myHIDSimplePacketComs);
zeroMat = zeros(3,1, 'single');
jToSet1=zeros(3,1,'single');
jToSet1=[.0025 0 0];
jToSet2=zeros(3,1,'single');
jToSet2=[.0025 0 .028];
jToSet3=zeros(3,1,'single');
jToSet3=[.0025 0 .02];
PIDConfig(pp, jToSet1, jToSet2, jToSet3);
pause(.1);
Setpoint(pp, 25.2,   78.7,  -32.5);
pause(1)
Setpoint(pp, 0, 0, 0);
% Clear up memory upon termination
pp.shutdown();
clear