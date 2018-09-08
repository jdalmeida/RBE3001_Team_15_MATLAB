init;
pp = PacketProcessor(myHIDSimplePacketComs);

LivePlot3D([0,0,0], true);

while 1
    [pos, v, f]= GetStatus(pp);
    
    LivePlot3D(pos, false);
    
    pause(.5);
end


clear