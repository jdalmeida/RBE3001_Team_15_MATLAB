init;
pp = PacketProcessor(myHIDSimplePacketComs);

LivePlot3D([0,0,0], true);

pdot = [0; 0; -10];

while 1
    [jPos, jVel, ~]= GetStatus(pp);
    jPos = TIC_TO_ANGLE * jPos;
    jVel = TIC_TO_ANGLE * jVel;
    
    tipPos = LivePlot3D(jPos, false, true);
    
    calcJVel = ivel(jPos, pdot);
    
    disp(calcJVel);
    
    pause(.01);
end