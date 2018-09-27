function [instVel] = fwVel(q, vel)
%FWVEL Inputs are joint positions and joints velocities. Outputs the 6x1 instantaneous tip velocity matrix (mm/sec)

Jacobian = jacob0(q);
vel = vel';

instVel = Jacobian * vel;
end

