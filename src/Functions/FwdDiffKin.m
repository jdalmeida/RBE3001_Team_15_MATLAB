function [tipVel] = FwdDiffKin(q, vel)
%FWDDIFFKIN take as arguments the vector of current
% joint variables 𝒒𝒒 and the vector of instantaneous joint velocities 𝒒𝒒̇, and will return the vector of taskspace
% velocities 𝒑𝒑̇. 

vel = vel';

tipVel = jacob0(q) * vel;

end

