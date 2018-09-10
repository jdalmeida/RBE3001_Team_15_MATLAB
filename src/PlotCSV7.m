% triangle = csvread('triangle_step7.csv');
triangle = csvread('trajectory_8.csv');

time = triangle(:,1);
x = triangle(:,2);
y = triangle(:,3);
z = triangle(:,4);
j1 = triangle(:,5);
j2 = triangle(:,6);
j3 = triangle(:,7);

figure(1);

subplot(2,2,1);
hold on;
grid('on');
title('Angles over Time');
xlabel('Angle (deg)');
ylabel('Position (mm)');
plot(time, j1, '-b','LineWidth',2 ,'DisplayName','Joint 1');
plot(time, j2, '-g','LineWidth',2 ,'DisplayName','Joint 2');
plot(time, j3, '-r','LineWidth',2 ,'DisplayName','Joint 3');
legend('show');

subplot(2,2,2);
hold on;
grid('on');
title('Endefactor Position over Time');
xlabel('Time (s)');
ylabel('Position (mm)');
plot(time, x, '-b','LineWidth',2 ,'DisplayName','X Postition');
plot(time, z, '-r','LineWidth',2 ,'DisplayName','Z Position');
legend('show');


subplot(2,2,3);
hold on;
grid('on');
title('Velocity over Time');
xlabel('Time (s)');
ylabel('Velocity (mm/s)');
legend('show');

vx = diff(x);
vz = diff(z);

plot(time(1:end -1), vx, '-b','LineWidth',2 ,'DisplayName','X Velocity');
plot(time(1:end -1), vz, '-r','LineWidth',2 ,'DisplayName','Z Velocity');

subplot(2,2,4)
hold on;
grid('on');
title('Tip Position in XZ');
xlabel('X Position (mm)');
ylabel('Z Position (mm)');
plot(x,z, '-b','LineWidth',2);

% Step 7
% scatter(186.5039, 194.6181,'r', 'filled');
% scatter(255.2153, -17.7121,'r', 'filled');
% scatter(171.0305,-27.5186,'r', 'filled');
% Step 9
scatter(161.6531, 11.1744,'r', 'filled');
scatter(245.0429, 10.2376,'r', 'filled');
scatter(246.3415, 122.8539,'r', 'filled');

