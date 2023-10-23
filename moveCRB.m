function moveCRB(robot,leftGripper,rightGripper,pickupPosition,placePosition,book)
    %% Setup
    steps1 = 50;        
    steps2 = 100;       
    
    % Gripper positions
    qOpen = -0.02;
    qClose = -0.01;
    gripperOffset = 0.08;
    bookOffset = 0.25;
    shelfOffset = 0.4;

    % Gripper trajectory
    qClosing = jtraj(qOpen,qClose,steps1); 
    qOpening = jtraj(qClose,qOpen,steps1);
    
    % Robot positions
    posePickupHover = transl(pickupPosition(1),pickupPosition(2),pickupPosition(3)+bookOffset) * trotx(deg2rad(180));
    posePickup = transl(pickupPosition(1),pickupPosition(2),pickupPosition(3)+gripperOffset) * trotx(deg2rad(180));
    posePlaceHover1 = transl(placePosition(1),placePosition(2)-shelfOffset,placePosition(3)) * trotx(deg2rad(-90)) * trotz(deg2rad(-90));
    posePlace = transl(placePosition(1),placePosition(2)-gripperOffset,placePosition(3)) * trotx(deg2rad(-90)) * trotz(deg2rad(-90));
    posePlaceHover2 = transl(placePosition(1),placePosition(2)-bookOffset,placePosition(3)) * trotx(deg2rad(-90)) * trotz(deg2rad(-90));
    
    % Robot guess positions
    qBook = [0.4987, 1.6456, -0.3844, -1.1469, 1.6955, 0.6597];
    qShelf = [1.5708, -0.3491, 0.8727, 0, -0.5236, 0];

    % Robot positions
    qStart = robot.model.getpos();
    qPickupHover = robot.model.ikcon(posePickupHover, qBook);
    qPickup = robot.model.ikcon(posePickup, qPickupHover);
    qPlaceHover1 = robot.model.ikcon(posePlaceHover1, qShelf);
    qPlace = robot.model.ikcon(posePlace, qPlaceHover1);
    qPlaceHover2 = robot.model.ikcon(posePlaceHover2, qPlace);

    % Robot trajectory
    trajPickupHover = jtraj(qStart,qPickupHover,steps2);
    trajPickup = jtraj(qPickupHover,qPickup,steps1);
    trajPlaceHover1 = jtraj(qPickup,qPlaceHover1,steps2);
    trajPlace = jtraj(qPlaceHover1,qPlace,steps1);
    trajPlaceHover2 = jtraj(qPlace,qPlaceHover2,steps1);

    %% Moving
    % Pickup Hover
    for i = 1:steps2
        % update CRB
        robot.model.animate(trajPickupHover(i,:));
        % update gripper to end-effector
        leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
        rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
        leftGripper.model.animate(qOpen);
        rightGripper.model.animate(qOpen);
        
        drawnow();
        pause(0)
    end

    crbLogging(robot);

    % Pickup
    for i = 1:steps1
        % update CRB
        robot.model.animate(trajPickup(i,:));
        % update gripper to end-effector
        leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
        rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
        leftGripper.model.animate(qOpen);
        rightGripper.model.animate(qOpen);

        drawnow();
        pause(0)
    end

    crbLogging(robot);

    % Close Gripper
    for i = 1:steps1
        leftGripper.model.animate(qClosing(i,:));
        rightGripper.model.animate(qClosing(i,:));

        drawnow();
        pause(0)
    end

    % Shelf Hover
    for i = 1:steps2
        % update CRB
        robot.model.animate(trajPlaceHover1(i,:));
        % update gripper to end-effector
        leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
        rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
        leftGripper.model.animate(qClose);
        rightGripper.model.animate(qClose);
        % move book
        book.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi);
        book.model.animate(0);
        
        drawnow();
        pause(0)
    end

    crbLogging(robot);

    % Shelf
    for i = 1:steps1
        % update CRB
        robot.model.animate(trajPlace(i,:));
        % update gripper to end-effector
        leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
        rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
        leftGripper.model.animate(qClose);
        rightGripper.model.animate(qClose);
        % move book
        book.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi);
        book.model.animate(0);
        
        drawnow();
        pause(0)
    end

    crbLogging(robot);

    % Open Gripper
    for i = 1:steps1
        leftGripper.model.animate(qOpening(i,:));
        rightGripper.model.animate(qOpening(i,:));

        drawnow();
        pause(0)
    end

    % Shelf Hover
    for i = 1:steps1
        % update CRB
        robot.model.animate(trajPlaceHover2(i,:));
        % update gripper to end-effector
        leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
        rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
        leftGripper.model.animate(qOpen);
        rightGripper.model.animate(qOpen);

        drawnow();
        pause(0)
    end

    crbLogging(robot);
end

function crbLogging(robot)
    XYZ = transl(robot.model.fkine(robot.model.getpos()));
    disp("CRB15000 End-Effector Position: ");
    disp(['X: ', num2str(XYZ(1,1))]);
    disp(['Y: ', num2str(XYZ(1,2))]);
    disp(['Z: ', num2str(XYZ(1,3)), newline]);
end