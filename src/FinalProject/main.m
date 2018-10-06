%% General Code Inits
init;
pp = PacketProcessor(myHIDSimplePacketComs);
LivePlot3D([0,0,0], true, false, [0,0,0]);

PID1=[.0025 0 0];
PID2=[.0025 0 .028];
PID3=[.002 0 .02];
PIDConfig(pp, PID1, PID2, PID3);

farAway = [-1000, -1000, -1000];

% plots for the ball markers
scale = 100;
pblue.handle = scatter3(farAway(1), farAway(2), farAway(3), scale, 'MarkerFaceColor',[0 0.749019622802734 0.749019622802734],...
    'MarkerEdgeColor',[0 0.749019622802734 0.749019622802734]);
pgreen.handle = scatter3(farAway(1), farAway(2), farAway(3), scale,'MarkerFaceColor',[0.466666668653488 0.674509823322296 0.18823529779911],...
    'MarkerEdgeColor',[0.466666668653488 0.674509823322296 0.18823529779911]);
pyellow.handle = scatter3(farAway(1), farAway(2), farAway(3), scale,'MarkerFaceColor',[1 0.843137264251709 0],...
    'MarkerEdgeColor',[1 0.843137264251709 0]);
scatterHandles = [pblue, pgreen, pyellow];

% forve vector
forceVector.handle = quiver3(0,0,0,0.0,0.0,0.0, ...
                    'MarkerFaceColor',[0 0 0],...
                    'MarkerEdgeColor',[0 0 0],...
                    'LineWidth',2,...
                    'AutoScaleFactor', 1,...
                    'MaxHeadSize', .5);

% Change which algorithm to use for movement
% 'trajectory' 'ivel'
alg = 'trajectory';
disp('Initializing Positions');
Setpoint(pp, 0, 0, 0);
Gripper(pp, OPEN);

%% Init Camera
cam = webcam();

%% Initial Declarations
ball = 1;

% for avgeraging the torque
counts = 100;
index = 0;
total = [0, 0, 0];
tipForce = zeros(1,3, 'double');

% flags
done=false; % if there are any balls avaliable
graph = true; % update the graph
camOn = true; % poll the camera
grabbed = false; % if a ball is grabbed

numberOfBalls = 0;
setVel = 20;

% moving 
curPos = GetCurrentPos(pp);
setPos = tWorkPos;
state = States.Start;
toffset = Findtoffset(curPos, setPos, setVel);

%weighing setup
weighCounter=1;
weighPoints=[90.36, 0, -11.6008;
             146, 0, 225.36;
             169, 0, 310];

% timer
disp('Beginning Loop');
tic;
startTime = toc;
%% Beginning of Loop
while 1
    % Continuously poll camera for ball information
    if camOn
        ball = 1;
        
        ballInfo = GetBallPos(cam);
        
        currBall = ballInfo(ball, :);
        
        % if current color does not exist, iterate to the next color
        % if none exist, chill until one appears
            
        if currBall(4) == -1
            ball = 2;
            currBall = ballInfo(ball, :);
            if currBall(4) == -1
                ball = 3;
                currBall = ballInfo(ball, :);
                if currBall(4) == -1
