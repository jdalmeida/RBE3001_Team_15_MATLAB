[anglePos, ~, ~]= GetStatus(pp);
anglePos = TIC_TO_ANGLE * anglePos;
endPos = LivePlot3D(anglePos, false, true);

time = toc;
time_joint_pos = [time endPos anglePos];