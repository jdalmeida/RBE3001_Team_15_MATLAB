

clc;
init;
TIC_TO_ANGLE = 360.0/4096.0;

packet = zeros(15, 1, 'single');
pp = PacketProcessor(myHIDSimplePacketComs);
returnPacket = pp.command(PROTOCOL_ID , packet
%% Plot Settings
% Create figure
figure1 = figure('Name','Joint Angle Live Plot');

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create line
line1 = line(0,0,'Parent',axes1,'DisplayName','Joint 1','Color',[1 0 0]);

% Create line
line2 = line(0,0,'Parent',axes1,'DisplayName','Joint 2','Color',[0 0 1]);

% Create line
line3 = line(0,0,'Parent',axes1,'DisplayName','Joint 3','Color',[0 1 0]);

% Create xlabel
xlabel('Time (s)');

% Create ylabel
ylabel('Angle (deg)');

% Create legend
legend(axes1,'show');

% line1 = line(time, 0,'Color', 'r');  %handle for joint 1
% line2 = line(time, 0,'Color', 'b');  %handle for joint 2
% line3 = line(time, 0,'Color', 'g');  %handle for joint 3
axis([0 inf -180 180]); 

%% Live Plot
tic;
time = 0;

% while 1   % for actual live graphing
for i=1:100
    %run to get packet data
    % Send packet to the server and get the response
    returnPacket = pp.command(PROTOCOL_ID , packet);
    pause(.1);
    transpose = returnPacket';
    pos = TIC_TO_ANGLE * transpose([1,4,7]);
    pos(4) = toc;
    time = pos(4);
    
    line1.XData = [line1.XData time];
    line1.YData = [line1.YData pos(1)];
    line2.XData = [line2.XData time];
    line2.YData = [line2.YData pos(2)];
    line3.XData = [line3.XData time];
    line3.YData = [line3.YData pos(3)];
end
pp.shutdown();




