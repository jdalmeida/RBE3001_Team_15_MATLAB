%% First time setup for the packets and constants
init;
pp = PacketProcessor(myHIDSimplePacketComs);

%for link 1 pid of .0025, 0, 0
%for link 2, pid of .0025, 0, .028 works well +/-3deg
%for link 3, pid of .0025, 0 , .02
%% Sets the pid values for each of the arms before moving to the setpoint
jToSet1=zeros(3,1,'single');
jToSet1=[.0025 0 0];
jToSet2=zeros(3,1,'single');
jToSet2=[.0025 0 .028];
jToSet3=zeros(3,1,'single');
jToSet3=[.0025 0 .02];
PIDConfig(pp, jToSet1, jToSet2, jToSet3);
%% Moves the robot to the setpoint (in degrees) for each of the joints.
Setpoint(pp,-20,30.0132,5);
pp.shutdown();
clear