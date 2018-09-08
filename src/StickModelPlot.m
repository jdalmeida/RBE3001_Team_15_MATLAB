init;
pp = PacketProcessor(myHIDSimplePacketComs);

LivePlot3D([0,0,0], true);

while 1 
    [pos, v, f]= GetStatus(pp);
    pos = TIC_TO_ANGLE * pos;
    LivePlot3D(pos, false, R);
    pause(.01);
end

pp.shutdown();
clear