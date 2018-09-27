star = csvread('powered6.csv');

x = star(:,2);
y = star(:,3);
z = star(:,4);

figure;
hold on;
grid('on');
title('Path of 5 Points');
xlabel('X Pos (mm)');
zlabel('Z Pos (mm)');
ylabel('Y Pos (mm)');

plot3(x, y, z, 'LineWidth',2);

%% Plot setpoints
sp = [225.7426 -102.4014   29.8236;...
      173.3530    0.6051  229.1697;...
      205.8314  115.0353   22.1057;...
      197.8043 -127.9653  154.1962;...
      204.2296  123.6859  175.6490];

for i = 1:5
    scatter3(sp(i,1), sp(i,2), sp(i,3),'r', 'filled');
end
