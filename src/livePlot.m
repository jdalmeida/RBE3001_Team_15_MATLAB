init;

% plot stuff
plotTitle = 'Joint Angle';  % plot title
xLabel = 'Elapsed Time (s)';     % x-axis label
yLabel = 'Angle (deg)';      % y-axis label
legend1 = 'Joint 1'
legend2 = 'Joint 2'
legend3 = 'Joint 3'
title(plotTitle,'FontSize',15);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
legend(legend1,legend2,legend3)

%initialize plot
time = 0;
ax = axes();
hold on;
line1 = line(time, pos(1));  %handle for line 1
line2 = line(time, pos(2));  %handle for line 2
line3 = line(time, pos(3));
axis([0 inf 0 360]) %Chose those y-axis values because in normal conditions, temp is aprox 22ºC

tic;
while 1
    %run to get packet data
    statusCommand;
    transpose = returnPacket';
    pos = transpose([1,4,7]);
    pos(4) = toc;
    time = pos(4);
    
    line1.XData = [line1.XData time];
    line1.YData = [line1.YData pos(1)];
    line2.XData = [line2.XData time];
    line2.YData = [line2.YData pos(2)];
    line3.XData = [line3.XData time];
    line3.YData = [line3.YData pos(3)];
    
end




