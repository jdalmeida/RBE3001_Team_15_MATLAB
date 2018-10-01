function endPos = LivePlot3D(q, start, path, f)

%% Initialize the figure 
% Takes the joint positions in degrees, bool start and bool path and gives end efector position
pointCSV = 'pathPoints.csv';
constants;
if start
    axes1 = axes('Parent',figure);
    hold(axes1,'on');
    
    % Create xlabel
    xlabel('X');
    
    % Create zlabel
    zlabel('Z');
    
    % Create ylabel
    ylabel('Y');
    
    xlim(axes1,[-100 400]);
    ylim(axes1,[-250 250]);
    zlim(axes1,[-100 400]);
%     view(axes1,[-156.7 8.40000000000001]);
    view(axes1,[-180 0]);
    box(axes1,'on');
    grid(axes1,'on');
    
    set(axes1,'Color',[0.941176474094391 0.941176474094391 0.941176474094391]);
    disp("Initializing Plot")
    endPos = 0;
    
    if(exist(pointCSV, 'file') == 2)
        delete(pointCSV);
    end
elseif ~start
    %% Create Plot
    L1 = 135; L2 = 175; L3 = 169.28;
    
    T01 = DHSolver(0, -90, L1, -q(1));
    T12 = DHSolver(L2, 0, 0, -q(2));
    T23 = DHSolver(L3, 0, 0, -q(3) + 90);
    
    T02 = T01 * T12;
    T03 = T02 * T23;
    
    z = zeros(3, 1, 'single');
    p1 = T01(1:3,4);
    p2 = T02(1:3,4);
    p3 = T03(1:3,4);
    
    endPos = p3';
    
    framePos = [z p1 p2 p3];
    
    q = double(q);
    
    label = sprintf('Joint 1: %0.1f  \tJoint 2: %0.1f  \tJoint 3: %0.1f  \nPx: %0.1f  \tPy: %0.1f  \tPz: %0.1f  \nFx:%0.1f  \tFy:%0.1f  \tFz:%0.1f    \t|F|:%.01f',...
            q(1), q(2), q(3), endPos(1), endPos(2), endPos(3), f(1), f(2), f(3), norm(f));
    
    handleGetter=GraphSingleton();
    R = handleGetter.getHandle();
    P = handleGetter.getPathHandle();
    graphText = handleGetter.getGraphText();
    
    set(graphText, 'String', label);
    set(R.handle, 'xdata', framePos(1,:), 'ydata', framePos(2,:), 'zdata', framePos(3,:));
    drawnow();
    
    
    if exist('path', 'var') && path
        dlmwrite(pointCSV, endPos,'-append');
        pointplot = csvread(pointCSV);
        %set(P.handle, 'xdata', pointplot(:,1), 'ydata', pointplot(:,2), 'zdata', pointplot(:,3));
    end
end
end

