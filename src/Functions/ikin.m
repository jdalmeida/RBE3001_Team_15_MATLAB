function [q] = ikin(pos)
constants;

L1 = 135;
L2 = 175;
L3 = 169.28;

px = pos(1);
py = pos(2);
pz = pos(3);

% 3rd leg of the triangle formed with joint 2 and joint 3
L4 = sqrt((pz-L1)^2 + px^2 + py^2);

% Solve for theta 1
theta1 = atan2d(py, px);

% Solve for theta 2
alpha = atan2d(pz-L1, sqrt(px^2+py^2));
beta = acosd((L2^2 + L4^2 - L3^2)/(2*L2*L4));

theta2 = alpha + beta;

%Solve for theta 3
theta3 = acosd((L2^2 + L3^2 - L4^2)/(2*L2*L3)) - 90;

% Outputs
q = [theta1, theta2, theta3];


for i = 1:size(q)
    
% If any angles are returned as imaginary, they are out of the range
if ~isreal(q)
    error("Resultant angle values are outside the bounds");
end

% To fill in with numbers for mechanical bounds
if 0
    error("Angle is outside of the bounds of the arm");
end

end



end
