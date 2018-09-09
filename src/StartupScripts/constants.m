
%% Constants
TIC_TO_ANGLE = 360.0/4096.0;
ANGLE_TO_TIC = 4096.0/360.0;

%% Server ID Library
PID_ID = 37;                 % give robot a set point
PROTOCOL_ID = 36;            % receive status message
CALIBRATION_ID = 35;         % update home position
PIDCONFIG_ID = 65;           % update pid values for each joint
%% Function Variable for Live 3D Plotting
% framePos = zeros(4,4,'single');
% 
%     
% R.handle = plot3(framePos(1,:), framePos(2,:), framePos(3,:),'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
%     'Marker','diamond',...
%     'LineWidth',2,...
%     'Color',[0.635294139385223 0.0784313753247261 0.184313729405403]);
disp("creating fig");

