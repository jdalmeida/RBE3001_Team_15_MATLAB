clear

% Declare symbolic varibles
syms A B C q1 q2 q3 pi
symVariables = [A, B, C, q1, q2, q3, pi];

link1=  [0  -pi/2 A -q1];
link2 = [B  0  0 -q2];
link3 = [C  0  0 -q3 + pi/2];

% DH params from the hw
% link1=  [0  pi/2 A q1 + pi/2];
% link2 = [B  0  0 q2];
% link3 = [C  0  0 q3];

T01 = DHSolverRad(link1(1), link1(2), link1(3), link1(4));
T12 = DHSolverRad(link2(1), link2(2), link2(3), link2(4));
T23 = DHSolverRad(link3(1), link3(2), link3(3), link3(4));

T02 = T01 * T12;
T03 = T01 * T12 * T23;
T03 = simplify(T03);

pos = T03(1:3, 4);

ang_col_1 = [0; 0; 1];
ang_col_2 = T01(1:3, 3);
ang_col_3 = T02(1:3, 3);
ang_J = [ang_col_1, ang_col_2, ang_col_3];

% get partial derivatives
col1 = simplify(diff(pos, q1));
col2 = simplify(diff(pos, q2));
col3 = simplify(diff(pos, q3));

posJ = [col1, col2, col3];

Jac = [posJ; ang_J];

disp(Jac);

