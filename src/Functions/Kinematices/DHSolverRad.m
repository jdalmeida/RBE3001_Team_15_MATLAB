function [DH] = DHSolverRad(a, alp, d, q)
DH = [cos(q), -sin(q)*cos(alp), sin(q)*sin(alp), a*cos(q);
    sin(q), cos(q)*cos(alp), -cos(q)*sin(alp), a*sin(q);
    0, sin(alp), cos(alp), d;
    0, 0, 0, 1];
end