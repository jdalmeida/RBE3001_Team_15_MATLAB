%% This function should be called with angle measurements for each of
    %The joints, it will then move the joints as such
function Setpoint(pp, joint1, joint2, joint3)
    TIC_TO_ANGLE = 360.0/4096.0;
    ANGLE_TO_TIC = 4096.0/360.0;
    PID_ID = 37;
    
    tic;
    setpoint_csv = '15_pos4.csv';
    if(exist(setpoint_csv, 'file') == 2)
      delete(setpoint_csv);
    end
    
    try 
       packet = zeros(15, 1, 'single');
       packet(1) = ANGLE_TO_TIC * joint1;
       packet(4) = ANGLE_TO_TIC * joint2;
       packet(7) = ANGLE_TO_TIC * joint3;

       pp.command(PID_ID, packet); %send packet

       for i=1:150
           pos = getStatus(pp);
           pos = TIC_TO_ANGLE * pos;
           pos(4) = toc;
           dlmwrite(setpoint_csv,pos,'-append');
%            disp(pos);
       end
    catch exception
        getReport(exception)
        disp('Exited on error, clean shutdown');
    end
end






    