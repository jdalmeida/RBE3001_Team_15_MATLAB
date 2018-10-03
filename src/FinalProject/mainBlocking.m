%% General Code Inits
init;
pp = PacketProcessor(myHIDSimplePacketComs);

LivePlot3D([0,0,0], true, false);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

movementAlg = 'trajectoryBlocking';

Move(pp, tWorkPos, movementAlg);
Gripper(pp, OPEN);

%% Init Camera
cam = webcam();

%% Beginning of Loop
% while 1

ballInfo = GetBallPos(cam);

%% Trajectory Loop
for i = 1:3
    % Get the ball info
    currBall = ballInfo(i, :);
    
    if currBall(4) == -1
        continue;
    end
    
    xBall = currBall(1);
    yBall = currBall(2);
    zBall = currBall(3);
    colorBall = currBall(4);
    weightBall = currBall(5);
    
    try
        s = ikin([xBall, yBall, zBall]);
    catch error
        continue;
    end
    
    % Move to Work Position
    Move(pp, tWorkPos, movementAlg);
    
    % Move to ball
    Move(pp, [xBall, yBall, tWorkPos(3)], movementAlg);
    
    Move(pp, [xBall, yBall, zBall], movementAlg);
    Gripper(pp, CLOSE);
    pause(.5)
    
    % Move to Work Position
    Move(pp, tWorkPos, movementAlg);
    
    % Weigh ball
    
    % Drop off
    Move(pp, [Pokeballs(i, 1), Pokeballs(i, 2), Pokeballs(i, 3) + 40], movementAlg);
    Gripper(pp, OPEN);
    pause(.5)
end


Move(pp, tWorkPos, movementAlg);

pp.shutdown();