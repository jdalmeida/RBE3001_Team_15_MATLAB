init;
% Create a PacketProcessor object to send data to the nucleo firmware

try
  DEBUG   = true;          % enables/disables debug prints
  
  % Instantiate a packet - the following instruction allocates 64
  % bytes for this purpose. Recall that the HID interface supports
  % packet sizes up to 64 bytes.
  packet = zeros(15, 1, 'single');

  % Send packet to the server and get the response
  returnPacket = pp.command(PROTOCOL_ID , packet);
  
  disp('Received Packet:');
  disp(returnPacket');
  
catch exception
    getReport(exception);
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown();
