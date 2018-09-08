function LivePlot3D(q, start)
%% Initialize the figure
     if (start)
        figure1 = figure;
        axes1 = axes('Parent',figure1);
        hold(axes1,'on');

        % Create xlabel
        xlabel('X');

        % Create zlabel
        zlabel('Z');

        % Create ylabel
        ylabel('Y');

        xlim(axes1,[0 400]);
        ylim(axes1,[-200 200]);
        zlim(axes1,[0 400]);
        view(axes1,[-156.7 8.40000000000001]);
        box(axes1,'on');
        grid(axes1,'on');

        set(axes1,'Color',[0.941176474094391 0.941176474094391 0.941176474094391]);
        disp("Initializing Live Plot");
        
        framePos = zeros(4,4,'single');
        R.handle = plot3(framePos(1,:), framePos(2,:), framePos(3,:),'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
            'Marker','diamond',...
            'LineWidth',2,...
            'Color',[0.635294139385223 0.0784313753247261 0.184313729405403]);
            disp('Plotting');
     else 
%% Create Plot
        q0 = q(1); q1 = q(2); q2 = q(3);
        L1 = 135; L2 = 175; L3 = 169.28; 

        T01 = DHSolver(0, -90, L1, q0);
        T12 = DHSolver(L2, 0, 0, q1);
        T23 = DHSolver(L3, 0, 0, q2);

        T02 = T01 * T12;
        T03 = T02 * T23;

        z = zeros(3, 1, 'single');
        p01 = T01(1:3,4);
        p12 = T02(1:3,4);
        p23 = T03(1:3,4);

        framePos = [z p01 p12 p23];

        set(R.handle, 'xdata', framePos(1,:), 'ydata', framePos(2,:), 'zdata', framePos(3,:));
        drawnow();
     end
end

