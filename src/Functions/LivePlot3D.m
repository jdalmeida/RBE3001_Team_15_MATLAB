function LivePlot3D(q)
%LIVEPLOT3D Summary of this function goes here
%   Detailed explanation goes here
    q0 = q(1); q1 = q(2); q2 = q(3);
    
%     p0 = fwkin(q0, q1, q2);
    p0 = [1; 1; 1];
    p1 = [2; 2; 2];
    p2 = [3; 3; 3];
    
    
%% Initialize the figure
    figure()
    hold on
    axis equal;
    plot3(p0, p1, p2)
    



end

