
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
            toffset = 1.5;
            startTime = toc;
        end
        
    case 'MoveToWeigh'
        [weighPointCount, ~]=size(weighPoints);
        if weighCounter<=weighPointCount
            Move(pp, alg, weighPoints(weighCounter, :), curPos, startTime, toffset);
            now = toc;
            if now > startTime + toffset
                curPos=weighPoints(weighCounter, :);
                startTime = toc;
                weighCounter=weighCounter+1;
            end
        else
            weighCounter=1; %resets the weigh counter for the next time
            curPos=weighPoints(weighPointCount, :);
            index = 1;
            total = [0, 0, 0];
            graph = false;
            state = States.SortByWeight;
            disp('Next State" Sorting by Weight');
        end
        
    case 'SortByWeight'
        [~, ~, torq] = GetStatus(pp);
        total = total + torq * 4096;
        index = index + 1; %% State Machine
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
                    toffset = 1.5;
                    startTime = toc;
                end
                
            case 'MoveToWeigh'
                [weighPointCount, ~]=size(weighPoints);
                if weighCounter<=weighPointCount
                    Move(pp, alg, weighPoints(weighCounter, :), curPos, startTime, toffset);
                    now = toc;
                    if now > startTime + toffset
                        curPos=weighPoints(weighCounter, :);
                        startTime = toc;
                        weighCounter=weighCounter+1;
                    end
                else
                    weighCounter=1; %resets the weigh counter for the next time
                    curPos=weighPoints(weighPointCount, :);
                    index = 1;
                    total = [0, 0, 0];
                    graph = false;
                    state = States.SortByWeight;
                    disp('Next State" Sorting by Weight');
                end
                
            case 'SortByWeight'
                [~, ~, torq] = GetStatus(pp);
                total = total + torq * 4096;
                index = index + 1;
                if index > counts
                    state = States.MoveToDropOff;
                    
                    force = total / counts;
                    actualTorque = RawToTorque(force);
                    tipForce = statics3001([0,90,0], actualTorque) * 1000;
                    if tipForce(3) > 100
                        weightBall = HEAVY;
                    else
                        weightBall = LIGHT;
                    end
                    
                    disp('Weight');
                    disp(weightBall);
                    disp(tipForce(3));
                    
                    curPos = weighPoints(3,:);
                    setPos = [Pokeballs(colorBall + weightBall, 1), Pokeballs(colorBall + weightBall, 2), Pokeballs(colorBall + weightBall, 3) + 40];
                    toffset = Findtoffset(curPos, setPos, setVel);
                    graph = true;
                    
                    disp('Next State: Move To Pokeballs');
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
        if index > counts
            state = States.MoveToDropOff;
            
            force = total / counts;
            actualTorque = RawToTorque(force);
            tipForce = statics3001([0,90,0], actualTorque) * 1000;
            if tipForce(3) > 100
                weightBall = HEAVY;
            else
                weightBall = LIGHT;
            end
            
            disp('Weight');
            disp(weightBall);
            disp(tipForce(3));
            
            curPos = weighPoints(3,:);
            setPos = [Pokeballs(colorBall + weightBall, 1), Pokeballs(colorBall + weightBall, 2), Pokeballs(colorBall + weightBall, 3) + 40];
            toffset = Findtoffset(curPos, setPos, setVel);
            graph = true;
            
            disp('Next State: Move To Pokeballs');
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