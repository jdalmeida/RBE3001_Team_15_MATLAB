init;
pp = PacketProcessor(myHIDSimplePacketComs);

%for link 1 pid of .0025, 0, 0
%for link 2, pid of .0025, 0, .028 works well +/-3deg
%for link 3, pid of .0025, 0 , .02

zeroMat = zeros(3,1, 'single');
jToSet1=zeros(3,1,'single');
jToSet1=[.0025 0 0];
jToSet2=zeros(3,1,'single');
jToSet2=[.0025 0 .028];
jToSet3=zeros(3,1,'single');
jToSet3=[.0025 0 .02];
PIDConfig(pp, jToSet1, jToSet2, jToSet3);

Setpoint(pp,-76.8164,36.0132,-9.2285);

pp.shutdown();
clear