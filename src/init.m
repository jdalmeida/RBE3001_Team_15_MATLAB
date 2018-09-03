clear
clear java;
%clear import;
clear classes;
vid = hex2dec('3742');
pid = hex2dec('0007');
disp (vid );
disp (pid);
javaaddpath ../lib/SimplePacketComsJavaFat-0.6.2.jar;
import edu.wpi.SimplePacketComs.*;
import edu.wpi.SimplePacketComs.device.*;
import edu.wpi.SimplePacketComs.phy.*;
import java.util.*;
import org.hid4java.*;
version -java;
myHIDSimplePacketComs=HIDfactory.get();PacketProcessor(myHIDSimplePacketComs);
myHIDSimplePacketComs.setPid(pid);
myHIDSimplePacketComs.setVid(vid);
myHIDSimplePacketComs.connect();

% Constants
TIC_TO_ANGLE = 360.0/4096.0;
ANGLE_TO_TIC = 4096.0/360.0;

% Server ID Library
PID_ID = 37;                 % give robot a set point
PROTOCOL_ID = 36;            % receive status message
CALIBRATION_ID = 35;         % update home position
PIDCONFIG_ID = 65;           % update pid values for each joint