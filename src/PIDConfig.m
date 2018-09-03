function PIDConfig(pp, j1pid, j2pid, j3pid)
     PIDCONFIG_ID = 65;
     
     try
         packet = zeros(15, 1, 'single');
         packet(1:3) = j1pid;
         packet(4:6) = j2pid;
         packet(7:9) = j3pid;
         
%          disp('PID Packet');
%          disp(packet');
         pp.command(PIDCONFIG_ID, packet);
    catch exception
        getReport(exception);
        disp('Exited on error, clean shutdown');
    end
end