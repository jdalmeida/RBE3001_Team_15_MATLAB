init;
pp = PacketProcessor(myHIDSimplePacketComs);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

counts = 100;

SEEVALS = 0;

%% Move to directly overhead to get all offsets
% No Mass on the end
Setpoint(pp, 0, 90, 0);
pause(1);
Setpoint(pp, 0, 90, 90);
pause(1);

y0total = zeros(1,3, 'single');

for i = 1:counts
    [pos, vel, torq] = GetStatus(pp);
    
    if SEEVALS == 1
        disp(torq);
    end
    
    y0total = y0total + torq;
    pause(.01);
end

% offset in terms of adc values
offset = y0total / counts;
disp('offset');
disp(offset);


%% Find torque due to link 3
% No mass on end
Setpoint(pp, 0, 90, 0);
pause(1);
Setpoint(pp, 0, 0, 0);
pause(1);
Setpoint(pp, 0, 0, 90);
pause(1);

totaltorq = zeros(1,3, 'single');
for i = 1:counts
    [~, ~, torq] = GetStatus(pp);
    if SEEVALS == 1
        disp(torq);
    end
    totaltorq = totaltorq + torq;
    
    pause(.01);
end

avgtorq = totaltorq/counts;
kTorql3 = avgtorq - offset;
disp('K*torque Link 3');
disp(kTorql3);

%% Find scale factor
% Requires mass on end

disp('Press any button when mass is on to continue');
waitforbuttonpress;
disp('Button Pressed');

totaltorq = zeros(1,3, 'single');
for i = 1:counts
    [~, ~, torq] = GetStatus(pp);
    if SEEVALS == 1
        disp(torq);
    end
    totaltorq = totaltorq + torq;
    
    pause(.01);
end

avgtorq = totaltorq/counts;
avgkx = avgtorq - offset - kTorql3;


j2k = avgkx(2) / (.25 * 9.8 * (175+169.28));
j3k = avgkx(3) / (.25 * 9.8 * (169.28));

disp('joint 2 scale factor');
disp(j2k);
disp('joint 3 scale factor');
disp(j3k);


pp.shutdown();
