
init;
posCsv='step_13.csv';
pp = PacketProcessor(myHIDSimplePacketComs);
%returnPacket = pp.command(PROTOCOL_ID , packet);
%get the 1,4,7 packet from return to see the location
%set to 30,50,50
% Setpoint(pp, 0, 0, 0);
% pause(3);
Setpoint(pp, 30, 50, 50);
% pause(3);
% Setpoint(pp, 0, 0, 0);

clear