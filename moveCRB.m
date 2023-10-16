function moveCRB(robot,leftGripper,rightGripper,position,pose,gripperToggle)
    %% Setup
    steps1 = 50;
    steps2 = 100;
    
    % Gripper positions
    qOpen = -0.05;
    qClose = -0.01;
    gripperZOffset = 0.12;

    % Poses
    poseDown = trotx(deg2rad(180));
    poseForward = troty(deg2rad(90));
    poseBackward = troty(deg2rad(-90));
    poseRight = trotx(deg2rad(-90)) * trotz(deg2rad(-90));
    poseLeft = trotx(deg2rad(90)) * trotz(deg2rad(90));
    
    % Update pose
    if pose == 1
        finalPose = transl(position(1),position(2),position(3)+gripperZOffset) * poseDown;
    elseif pose == 2
        finalPose = transl(position(1),position(2),position(3)+gripperZOffset) * poseForward;
    elseif pose == 3
        finalPose = transl(position(1),position(2),position(3)+gripperZOffset) * poseBackward;
    elseif pose == 4
        finalPose = transl(position(1),position(2),position(3)+gripperZOffset) * poseRight;
    elseif pose == 5
        finalPose = transl(position(1),position(2),position(3)+gripperZOffset) * poseLeft;
    end

    % Gripper trajectory
    qClosing = jtraj(qOpen,qClose,steps1); 
    qOpening = jtraj(qClose,qOpen,steps1);

    % Robot positions
    qStart = robot.model.getpos();
    qFinal = robot.model.ikcon(finalPose);

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
        end
        
        drawnow();
        pause(0)
    end

    % Gripper closing or opening
    for i = 1:steps1
        % animate gripper depending on input
        if gripperToggle == 0
            leftGripper.model.animate(qClosing(i,:));
            rightGripper.model.animate(qClosing(i,:));
        elseif gripperToggle == 1
            leftGripper.model.animate(qOpening(i,:));
        rightGripper.model.animate(qOpening(i,:));
        end
        
        drawnow();
        pause(0)
    end
    
end