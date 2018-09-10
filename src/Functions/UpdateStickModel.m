% setpoint_csv = 'trajectory_8.csv';
% if(exist(setpoint_csv, 'file') == 2)
%     delete(setpoint_csv);
% end

[anglePos, ~, ~]= GetStatus(pp);
anglePos = TIC_TO_ANGLE * anglePos;
endPos = LivePlot3D(anglePos, false, true);

time = toc;
time_joint_pos = [time endPos anglePos];
% dlmwrite(setpoint_csv, time_joint_pos,'-append');