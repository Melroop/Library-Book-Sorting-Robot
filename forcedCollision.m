function forcedCollision(robot1,robot2,scanner,leftGripper,rightGripper)
    % Variable Setup
    steps = 50;
    qOpen = -0.02;
    
    % Scanner Setup
    verts = [get(scanner, 'Vertices'), ones(size(get(scanner, 'Vertices'), 1), 1)];
    rfkineT = robot1.model.fkine(robot1.model.getpos()).T;
    scannerinitOrientation = eye(3);
    scannerinitPosition = [rfkineT(1,4) rfkineT(2,4) rfkineT(3,4)];
    scannerinitPose = [scannerinitOrientation, scannerinitPosition'; 0,0,0,1];
        
    % Start Positions
    qUR3Start = robot1.model.getpos();
    qCRBStart = robot2.model.getpos();
    
    % Collision Positions
    qUR3Collision = [-2.0445, -2.6429, -2.4933, 0, 1.5708, 0];
    qCRBCollision = [0.6732, 1.0223, -0.8997, 0, 0, 0];
    
    % Trajectories
    trajUR3 = jtraj(qUR3Start,qUR3Collision,steps);
    trajCRB = jtraj(qCRBStart,qCRBCollision,steps);

    % UR3 Collision Detection
    for i = 1:steps
        % Check Collision Ahead
        if i < steps
            collisionIndexUR3 = collisionDetection(robot1,trajUR3(i+1,:));
        end
        % Animate if no collision
        if collisionIndexUR3 == 1
            disp('UR3 Colliusion Detected. Aborting Motion.');
            % Reverse back to start position
            for j = i:-1:1
                robot1.model.animate(trajUR3(j,:));
                
                endEffectorPose = robot1.model.fkine(robot1.model.getpos()).T;
                scannerTransform = endEffectorPose * inv(scannerinitPose);   
                newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
                set(scanner, 'Vertices', newVerts);

                pause(0)
            end
            break   % abort
        else
            robot1.model.animate(trajUR3(i,:));
            
            endEffectorPose = robot1.model.fkine(robot1.model.getpos()).T;
            scannerTransform = endEffectorPose * inv(scannerinitPose);   
            newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
            set(scanner, 'Vertices', newVerts);

            pause(0)
        end
    end

    % CRB Collision Detection
    for i = 1:steps
        % Check Collision Ahead
        if i < steps
            collisionIndexUR3 = collisionDetection(robot2,trajCRB(i+1,:));
        end
        % Animate if no collision
        if collisionIndexUR3 == 1
            disp('CRB Colliusion Detected. Aborting Motion.');
            % Reverse back to start position
            for j = i:-1:1
                robot2.model.animate(trajCRB(j,:));

                leftGripper.model.base = robot2.model.fkine(robot2.model.getpos()).T * trotx(-pi/2);    
                rightGripper.model.base = robot2.model.fkine(robot2.model.getpos()).T * trotx(pi/2) * trotz(pi);
                leftGripper.model.animate(qOpen);
                rightGripper.model.animate(qOpen);

                pause(0)
            end
            break   % abort
        else
            robot2.model.animate(trajCRB(i,:));
            
            leftGripper.model.base = robot2.model.fkine(robot2.model.getpos()).T * trotx(-pi/2);    
            rightGripper.model.base = robot2.model.fkine(robot2.model.getpos()).T * trotx(pi/2) * trotz(pi);
            leftGripper.model.animate(qOpen);
            rightGripper.model.animate(qOpen);

            pause(0)
        end
    end
end