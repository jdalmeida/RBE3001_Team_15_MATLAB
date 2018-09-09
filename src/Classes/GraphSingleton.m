
% classdef StoreData
%    methods (Static)
%       function out = setgetVar(data)
%          persistent Var;
%          if nargin
%             Var = data;
%          end
%          out = Var;
%       end
%    end
% end
%    if isempty(logTime)
%         logTime = currTime;
%         disp('Logging initial value.')
%         dlmwrite(fname,n)
%         return
%     end
classdef GraphSingleton
    properties
    end
    methods
        function obj = GraphSingleton()
        end
    end
    methods (Static)
        function out = getHandle()
            persistent R;
            if isempty(R)
                framePos = zeros(4,4,'single');        
                R.handle = plot3(framePos(1,:), framePos(2,:), framePos(3,:),'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
                    'Marker','diamond',...
                    'LineWidth',2,...
                    'Color',[0.635294139385223 0.0784313753247261 0.184313729405403]);
                out=R;
            else
                out=R;
            end
        end
    end
end

