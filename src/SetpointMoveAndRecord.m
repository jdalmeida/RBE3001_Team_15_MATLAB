
init;
pp = PacketProcessor(myHIDSimplePacketComs);
Setpoint(pp, 25.2,   78.7,  -32.5);

% Clear up memory upon termination
pp.shutdown();
clear