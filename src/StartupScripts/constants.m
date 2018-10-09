%% Constants
TIC_TO_ANGLE = 360.0/4096.0;
ANGLE_TO_TIC = 4096.0/360.0;
TIC_TO_RAD=2*pi/4096;
RAD_TO_TIC=4096/2*pi;

OPEN = 1;
%% Server ID Library

global PID_ID
PID_ID = 37;                 % give robot a set point
global PROTOCOL_ID

PROTOCOL_ID = 36;            % receive status message
CALIBRATION_ID = 35;         % update home position

global GRIPPER_ID
GRIPPER_ID = 34;             % send values to gripper servo

PIDCONFIG_ID = 65;           % update pid values for each joint

%% Joint Limits in degrees
% cols = min max
% rows = joint
global jointlimits
jointlimits = [-90 90; -20 120; -40 230];

%% Ball Info

%Colors
BLUE = 1;
GREEN = 2;
YELLOW = 3;
EMPTY = -1;

COLORS = [1, 2, 3];

%Weights
LIGHT = 0;
HEAVY = 3;

YBOUND = 200;
XBOUND = 320;

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

Pokemon = ["Squirtle", "Bulbasaur", "Pikachu"];

jWorkPos = [0, 40, -25];
tWorkPos = [177.8707, 0, 83.9759];

jweighPoints = [0, 30, -30;
                0, 90, -30;
                0, 90, 0];

weighPoints=[90.36, 0, -11.6008;
             146, 0, 225.36;
             169, 0, 310];
         
