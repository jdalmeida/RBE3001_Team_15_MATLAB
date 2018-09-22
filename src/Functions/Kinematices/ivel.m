function [jVel] = ivel(q, tipVel)
%IVEL input tip velocity and returns joint velocites

Jacobian = jacob0(q);

Jinvertable = Jacobian(1:3, :);

invJ = inv(Jinvertable);

jVel = invJ * tipVel;

end

