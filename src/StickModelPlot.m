init;
pp = PacketProcessor(myHIDSimplePacketComs);

LivePlot3D([0,0,0], true);

p = 

while 1
    centroids  = FindCentroid();
    [pos, ~, torq]= GetStatus(pp);
    
    pos = TIC_TO_ANGLE * pos;
    actualTorque=RawToTorque(torq);
    
    tipForce=statics3001(pos, actualTorque);
    
    LivePlot3D(pos, false, true, tipForce);
    pause(.01);
end

pp.shutdown();
clear