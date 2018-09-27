%% Constants
TIC_TO_ANGLE = 360.0/4096.0;
ANGLE_TO_TIC = 4096.0/360.0;
TIC_TO_RAD=2*pi/4096;
RAD_TO_TIC=4096/2*pi;

%% Server ID Library
PID_ID = 37;                 % give robot a set point
PROTOCOL_ID = 36;            % receive status message
CALIBRATION_ID = 35;         % update home position
PIDCONFIG_ID = 65;           % update pid values for each joint

%% Joint Limits in degrees
% cols = min max
% rows = joint
jointlimits = [-60 60; -4 106; -34 200];
