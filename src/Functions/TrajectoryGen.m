function [out] = TrajectoryGen(t0, tf, q0, qf, v0, vf)
% Matrix of the final and initial t values
t = [1, t0, t0^2, t0^3;...
    0, 1, 2*t0, 3*t0^2;...
    1, tf, tf^2, tf^3;...
    0, 1, 2*tf, 3*tf^2];

% Initial and Final positions and velocities
posVel = [q0; v0; qf; vf];

% Solve for the coeffcients
a = posVel/t;

% Flip the coefficients for the output
out = a';
end

