%% General Code Inits
init;
pp = PacketProcessor(myHIDSimplePacketComs);

LivePlot3D([0,0,0], true, false);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

alg = 'trajectoryBlocking';

Gripper(pp, OPEN);
startTime = 0;
toffset = 0;
curPos = [0,0,0];

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
    setPos = tWorkPos;
    Move(pp, alg, setPos, curPos, startTime, toffset);
    
    % Move to ball
    setPos = [xBall, yBall, tWorkPos(3)];
    Move(pp, alg, setPos, curPos, startTime, toffset);
    
    setPos = [xBall, yBall, zBall];
    Move(pp, alg, setPos, curPos, startTime, toffset);
    Gripper(pp, CLOSE);
    pause(.5)
    
    % Move to Work Position
    setPos = tWorkPos;
    Move(pp, alg, setPos, curPos, startTime, toffset);
    
    % Weigh ball
    
    % Drop off
    setPos = [Pokeballs(i, 1), Pokeballs(i, 2), Pokeballs(i, 3) + 40];
    Move(pp, alg, setPos, curPos, startTime, toffset);
    Gripper(pp, OPEN);
    pause(.5)
end


Move(pp, tWorkPos, alg);

pp.shutdown();