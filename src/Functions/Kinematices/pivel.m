function [jVel] = pivel(q, tipVel)
%PIVEL input joint position in degrees & tip velocity and returns joint velocites

Jacobian = jacob0(q);

invJ = pinv(Jacobian);

jVel = invJ * [tipVel; 0; 0; 0];

end

