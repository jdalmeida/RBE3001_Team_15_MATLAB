%%
% RBE3001 - Laboratory 1 
% 
% Instructions
% ------------
% Welcome again! This MATLAB script is your starting point for Lab
% 1 of RBE3001. The sample code below demonstrates how to establish
% communication between this script and the Nucleo firmware, send
% setpoint commands and receive sensor data.
% 
% IMPORTANT - understanding the code below requires being familiar
% with the Nucleo firmware. Read that code first.
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
myHIDSimplePacketComs=HIDfactory.get();
myHIDSimplePacketComs.setPid(pid);
myHIDSimplePacketComs.setVid(vid);
myHIDSimplePacketComs.connect();
% Create a PacketProcessor object to send data to the nucleo firmware

pp = PacketProcessor(myHIDSimplePacketComs);
file='calibrations.csv';
calibrationCount=100;
try
  SERV_ID = 36;            % we will be talking to server ID 37 on
                           % the Nucleo

  DEBUG   = true;          % enables/disables debug prints
  
  %Runs the first time to get rid of the all zeros issue
  packet = zeros(15, 1, 'single');
  runningAverage=zeros(1,3,'single');
  % Send packet to the server and get the response
  returnPacket = pp.command(SERV_ID, packet);
  pause(.5);
  fclose(fopen(file, 'w'));
  for i=1:calibrationCount
      % Instantiate a packet - the following instruction allocates 64
      % bytes for this purpose. Recall that the HID interface supports
      % packet sizes up to 64 bytes.
      packet = zeros(15, 1, 'single');

      % Send packet to the server and get the response
      returnPacket = pp.command(SERV_ID, packet);
      r = returnPacket';

      disp('Received Packet:');
      disp(r([1, 4, 7]));
      runningAverage=runningAverage+r([1,4,7]);
      dlmwrite(file,r([1,4,7]),'-append');
  end
  runningAverage=runningAverage/calibrationCount
   dlmwrite(file,runningAverage,'-append');
catch exception
    getReport(exception);
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown();