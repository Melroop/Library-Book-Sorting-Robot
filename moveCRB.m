function moveCRB(robot,leftGripper,rightGripper,initialBookPosition, finalPosition,bookObject,gripperOrientation,gripperToggle,bookToggle)
    %% Setup
    steps1 = 50;        % Gripper
    steps2 = 100;       % Arm Movements
    
    % Gripper positions
    qOpen = -0.02;
    qClose = -0.01;
    gripperOffset = 0.08;
    
    % Book
    initPos = initialBookPosition;
    initOri = eye(3);
    initPose = [initOri, initPos'; 0, 0, 0, 1];
    bookVert = get(bookObject,'Vertices'); % Get ply vertices to be updated

    % Gripper orientations (pose)
    poseDown = trotx(deg2rad(180));
    poseForward = troty(deg2rad(90));
    poseBackward = troty(deg2rad(-90));
    poseRight = trotx(deg2rad(-90)) * trotz(deg2rad(-90));
    poseLeft = trotx(deg2rad(90));
    
    % Update pose
    if gripperOrientation == 1
        finalPose = transl(finalPosition(1),finalPosition(2),finalPosition(3)+gripperOffset) * poseDown;
    elseif gripperOrientation == 2
        finalPose = transl(finalPosition(1)-gripperOffset,finalPosition(2),finalPosition(3)) * poseForward;
    elseif gripperOrientation == 3
        finalPose = transl(finalPosition(1)+gripperOffset,finalPosition(2),finalPosition(3)) * poseBackward;
    elseif gripperOrientation == 4
        finalPose = transl(finalPosition(1),finalPosition(2)-gripperOffset,finalPosition(3)) * poseRight;
    elseif gripperOrientation == 5
        finalPose = transl(finalPosition(1),finalPosition(2)+gripperOffset,finalPosition(3)) * poseLeft;
    end

    % Gripper trajectory
    qClosing = jtraj(qOpen,qClose,steps1); 
    qOpening = jtraj(qClose,qOpen,steps1);
    
    % Robot guess positions
    qBook = [0.4987, 1.6456, -0.3844, -1.1469, 1.6955, 0.6597];
    qScan = [0, 0.6912, 0.7575, 2.1363, 0.1885, 0];
    qShelf = [0, 0.6912, 0.7575, 2.1363, 0.1885, 0];

    % Robot positions
    qStart = robot.model.getpos();
    if gripperOrientation == 5
        qFinal = robot.model.ikcon(finalPose, qBook);
    elseif gripperOrientation == 4
        qFinal = robot.model.ikcon(finalPose);
    elseif gripperOrientation == 3
        qFinal = robot.model.ikcon(finalPose);
    elseif gripperOrientation == 2
        qFinal = robot.model.ikcon(finalPose);
    elseif gripperOrientation == 1
        qFinal = robot.model.ikcon(finalPose, qScan);
    end

    % Robot trajectory
    qTraj = jtraj(qStart,qFinal,steps2);

    %% Moving
    % Move arm
    for i = 1:steps2
        % animate from initial to final position
        robot.model.animate(qTraj(i,:));                                               
        
        % update gripper to end-effector
        leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
        rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
        
        % set gripper toggle based on input
        if gripperToggle == 0
            leftGripper.model.animate(qOpen);                                                              
            rightGripper.model.animate(qOpen); 
        elseif gripperToggle == 1
            leftGripper.model.animate(qClose);                                                              
            rightGripper.model.animate(qClose);
        elseif gripperToggle == 2
            leftGripper.model.animate(qClose);                                                              
            rightGripper.model.animate(qClose);
        elseif gripperToggle == 3
            leftGripper.model.animate(qOpen);                                                              
            rightGripper.model.animate(qOpen);
        end

        % move book
        if bookToggle == 1
            % endEffectorPos = robot.model.fkine(robot.model.getpos());                       % Get end effector position
            % newBookPose = transl(endEffectorPos);                                           % Create translation vector new position
            % oldBookPose = [finalPose(1,4) finalPose(2,4) finalPose(3,4)];                   % Create translation vector old position
            % transformVector = newBookPose - oldBookPose;                                    % Get the new transform vector
            % movingTransform = transl(transformVector);                                      % Create translation matrix        
            % newBookVert = (movingTransform * [bookVert, ones(size(bookVert, 1),1)]')';      % Multiply all vertices by transformation matrix
            % set(bookObject,'Vertices',newBookVert(:,1:3));                                  % Update brick

            endEffectorPos = robot.model.fkine(robot.model.getpos()).T;                             % Get end effector position
            bookTransform = endEffectorPos * inv(initPose);            % Calculate the transformation
            newBookVert = (bookVert(:,1:3) * bookTransform(1:3,1:3)') + bookTransform(1:3,4)';   % New book vertices
            set(bookObject,'Vertices',newBookVert(:,1:3));                                          % Update book model
        end
        
        drawnow();
        pause(0)
    end
    
    % Gripper closing or opening
    if gripperToggle == 0
        for i = 1:steps1
            leftGripper.model.animate(qClosing(i,:));
            rightGripper.model.animate(qClosing(i,:));

            drawnow();
            pause(0)
        end
    elseif gripperToggle == 1
        for i = 1:steps1
            leftGripper.model.animate(qOpening(i,:));
            rightGripper.model.animate(qOpening(i,:));

            drawnow();
            pause(0)
        end
    end
end