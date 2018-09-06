function [p0, p1, p2] = fwkin(q0, q1, q2) 
    L1 = 135; L2 = 175; L3 = 169.28; 
    
    T01 = [cosd(q0), 0, -sind(q0), 0;
        sind(q0), 0, cosd(q0), 0;
        0, -1, 0, L1;
        0, 0, 0, 1]; 
    
    T12 = [cosd(q1), -sind(q1), 0, L2.*cosd(q1);
        sind(q1), cosd(q1), 0, L2.*sind(q1);
        0, 0, 1, 0;
        0, 0, 0, 1];
    
    T23 = [cosd(q2 + 90), -sind(q2 + 90), 0, L3.*cosd(q2 + 90);
           sind(q2 + 90), cosd(q2 + 90), 0, L3.*cosd(q2 + 90);
           0, 0, 1, 0;
           0, 0, 0, 1];
    
    
    T02 = T01 * T12;
    T03 = T02 * T23;
    
    p2 = [L3.*cos(q2); L3.*sin(q2); 0; 1];
    p = T02 * p2;
    
    p0 = p([1:3]);
end