%% General Code Inits
init;
pp = PacketProcessor(myHIDSimplePacketComs);


LivePlot3D([0,0,0], true, false);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

ballInfo = zeros(3, 5, 'double');

%% Vision Inits
scale = 100;

% Creates handlers to plot each of the colors
pblue.handle = scatter3(0,0,0, scale, 'MarkerFaceColor',[0 0.749019622802734 0.749019622802734],...
    'MarkerEdgeColor',[0 0.749019622802734 0.749019622802734]);
pgreen.handle = scatter3(0,0,0, scale,'MarkerFaceColor',[0.466666668653488 0.674509823322296 0.18823529779911],...
    'MarkerEdgeColor',[0.466666668653488 0.674509823322296 0.18823529779911]);
pyellow.handle = scatter3(0,0,0, scale,'MarkerFaceColor',[1 0.843137264251709 0],...
    'MarkerEdgeColor',[1 0.843137264251709 0]);

% arrays for handlers and marker colors for each bulb
scatterHandles = [pblue, pgreen, pyellow];

Gripper(pp, OPEN);


%% Beginning of Loop
% while 1

UpdateStickModel;

%generates 3d-array for the centroids of the bulbs
centroids = FindCentroid();
fields = fieldnames(centroids);

% Loop to iterate through each centroids point to generate the graph
for i=1:numel(fields)
    myColor=centroids.(fields{i})*10;
    
    ballcolor = COLORS(i);
    
    if isempty(myColor)
        ballcolor = EMPTY;
        ballInfo(i, :) = [0,0,0, ballcolor, HEAVY];
        continue;
    end
    
    [rows, ~] = size(myColor);
    zPos = zeros(rows, 1, 'single');
    
    x = myColor(:, 1);
    y = myColor(:, 2);
    z = 0;
    
    set(scatterHandles(i).handle, 'xdata', x, 'ydata', y,'zdata', z);
    
    ballInfo(i, :) = [x, y, z, ballcolor, HEAVY];
end

%% Trajectory Loop
for i = 1:3
    % Get the ball info
    currBall = ballInfo(i, :);
    
    if currBall(4) == -1
        continue;
    end
    
    xBall = currBall(1);
    yBall = currBall(2);
    zBall = currBall(3);
    colorBall = currBall(4);
    weightBall = currBall(5);
    
    % Move to Work Position
    MoveToPointControl(pp, tWorkPos);
    UpdateStickModel;
    
    % Move to ball
    MoveToPointControl(pp, [xBall, yBall, tWorkPos(3)]);
    UpdateStickModel;
    
    MoveToPointControl(pp, [xBall, yBall, zBall]);
    Gripper(pp, CLOSE);
    pause(.5)
    UpdateStickModel;
    
    % Move to Work Position
    MoveToPointControl(pp, [xBall, yBall, tWorkPos(3)]);
    
    MoveToPointControl(pp, tWorkPos);
    UpdateStickModel;
    
    Gripper(pp, OPEN);
    pause(.5)
    % Weigh ball
    
    % Get dropoff ball
    
    % Drop off
    
    % waitforbuttonpress;
end




pp.shutdown();