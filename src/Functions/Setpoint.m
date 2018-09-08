%% This function should be called with angle measurements for each of
    %The joints, it will then move the joints as such
function Setpoint(pp, joint1, joint2, joint3)
    constants;
    
    tic;
    setpoint_csv = 'null.csv';
    if(exist(setpoint_csv, 'file') == 2)
      delete(setpoint_csv);
    end
    
    try 
       packet = zeros(15, 1, 'single');
       packet(1) = ANGLE_TO_TIC * joint1;
       packet(4) = ANGLE_TO_TIC * joint2;
       packet(7) = ANGLE_TO_TIC * joint3;

       retPack =pp.command(PID_ID, packet); %send packet

%        for i=1:150
%            pos = GetStatus(pp);
%            pos = TIC_TO_ANGLE * pos;
%            pos(4) = toc;
%            dlmwrite(setpoint_csv,pos,'-append');
%            disp(pos);
%        end
    catch exception
        getReport(exception)
        disp('Exited on error, clean shutdown');
    end
end
