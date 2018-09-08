function [DH] = DHSolver(a, alp, d, q)
     DH = [cosd(q), -sind(q)*cosd(alp), sind(q)*sind(alp), a*cosd(q);
     sind(q), cosd(q)*cosd(alp), -cosd(q)*sind(alp), a*sind(q);
     0, sind(alp), cosd(alp), d;
     0, 0, 0, 1];
end