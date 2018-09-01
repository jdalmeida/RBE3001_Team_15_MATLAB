init;

try
    
  total=zeros(1,3,'single'); %empty vector to hold running total of calibrations
  
  count = 10;
  for i = 1:count
      % Send packet to the server and get the response
      returnPacket = pp.command(PROTOCOL_ID, packet);
      transpose = returnPacket';
      position = transpose([1,4,7]);
            
      total = total + position;
      pause(.1)
  end
  
  avg = (1.0/count) * total;
  disp("Average:");
  disp(avg);
  
  packet = zeros(15, 1, 'single');
  packet(1) = avg(1);
  packet(4) = avg(2);
  packet(7) = avg(3);
  
%   pp.command(CALIBRATION_ID, packet);
  
catch exception
    getReport(exception);
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown();
