%% This function should be called with angle measurements for each of
%The joints, it will then move the joints as such
function Setpoint(pp, joint1, joint2, joint3)
constants;
% tic;
% setpoint_csv = 'powered6.csv';
setpoint_csv = 'null.csv';
% if(exist(setpoint_csv, 'file') == 2)
%     delete(setpoint_csv);
% end

try
    packet = zeros(15, 1, 'single');
    packet(1) = ANGLE_TO_TIC * joint1;
    packet(4) = ANGLE_TO_TIC * joint2;
    packet(7) = ANGLE_TO_TIC * joint3;
    pp.write(PID_ID, packet);
    pause(0.003);
    returnPacket = pp.read(PID_ID);
    star = [];
    for i=1:150
        [pos, ~, ~]= GetStatus(pp);
        pos = TIC_TO_ANGLE * pos;
        endPos = LivePlot3D(pos, false);
        
        time = toc;
%         time_joint_pos = [time endPos pos];
        time_joint_pos = [time endPos];
        dlmwrite(setpoint_csv, time_joint_pos,'-append');
        
        pause(.01);
        %disp(endPos);
    end
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
end
