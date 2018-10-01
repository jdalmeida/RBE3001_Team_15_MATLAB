init;
pp = PacketProcessor(myHIDSimplePacketComs);

LivePlot3D([0,0,0], true);

%% Vision inits

% Creates handlers to plot each of the colors
pblue.handle = scatter3(0,0,0, 'MarkerFaceColor',[0 0.749019622802734 0.749019622802734],...
    'MarkerEdgeColor',[0 0.749019622802734 0.749019622802734]);
pgreen.handle = scatter3(0,0,0,'MarkerFaceColor',[0.466666668653488 0.674509823322296 0.18823529779911],...
    'MarkerEdgeColor',[0.466666668653488 0.674509823322296 0.18823529779911]);
pyellow.handle = scatter3(0,0,0,'MarkerFaceColor',[1 0.843137264251709 0],...
    'MarkerEdgeColor',[1 0.843137264251709 0]);

% arrays for handlers and marker colors for each bulb
scatterHandles = [pblue, pgreen, pyellow];
% markerColors = ['-c', '-g', '-y'];

%% Beginning of Loop
while 1
UpdateStickModel;

%generates 3d-array for the centroids of the bulbs
centroids = FindCentroid();
fields = fieldnames(centroids);
disp('Looping through colors');
% Loop to iterate through each centroids point to generate the graph
for i=1:numel(fields)
    mYColor=centroids.(fields{i});
    if isempty(mYColor)
        continue;
    end
    
    [rows, ~] = size(mYColor);
    
    zPos = zeros(rows, 1, 'single');
    zPos=zPos-34.8;
    
    set(scatterHandles(i).handle, 'xdata', mYColor(:, 1)*10, 'ydata', mYColor(:, 2)*10,'zdata', zPos);
end
end
%% Trajectory Loop



pp.shutdown();