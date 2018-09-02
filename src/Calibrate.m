init;

try
  %% This is the averaging portion of the calibration  
   pp = PacketProcessor(myHIDSimplePacketComs);
  total=zeros(1,3,'single'); %empty vector to hold running total of calibrations
  firstpacket=zeros(15,1,'single');
  returnPacket = pp.command(CALIBRATION_ID, firstpacket);
  pause(.1);
  count = 10;
  disp("getting averages: ");
  for i = 1:count
      % Send packet to the server and get the response
      returnPacket = pp.command(CALIBRATION_ID, firstpacket);
      transposed = returnPacket';
      position = transposed([1,4,7]);
      disp(position);  
      total = total + position;
      pause(.1);
  end
  avg = (1.0/count) * total;
  
  %% This pushes the averages to the robot
  disp("Average:");
  disp(avg);
  firstpacket(1) = avg(1);
  firstpacket(2) = avg(2);
  firstpacket(3) = avg(3);
  pp.command(CALIBRATION_ID, firstpacket);
  disp(firstpacket);  


% Clear up memory upon termination

%% This is a test region to try to show live updates of the code
%NOTE: there is something where if you reset the array just before
    %getting a packet it can cause issues
 firstpacket=zeros(15,1,'single');
 pause(1);
for i=0:10
    %send zeros to get just the encoder values
    returnPacket = pp.command(CALIBRATION_ID, firstpacket);
    finalvals=returnPacket';
    dispvals=finalvals([1,4,7]);
    disp(dispvals);
    pause(.1);
end
pp.shutdown();
catch exception
    getReport(exception);
    disp('Exited on error, clean shutdown');
end