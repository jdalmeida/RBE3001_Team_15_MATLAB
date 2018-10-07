function [numJac] = jacob0(q)
% jacob0(q) input is robot configuration (q in deg) (i.e. all of the current joint
% angles) and returns the corresponding numeric 6x3 Jacobian matrix

A = 135;
B = 175;
C = 169.28;


q1 = q(1);
q2 = q(2);
q3 = q(3);

numJac = [-sind(q1)*(C*sind(q2 + q3) + B*cosd(q2)),  cosd(q1)*(C*cosd(q2 + q3) - B*sind(q2)),  C*cosd(q2 + q3)*cosd(q1);
 -cosd(q1)*(C*sind(q2 + q3) + B*cosd(q2)), -sind(q1)*(C*cosd(q2 + q3) - B*sind(q2)), -C*cosd(q2 + q3)*sind(q1);
                                     0,            C*sind(q2 + q3) + B*cosd(q2),          C*sind(q2 + q3);
                                     0,                               sind(q1),                 sind(q1);
                                     0,                               cosd(q1),                 cosd(q1);
                                     1,                                     0,                       0];

end