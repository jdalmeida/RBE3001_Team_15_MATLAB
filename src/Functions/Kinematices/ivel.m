function [jVel] = ivel(q, tipVel)
%IVEL input joint position in degrees & tip velocity and returns joint velocites

Jacobian = jacob0(q);

Jinvertable = Jacobian(1:3, :);

% invJ = inv(Jinvertable);

jVel = Jinvertable \ tipVel;

end

