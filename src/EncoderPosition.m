init;
constants;
% Create a PacketProcessor object to send data to the nucleo firmware
pos_csv='null.csv';
try
  if(exist(pos_csv, 'file') == 2)
      delete(pos_csv);
  end
  DEBUG   = true;          % enables/disables debug prints
  pp = PacketProcessor(myHIDSimplePacketComs);
  % Instantiate a packet - the following instruction allocates 64
  % bytes for this purpose. Recall that the HID interface supports
  % packet sizes up to 64 bytes.
  packet = zeros(15, 1, 'single');
  returnPacket = pp.command(PROTOCOL_ID , packet);
for i=0:50
  % Send packet to the server and get the response
  returnPacket = pp.command(PROTOCOL_ID , packet);
  disp('Received Packet:');
  final_vals=returnPacket([1,4,7]);
  dlmwrite(pos_csv,final_vals','-append');
  disp(final_vals');
  pause(.5);
end
catch exception
    getReport(exception);
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown();