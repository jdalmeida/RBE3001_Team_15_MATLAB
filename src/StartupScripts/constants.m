%% Constants
TIC_TO_ANGLE = 360.0/4096.0;
ANGLE_TO_TIC = 4096.0/360.0;
TIC_TO_RAD=2*pi/4096;
RAD_TO_TIC=4096/2*pi;

%% Server ID Library
PID_ID = 37;                 % give robot a set point
PROTOCOL_ID = 36;            % receive status message
CALIBRATION_ID = 35;         % update home position
GRIPPER_ID = 34;             % send values to gripper servo
PIDCONFIG_ID = 65;           % update pid values for each joint

%% Joint Limits in degrees
% cols = min max
% rows = joint
jointlimits = [-90 90; -20 120; -40 230];

%% Gripper Position Constants
OPEN=1;
CLOSE=.1;

%% Ball Info

%Colors
BLUE = 1;
GREEN = 2;
YELLOW = 3;
EMPTY = -1;

COLORS = [BLUE, GREEN, YELLOW];

%Weights
LIGHT = 0;
HEAVY = 3;

YBOUND = 160;
XBOUND = 300;

%Drop Off 
% light blue, green, yellow
% heavy, blue, green, yellow
% Pokeballs = [54, 220, -10;
%     131, 217, -16;
%     173, 206, -13];
Pokeballs = [36, 220, 22;
    120, 200, 23;
    210, 210, 23;
    36, -220, 22;
    120, -200, 23;
    210, -210, 23];

jWorkPos = [0, 40, -25];
tWorkPos = fwkin(jWorkPos(1), jWorkPos(2), jWorkPos(3));

jweighPoints = [0, 10, -30;
                0, 90, -30;
                0, 90, 0];

twp1 = fwkin(jweighPoints(1, 1), jweighPoints(1, 2), jweighPoints(1, 3));
twp2 = fwkin(jweighPoints(2, 1), jweighPoints(2, 2), jweighPoints(2, 3));
twp3 = fwkin(jweighPoints(3, 1), jweighPoints(3, 2), jweighPoints(3, 3));

weighPoints=[90.36, 0, -11.6008;
             146, 0, 225.36;
             169, 0, 310];
         
