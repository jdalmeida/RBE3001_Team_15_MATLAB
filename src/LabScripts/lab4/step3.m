init;
pp = PacketProcessor(myHIDSimplePacketComs);


LivePlot3D([0,0,0], true);
pause(.5);

while 1
    [pos, v, f]= GetStatus(pp);
    pos = TIC_TO_ANGLE * pos;
    LivePlot3D(pos, false, true);
    pause(.01);
    
    J = jacob0(pos);
    
    Jp = J(1:3, :);
    
    determinant = det(Jp);
    
    disp(determinant);
    
    pause(.25);
end

pp.shutdown();
clear