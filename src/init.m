clear java;
%clear import;
clear classes;
vid = hex2dec('3742');
pid = hex2dec('0007');
disp (vid );
disp (pid);
javaaddpath ../lib/SimplePacketComsJavaFat-0.5.2.jar;
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

%pp = PacketProcessor(myHIDSimplePacketComs);
TIC_TO_ANGLE = 360.0/4096.0;

%Server ID Library
PID_ID = 37;                 %give robot a set point
PROTOCOL_ID = 36;            %receive status message
CALIBRATION_ID = 35;         %update home position


% initial reading to clear out zeros
%packet = zeros(15, 1, 'single');
%returnPacket = pp.command(CALIBRATION_ID , packet);
%pause(.1)
