function LivePlot(pp, j1, j2, j3)
    TIC_TO_ANGLE = 360.0/4096.0;
    ANGLE_TO_TIC = 4096.0/360.0;
    PROTOCOL_ID = 36;
    
    setpoint = [j1, j2, j3];
    
    packet = zeros(15, 1, 'single');
    pp.command(PROTOCOL_ID , packet);
    
    
    %% Plot Settings
    % Create figure
    figure1 = figure('Name','Joint Angle Live Plot');

    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');

    % Create line
    line1 = line(0,0,'Parent',axes1,'DisplayName','Joint 1','MarkerSize',2,...
        'Marker','diamond',...
        'Color',[1 0 0]);
    % Create line
    line2 = line(0,0,'Parent',axes1,'DisplayName','Joint 2','MarkerSize',2,...
        'Marker','diamond',...
        'Color',[0 0 1]);

    % Create line
    line3 = line(0,0,'Parent',axes1,'DisplayName','Joint 3','MarkerSize',2,...
        'Marker','diamond',...
        'Color',[0 1 0]);

    % Create xlabel
    xlabel('Time (s)');

    % Create ylabel
    ylabel('Angle (deg)');

    % Create legend
    legend(axes1,'show');

    axis([0 inf -180 180]); 
    tic;
    
    pos = zeros(1,3,'single');
    
%     while ((abs(setpoint - pos) > 2))
    for i = 1:100
        returnPacket = pp.command(PROTOCOL_ID , packet);

        transpose = returnPacket';
        pos = TIC_TO_ANGLE * transpose([1,4,7]);
    
        time = toc;
        post= [pos time];

        line1.XData = [line1.XData time];
        line1.YData = [line1.YData post(1)];
        line2.XData = [line2.XData time];
        line2.YData = [line2.YData post(2)];
        line3.XData = [line3.XData time];
        line3.YData = [line3.YData post(3)];

        pause(.1);
    end
end

