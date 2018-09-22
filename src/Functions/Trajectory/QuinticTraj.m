function position= QuinticTraj(t, conds)
%% QuinticTraj This takes the intial and final time, position, velocity and acceleration
    %q0 is init position OR angle
t0 = conds(1);
tf = conds(2);
q0 = conds(3);
qf = conds(4);
v0 = conds(5);
vf = conds(6);
a0 = conds(7);
af = conds(8);

%Pregenerated symbolic matrix of the coefficients for the given conditions
A=[-(2*q0*tf^5 - 2*qf*t0^5 - 10*q0*t0*tf^4 + 10*qf*t0^4*tf - 2*t0*tf^5*v0 + 2*t0^5*tf*vf + a0*t0^2*tf^5 - 2*a0*t0^3*tf^4 + a0*t0^4*tf^3 - af*t0^3*tf^4 + 2*af*t0^4*tf^3 - af*t0^5*tf^2 + 20*q0*t0^2*tf^3 - 20*qf*t0^3*tf^2 + 10*t0^2*tf^4*v0 - 8*t0^3*tf^3*v0 + 8*t0^3*tf^3*vf - 10*t0^4*tf^2*vf)/(2*(t0 - tf)^2*(t0^3 - 3*t0^2*tf + 3*t0*tf^2 - tf^3));
    (2*t0^5*vf - 2*tf^5*v0 + 2*a0*t0*tf^5 - 2*af*t0^5*tf + 10*t0*tf^4*v0 - 10*t0^4*tf*vf - a0*t0^2*tf^4 - 4*a0*t0^3*tf^3 + 3*a0*t0^4*tf^2 - 3*af*t0^2*tf^4 + 4*af*t0^3*tf^3 + af*t0^4*tf^2 + 60*q0*t0^2*tf^2 - 60*qf*t0^2*tf^2 + 16*t0^2*tf^3*v0 - 24*t0^3*tf^2*v0 + 24*t0^2*tf^3*vf - 16*t0^3*tf^2*vf)/(2*(t0 - tf)^2*(t0^3 - 3*t0^2*tf + 3*t0*tf^2 - tf^3));
    -(a0*tf^5 - af*t0^5 + 4*a0*t0*tf^4 + 3*a0*t0^4*tf - 3*af*t0*tf^4 - 4*af*t0^4*tf + 60*q0*t0*tf^2 + 60*q0*t0^2*tf - 60*qf*t0*tf^2 - 60*qf*t0^2*tf + 36*t0*tf^3*v0 - 24*t0^3*tf*v0 + 24*t0*tf^3*vf - 36*t0^3*tf*vf - 8*a0*t0^2*tf^3 + 8*af*t0^3*tf^2 - 12*t0^2*tf^2*v0 + 12*t0^2*tf^2*vf)/(2*(t0 - tf)^2*(t0^3 - 3*t0^2*tf + 3*t0*tf^2 - tf^3));
    (a0*t0^4 + 3*a0*tf^4 - 3*af*t0^4 - af*tf^4 + 20*q0*t0^2 + 20*q0*tf^2 - 20*qf*t0^2 - 20*qf*tf^2 - 8*t0^3*v0 - 12*t0^3*vf + 12*tf^3*v0 + 8*tf^3*vf + 4*a0*t0^3*tf - 4*af*t0*tf^3 + 28*t0*tf^2*v0 - 32*t0^2*tf*v0 + 32*t0*tf^2*vf - 28*t0^2*tf*vf - 8*a0*t0^2*tf^2 + 8*af*t0^2*tf^2 + 80*q0*t0*tf - 80*qf*t0*tf)/(2*(t0^2 - 2*t0*tf + tf^2)*(t0^3 - 3*t0^2*tf + 3*t0*tf^2 - tf^3));
    -(30*q0*t0 + 30*q0*tf - 30*qf*t0 - 30*qf*tf + 2*a0*t0^3 + 3*a0*tf^3 - 3*af*t0^3 - 2*af*tf^3 - 14*t0^2*v0 - 16*t0^2*vf + 16*tf^2*v0 + 14*tf^2*vf - 4*a0*t0*tf^2 - a0*t0^2*tf + af*t0*tf^2 + 4*af*t0^2*tf - 2*t0*tf*v0 + 2*t0*tf*vf)/(2*(t0 - tf)^2*(t0^3 - 3*t0^2*tf + 3*t0*tf^2 - tf^3));
    (12*q0 - 12*qf - 6*t0*v0 - 6*t0*vf + 6*tf*v0 + 6*tf*vf + a0*t0^2 + a0*tf^2 - af*t0^2 - af*tf^2 - 2*a0*t0*tf + 2*af*t0*tf)/(2*(t0^2 - 2*t0*tf + tf^2)*(t0^3 - 3*t0^2*tf + 3*t0*tf^2 - tf^3))];

% Actual Position equation using the coefficients
position = A(1) + A(2)*t + A(3)*t^2 + A(4)*t^3 + A(5)*t^4 + A(6)*t^5;
end

