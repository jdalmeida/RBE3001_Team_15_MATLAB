function [p0] = fwkin(q0, q1, q2) 

    L1 = 135; L2 = 175; L3 = 169.28; 
    
    T01 = DHSolver(0, -90, L1, q0);
    T12 = DHSolver(L2, 0, 0, q1);
    T23 = DHSolver(L3, 0, 0, q2);

    T02 = T01 * T12;
    T03 = T02 * T23;
    
    p = T03(:,4);
    
    p0 = p([1:3]);
end