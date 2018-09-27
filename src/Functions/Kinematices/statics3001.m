function [tipForce] = statics3001(q, jtorq)
%STATICS3001 inputs joint position and joint torque (as a row vector) and outputs force at
%the tip

Jac = jacob0(q);

topJac = Jac(1:3, :)';

tipForce = topJac \ jtorq';

end

