init;

try
  %% This is the averaging portion of the calibration  
  total=zeros(1,3,'single'); %empty vector to hold running total of calibrations
  firstpacket=zeros(15,1,'single');
  secondpacket=zeros(15,1,'single');
  count = 10;
  for i = 1:count
      % Send packet to the server and get the response
      returnPacket = pp.command(PROTOCOL_ID, firstpacket);
      transposed = returnPacket';
      position = transposed([1,4,7]);
      disp(position);  
      total = total + position;
  end
  %THIS LINE IS IMPORTANT TO MAKE SURE THAT THE SERVER SHUTS DOWN
  pp.shutdown(); %its possible this line causes the server to not function 
                %for the rest of the session
  pause(.2);
  %THIS WAIT MAKES SURE THE SERVER HAS THE TIME TO SHUTDOWN
  avg = (1.0/count) * total;
  
  %% This pushes the averages to the robot
  disp("Average:");
  disp(avg);
  secondpacket(1) = avg(1);
  secondpacket(2) = avg(2);
  secondpacket(3) = avg(3);
  pp=PacketProcessor(myHIDSimplePacketComs);
  pp.command(CALIBRATION_ID, secondpacket);
  disp(secondpacket);  
  
catch exception
    getReport(exception);
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown();

%% This is a test region to try to show live updates of the code
%TODO figure out why the encoder values don't get updated here
pause(1);
pp=PacketProcessor(myHIDSimplePacketComs);
thirdpacket=zeros(15,1,'single');
while(1)
    returnPacket = pp.command(PROTOCOL_ID, thirdpacket);
    finalvals=thirdpacket';
    dispvals=finalvals([1,4,7]);
    disp(dispvals);
    pause(.1);
end
