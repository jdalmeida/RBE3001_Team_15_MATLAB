init;
pp = PacketProcessor(myHIDSimplePacketComs);

LivePlot3D([0,0,0], true);
framePos = zeros(4,4,'single');
        R.handle = plot3(framePos(1,:), framePos(2,:), framePos(3,:),'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
            'Marker','diamond',...
            'LineWidth',2,...
            'Color',[0.635294139385223 0.0784313753247261 0.184313729405403]);
        
while 1 
    [pos, v, f]= GetStatus(pp);
    pos = TIC_TO_ANGLE * pos;
    LivePlot3D(pos, false, R);
    pause(.01);
end

pp.shutdown();
clear