%% General Code Inits
init;
pp = PacketProcessor(myHIDSimplePacketComs);
LivePlot3D([0,0,0], true, false, [0,0,0]);

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

alg = 'ivel';

Gripper(pp, OPEN);

%% Init Camera
cam = webcam();

% Initial Declarations
ball = 1;
camOn = 1;
grabbed = 0;

counts = 10;
index = 0;
total = [0, 0, 0];
done=false;
graph = true;

setVel = 20;

curPos = GetCurrentPos(pp);
setPos = tWorkPos;
state = States.Start;
toffset = Findtoffset(curPos, setPos, setVel);
% toffset = 1.5;

tic;
startTime = toc;

%% Beginning of Loop
while ~done
    % Continuously poll camera for ball information
    if camOn
        ball = 1;
        
        ballInfo = GetBallPos(cam);
        
        currBall = ballInfo(ball, :);
        
        % if current color does not exist, move on to the next color
        % if none exist, chill until one appears
        if currBall(4) == -1
            ball = 2;
            currBall = ballInfo(ball, :);
            if currBall(4) == -1
                ball = 3;
                currBall = ballInfo(ball, :);
                if currBall(4) == -1
                    done=true;
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
                camOn = 0;
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
                grabbed = 1;
                state = States.MoveToWeigh;
                setPos = tWorkPos;
                toffset = Findtoffset(curPos, setPos, setVel);
                startTime = toc;
            end
            
        case 'MoveToWeigh'
            Move(pp, alg, setPos, curPos, startTime, toffset);
            now = toc;
            if now > startTime + toffset
                disp('Next state: Sort By Weight');
                index = 1;
                total = [0, 0, 0];
                graph = false;
                state = States.SortByWeight;
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
                if tipForce(2) > .2
                    weightBall = HEAVY;
                else
                    weightBall = LIGHT;
                end
                disp('Weight');
                disp(weightBall);
                disp(tipForce(2));
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
                grabbed = 0;
                state = States.Start;
                curPos = setPos;
                setPos = tWorkPos;
                toffset = Findtoffset(curPos, setPos, setVel);
                startTime = toc;
                camOn = 1;
            end
            
        otherwise
            camOn = 1;
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
        
        % Update Ball Plots
        for i = 1:3
            x = ballInfo(i, 1);
            y = ballInfo(i, 2);
            z = ballInfo(i, 3);
            
            if ballInfo(i,4) == -1
                x = -1000;
                y = -1000;
                z = -1000;
            end
            
            if grabbed == 1 && ballInfo(i, 4) == colorBall
                x = endPos(1);
                y = endPos(2);
                z = endPos(3);
            end
            
            set(scatterHandles(i).handle, 'xdata', x, 'ydata', y,'zdata', z);
        end
    end
end

pp.shutdown();