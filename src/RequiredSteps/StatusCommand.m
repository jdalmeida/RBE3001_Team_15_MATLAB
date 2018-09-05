init;
% Create a PacketProcessor object to send data to the nucleo firmware

%% sends 0s to the neucleo and recieves the position, velocity and accleration data from the joints
try
  DEBUG   = true;          % enables/disables debug prints
  pp = PacketProcessor(myHIDSimplePacketComs);
  
  packet = zeros(15, 1, 'single');
  returnPacket = pp.command(PROTOCOL_ID , packet);
  pause(.1);
  
  returnPacket = pp.command(PROTOCOL_ID , packet);
  disp('Received Packet:');
  t = returnPacket';
  r = TIC_TO_ANGLE * t;
  disp(r([1,4,7]));
  
catch exception
    getReport(exception);
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown();
clear