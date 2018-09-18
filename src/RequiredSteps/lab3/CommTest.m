%% initial setup
init;
pp= PacketProcessor(myHIDSimplePacketComs);
packet =zeros(15,1,'single');
commTestCsv = 'null.csv';
%% This actually runs the test
if(exist(commTestCsv, 'file') == 2)
      delete(commTestCsv);
end
for i= 1:500
    tic;
    pp.write(PROTOCOL_ID, packet);
%     pause(0.003);
    returnPacket = pp.read(PROTOCOL_ID);
    curTime=toc;
    dlmwrite(commTestCsv,[curTime returnPacket'],'-append');
end
pp.shutdown();
clear