%                     done=true;
                    continue;
                end
            end
        end
        
        xBall = currBall(1);
        yBall = currBall(2);
        zBall = currBall(3);
        colorBall = currBall(4);
        weightBall = currBall(5);
    end
    
    %% State Machine
    switch state
        case 'Start'
            Move(pp, alg, setPos, curPos, startTime, toffset);
            now = toc;
            if now > startTime + toffset
                disp('Next state: Move Above Ball');
                curPos = tWorkPos;
                setPos = [xBall, yBall, tWorkPos(3)];
                toffset = Findtoffset(curPos, setPos, setVel);
                state = States.MoveAboveBall;
                startTime = toc;
            end
            
        case 'MoveAboveBall'
            setPos = [xBall, yBall, tWorkPos(3)];
            Move(pp, alg, setPos, curPos, startTime, toffset);
            now = toc;
            if now > startTime + toffset
                disp('Next state: Move Down');
                curPos = setPos;
                setPos = [xBall, yBall, zBall];
                toffset = Findtoffset(curPos, setPos, setVel);
                state = States.MoveDown;
                startTime = toc;
                camOn = false;
            end
            
        case 'MoveDown'
            Move(pp, alg, setPos, curPos, startTime, toffset);
            now = toc;
            if now > startTime + toffset
                disp('Next state: Grab Ball');
                curPos = setPos;
                state = States.GrabBall;
                startTime = toc;
            end
            
        case 'GrabBall'
            Gripper(pp, CLOSE);
            now = toc;
            if now > startTime + .5
                disp('Next state: Move To Weigh');
                grabbed = true;
                state = States.MoveToWeigh;
                setPos = fwkin(0, 0, 90);
                toffset = Findtoffset(curPos, setPos, setVel);
                startTime = toc;
            end
            
        case 'MoveToWeigh'
            [weighPointCount, ~]=size(weighPoints);
            if weighCounter<=weighPointCount
                Move(pp, alg, weighPoints(weighCounter), curPos, startTime, toffset);
                now = toc;
                if now > startTime + toffset
                    curPos=weighPoints(weighCounter);
                    weighCounter=weighCounter+1;
                end
            else
                weighCounter=1; %resets the weigh counter for the next time
                curPos=weighPoints(weighPointCount);
                index = 1;
                total = [0, 0, 0];
                graph = false;
                state = States.SortByWeight;
                disp('Sorting by Weight');
            end
            
        case 'SortByWeight'
            [~, ~, torq] = GetStatus(pp);
            total = total + torq * 4096;
            index = index + 1;
            if index > counts
                state = States.MoveToDropOff;
                
                force = total / counts;
                actualTorque = RawToTorque(force);
                tipForce = statics3001(jWorkPos, actualTorque);
                if abs(force(3)) < 3.4e+03
                    weightBall = HEAVY;
                else
                    weightBall = LIGHT;
                end
                disp('Weight');
                disp(weightBall);
                disp(tipForce(3));
                
                curPos = setPos;
                setPos = [Pokeballs(colorBall + weightBall, 1), Pokeballs(colorBall + weightBall, 2), Pokeballs(colorBall + weightBall, 3) + 40];
                toffset = Findtoffset(curPos, setPos, setVel);
                graph = true;
                startTime = toc;
            end
            
        case 'MoveToDropOff'
            Move(pp, alg, setPos, curPos, startTime, toffset);
            now = toc;
            if now > startTime + toffset
                disp('Next state: Release Ball');
                state = States.ReleaseBall;
                startTime = toc;
            end
            
        case 'ReleaseBall'
            Gripper(pp, OPEN);
            now = toc;
            if now > startTime + .5
                disp('Next state: Start');
                grabbed = false;
                state = States.Start;
                curPos = setPos;
                setPos = tWorkPos;
                toffset = Findtoffset(curPos, setPos, setVel);
                startTime = toc;
                camOn = true;
            end
            
        otherwise
            camOn = true;
            disp('All Done');
            state = States.Start;
    end
    
    if graph
        % Update 3D Model
        [pos, ~, torq]= GetStatus(pp);
        
        pos = TIC_TO_ANGLE * pos;
        actualTorque=RawToTorque(torq);
        
        tipForce=statics3001(pos, actualTorque);
        
        endPos = LivePlot3D(pos, false, false, tipForce);
        tipForce = double(tipForce);
        u = tipForce(1);
        v = tipForce(2);
        w = tipForce(3);
        
        set(forceVector.handle, 'XData', endPos(1), 'YData', endPos(2), 'ZData', endPos(3),...
            'UData', u, 'VData', v, 'WData', w);
        
        % Update Ball Plots
        for i = 1:3
            x = ballInfo(i, 1);
            y = ballInfo(i, 2);
            z = ballInfo(i, 3);
            
            if ballInfo(i,4) == EMPTY
                x = farAway(1);
                y = farAway(2);
                z = farAway(3);
            end
            
            if grabbed && ballInfo(i, 4) == colorBall
                x = endPos(1);
                y = endPos(2);
                z = endPos(3);
            end
            
            set(scatterHandles(i).handle, 'xdata', x, 'ydata', y,'zdata', z);
        end
        
    end
end

pp.shutdown();