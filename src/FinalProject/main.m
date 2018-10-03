%% General Code Inits
init;
pp = PacketProcessor(myHIDSimplePacketComs);

LivePlot3D([0,0,0], true, false);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

% plots for the ball markers
scale = 100;
pblue.handle = scatter3(0,0,0, scale, 'MarkerFaceColor',[0 0.749019622802734 0.749019622802734],...
    'MarkerEdgeColor',[0 0.749019622802734 0.749019622802734]);
pgreen.handle = scatter3(0,0,0, scale,'MarkerFaceColor',[0.466666668653488 0.674509823322296 0.18823529779911],...
    'MarkerEdgeColor',[0.466666668653488 0.674509823322296 0.18823529779911]);
pyellow.handle = scatter3(0,0,0, scale,'MarkerFaceColor',[1 0.843137264251709 0],...
    'MarkerEdgeColor',[1 0.843137264251709 0]);
scatterHandles = [pblue, pgreen, pyellow];


alg = 'trajectory';
state = States.Start;

Gripper(pp, OPEN);

%% Init Camera
cam = webcam();

% Initial Declarations
ball = 1;
setVel = 20;
curPos = GetCurrentPos(pp);
setPos = tWorkPos;

toffset = Findtoffset(curPos, setPos, setVel);

tic;
startTime = toc;
%% Beginning of Loop
while 1
    % Continuously poll camera for ball information
    ballInfo = GetBallPos(cam);
    UpdateBallPlot;
    
    currBall = ballInfo(ball, :);
    
    if currBall(4) == -1
        continue;
    end
    
    xBall = currBall(1);
    yBall = currBall(2);
    zBall = currBall(3);
    colorBall = currBall(4);
    weightBall = currBall(5);
    
    %% State Machine
    switch state
        case 'Start'
            Move(pp, alg, setPos, curPos, startTime, toffset);
            now = toc;
            if now > startTime + toffset
                curPos = GetCurrentPos(pp);
                state = States.MoveAboveBall;
                setPos = [xBall, yBall, tWorkPos(3)];
                toffset = Findtoffset(curPos, setPos, setVel);
                startTime = toc;
            end
            
        case 'MoveAboveBall'
            Move(pp, alg, setPos, curPos, startTime, toffset);
            
            if now > startTime + toffset
                state = 0;
            end
%         case MoveDown
%             setPos = [xBall, yBall, zBall];
%             Move(pp, alg, setPos, curPos, startTime);
%             
%         case GrabBall
%             Gripper(pp, CLOSE);
%             pause(.5);
%             
%         case MoveToWeigh
%             setPos = tWorkPos;
%             Move(pp, alg, setPos, curPos, startTime);
%             
%         case SortByWeight
%             
%         case MoveToDropOff
%             
%             Move(pp, alg, setPos, curPos, startTime);
%             
%         case ReleaseBall
%             Gripper(pp, OPEN);
%             pause(.5);
        otherwise
            disp('dOnE fUcKeD uP nOw');
    end
    
    % Update 3D Model
    UpdateStickModel;
end

pp.shutdown();