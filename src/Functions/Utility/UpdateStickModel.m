[anglePos, ~, ~]= GetStatus(pp);
anglePos = TIC_TO_ANGLE * anglePos;
tipPos = LivePlot3D(anglePos, false, true);

time = toc;
time_joint_pos = [time tipPos anglePos];