%% Sets the pid values for each of the joints to the "arrays" passed in
function PIDConfig(pp, j1pid, j2pid, j3pid)
     PIDCONFIG_ID = 65;
     
     %% sets joint1, joint2 and joint3 pid respectively to j1, j2 and j3
     try
         packet = zeros(15, 1, 'single');
         packet(1:3) = j1pid;
         packet(4:6) = j2pid;
         packet(7:9) = j3pid;
         pp.command(PIDCONFIG_ID, packet);
    catch exception
        getReport(exception);
        disp('Exited on error, clean shutdown');
    end
end