init;
pp = PacketProcessor(myHIDSimplePacketComs);

LivePlot3D([0,0,0], 1);

while 1 
    [pos, v, f]= GetStatus(pp);
    pos = TIC_TO_ANGLE * pos;
    LivePlot3D(pos, 0);
    pause(.01);
end

pp.shutdown();
clear