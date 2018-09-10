
% setpoint_csv = 'powered6.csv';
setpoint_csv = 'trajectory_8.csv';
% if(exist(setpoint_csv, 'file') == 2)
%     delete(setpoint_csv);
% end

[pos, ~, ~]= GetStatus(pp);
pos = TIC_TO_ANGLE * pos;
endPos = LivePlot3D(pos, false, true);

time = toc;
time_joint_pos = [time endPos];
dlmwrite(setpoint_csv, time_joint_pos,'-append');