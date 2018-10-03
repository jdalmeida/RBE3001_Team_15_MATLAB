%% This class is used to store a static reference to the plot
classdef GraphSingleton
    %Properties is empty because the static in matlab is called
    %persistent and can only be done in a function
    properties
    end
    methods
        %This is the constructor so any script can get an instance of the
        %class. This instance will be unique
        function obj = GraphSingleton()
        end
    end
    %Static means this is the same function across every instance of the
    %class
    methods (Static)
        function out = getHandle()
            %This is the actual data that needs to persistent across every
            %instance of the class
            persistent R;
            %When its empty populate it once and only once then return a
            %reference to it
            if isempty(R)
                framePos = zeros(4,4,'single');
                R.handle = plot3(framePos(1,:), framePos(2,:), framePos(3,:),'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
                    'Marker','diamond',...
                    'LineWidth',3,...
                    'Color',[0.635294139385223 0.0784313753247261 0.184313729405403]);
                out=R;
            else
                out=R;
            end
        end
        function out = getPathHandle()
            persistent P;
            if isempty(P)
                pointplot = [0,0,0];
                P.handle = plot3(pointplot(:,1), pointplot(:,2), pointplot(:,3), 'MarkerFaceColor',[0 0.447058826684952 0.74117648601532],...
                    'MarkerEdgeColor',[0 0.447058826684952 0.74117648601532],...
                    'MarkerSize',0.5,...
                    'LineWidth',2,...
                    'LineStyle',':',...
                    'Color',[0 0.447058826684952 0.74117648601532]);
                out = P;
            else
                out = P;
            end
        end
        function out = getVelArrowHandle()
            persistent quiver;
            if isempty(quiver)
                quiver.handle = quiver3(0,0,0,0,0,0, ...
                    'MarkerFaceColor',[0 0 0],...
                    'MarkerEdgeColor',[0 0 0],...
                    'LineWidth',2,...
                    'AutoScaleFactor', 1,...
                    'MaxHeadSize', .5);
                out = quiver;
            else
                out = quiver;
            end
        end
        function out = getGraphText()
            persistent posText;
            if isempty(posText)
                posText = text(215, 64, 382.7, '');
                out = posText;
            else
                out= posText;
            end
        end
        function out = getBallsHandle()
            persistent scatterHandles;
            if isempty(scatterHandles)
                scale = 100;
                pblue.handle = scatter3(0,0,0, scale, 'MarkerFaceColor',[0 0.749019622802734 0.749019622802734],...
                    'MarkerEdgeColor',[0 0.749019622802734 0.749019622802734]);
                pgreen.handle = scatter3(0,0,0, scale,'MarkerFaceColor',[0.466666668653488 0.674509823322296 0.18823529779911],...
                    'MarkerEdgeColor',[0.466666668653488 0.674509823322296 0.18823529779911]);
                pyellow.handle = scatter3(0,0,0, scale,'MarkerFaceColor',[1 0.843137264251709 0],...
                    'MarkerEdgeColor',[1 0.843137264251709 0]);
                scatterHandles = [pblue, pgreen, pyellow];
                out = scatterHandles;
            else
                out= scatterHandles;
            end
        end
    end
end

