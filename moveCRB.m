function moveCRB(robot,leftGripper,rightGripper,position,gripperOrientation,gripperToggle)
    %% Setup
    steps1 = 50;        % Gripper
    steps2 = 100;       % Arm Movements
    
    % Gripper positions
    qOpen = -0.05;
    qClose = -0.01;
    gripperZOffset = 0.12;

    % Gripper orientations (pose)
    poseDown = trotx(deg2rad(180));
    poseForward = troty(deg2rad(90));
    poseBackward = troty(deg2rad(-90));
    poseRight = trotx(deg2rad(-90)) * trotz(deg2rad(-90));
    poseLeft = trotx(deg2rad(90)) * trotz(deg2rad(90));
    
    % Update pose
    if gripperOrientation == 1
        finalPose = transl(position(1),position(2),position(3)+gripperZOffset) * poseDown;
    elseif gripperOrientation == 2
        finalPose = transl(position(1),position(2),position(3)+gripperZOffset) * poseForward;
    elseif gripperOrientation == 3
        finalPose = transl(position(1),position(2),position(3)+gripperZOffset) * poseBackward;
    elseif gripperOrientation == 4
        finalPose = transl(position(1),position(2),position(3)+gripperZOffset) * poseRight;
    elseif gripperOrientation == 5
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
        elseif gripperToggle == 2
            leftGripper.model.animate(qClose);                                                              
            rightGripper.model.animate(qClose);
        elseif gripperToggle == 3
            leftGripper.model.animate(qOpen);                                                              
            rightGripper.model.animate(qOpen);
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