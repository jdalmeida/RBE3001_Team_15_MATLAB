[pos, ~, torq]= GetStatus(pp);

pos = TIC_TO_ANGLE * pos;
actualTorque=RawToTorque(torq);

tipForce=statics3001(pos, actualTorque);

LivePlot3D(pos, false, true, tipForce);
% 
% time = toc;
% time_joint_pos = [time tipPos anglePos];