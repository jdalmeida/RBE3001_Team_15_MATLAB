init;
pp = PacketProcessor(myHIDSimplePacketComs);

PID1=[0 0 0];
PID2=[0 0 0];
PID3=[0 0 0];
PIDConfig(pp, PID1, PID2, PID3);

while 1
    Setpoint(pp, 0, 0, 0);
end
