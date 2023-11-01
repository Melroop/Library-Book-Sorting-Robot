function moveCRB(robot,leftGripper,rightGripper,pickupPosition,placePosition,book)
    %% Setup
    steps1 = 25;        
    steps2 = 50;       
    
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
    poseBookOver = transl(pickupPosition(1),pickupPosition(2),pickupPosition(3)+bookOffset) * trotx(deg2rad(180));
    posePickup = transl(pickupPosition(1),pickupPosition(2),pickupPosition(3)+gripperOffset) * trotx(deg2rad(180));
    poseShelfOut = transl(placePosition(1),placePosition(2)-shelfOffset,placePosition(3)) * trotx(deg2rad(-90)) * trotz(deg2rad(-90));
    posePlace = transl(placePosition(1),placePosition(2)-gripperOffset,placePosition(3)) * trotx(deg2rad(-90)) * trotz(deg2rad(-90));
    
    % Robot guess positions
    qBook = [-0.1995, 0.8009, 0.4641, -0.2992, 0.3491, 0];
    qShelf = [1.5708, -0.3491, 0.8727, 0, -0.5236, 0];

    % Robot positions
    qStart = robot.model.getpos();
    qBookOver = robot.model.ikcon(poseBookOver, qBook);
    qPickup = robot.model.ikcon(posePickup, qBookOver);
    qMiddle = [0, -0.7854, 1.3090, 0, -0.5236, 0];
    qPlace = robot.model.ikcon(posePlace, qShelf);
    qArmOut = robot.model.ikcon(poseShelfOut, qPlace);

    % Robot trajectory
    trajBookOver = jtraj(qStart,qBookOver,steps2);
    trajPickup = jtraj(qBookOver,qPickup,steps2);
    trajBookOut = jtraj(qPickup,qBookOver,steps2);
    trajMiddle = jtraj(qBookOver,qMiddle,steps2);
    trajShelfOut = jtraj(qMiddle,qArmOut,steps2);
    trajPlace = jtraj(qArmOut,qPlace,steps2);
    trajArmOut = jtraj(qPlace,qArmOut,steps2);
    trajStart = jtraj(qArmOut,qStart,steps2);

    % Collision Check (0 = no collision)
    disp("Checking Collision...");
    collisionIndex = collisionDetection(robot,trajBookOver);
    if collisionIndex == 0
        collisionIndex = collisionDetection(robot,trajPickup);
    end
    if collisionIndex == 0
        collisionIndex = collisionDetection(robot,trajBookOut);
    end
    if collisionIndex == 0
        collisionIndex = collisionDetection(robot,trajMiddle);
    end
    if collisionIndex == 0
        collisionIndex = collisionDetection(robot,trajShelfOut);
    end
    if collisionIndex == 0
        collisionIndex = collisionDetection(robot,trajPlace);
    end
    if collisionIndex == 0
        collisionIndex = collisionDetection(robot,trajArmOut);
    end
    if collisionIndex == 0
        collisionIndex = collisionDetection(robot,trajStart);
    end

    %% Moving
    if collisionIndex == 0
        % Display
        disp("No Collision Detected. Moving Book.");
        
        % Move arm over book
        for i = 1:steps2
            % update CRB
            robot.model.animate(trajBookOver(i,:));
            % update gripper to end-effector
            leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
            rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
            leftGripper.model.animate(qOpen);
            rightGripper.model.animate(qOpen);
            
            drawnow();
            pause(0)
        end
    
        crbLogging(robot);
    
        % Move arm to pickup book
        for i = 1:steps2
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
    
        % Take book outside bin
        for i = 1:steps2
            % update CRB
            robot.model.animate(trajBookOut(i,:));
            % update gripper to end-effector
            leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
            rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
            leftGripper.model.animate(qClose);
            rightGripper.model.animate(qClose);
            % move book
            bookPos = robot.model.fkine(robot.model.getpos()).T;
            bookPos(3,4) = bookPos(3,4) - gripperOffset;
            book.model.base = bookPos * trotx(pi);
            book.model.animate(0);
            
            drawnow();
            pause(0)
        end
    
        crbLogging(robot);
    
        % Move arm to middle position
        for i = 1:steps2
            % update CRB
            robot.model.animate(trajMiddle(i,:));
            % update gripper to end-effector
            leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
            rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
            leftGripper.model.animate(qClose);
            rightGripper.model.animate(qClose);
            % move book
            bookPos = robot.model.fkine(robot.model.getpos()).T;
            if i <= (steps2/2)
                bookPos(3,4) = bookPos(3,4) - gripperOffset;
            elseif i <= ((13*steps2)/20)
                bookPos(3,4) = bookPos(3,4) - gripperOffset*0.5;
                bookPos(1,4) = bookPos(1,4) + gripperOffset*0.5;
            else
                bookPos(1,4) = bookPos(1,4) + gripperOffset;
            end
            book.model.base = bookPos * trotx(pi);
            book.model.animate(0);
            
            drawnow();
            pause(0)
        end
    
        crbLogging(robot);
    
    
        % Move arm outside shelf slot
        for i = 1:steps2
            % update CRB
            robot.model.animate(trajShelfOut(i,:));
            % update gripper to end-effector
            leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
            rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
            leftGripper.model.animate(qClose);
            rightGripper.model.animate(qClose);
            % move book
            bookPos = robot.model.fkine(robot.model.getpos()).T;
            if i <= (steps2/2)
                bookPos(1,4) = bookPos(1,4) + gripperOffset;
            elseif i <= ((13*steps2)/20)
                bookPos(1,4) = bookPos(1,4) + gripperOffset*0.5;
                bookPos(2,4) = bookPos(2,4) + gripperOffset*0.5;
            else
                bookPos(2,4) = bookPos(2,4) + gripperOffset;
            end
            book.model.base = bookPos * trotx(pi);
            book.model.animate(0);
            
            drawnow();
            pause(0)
        end
    
        crbLogging(robot);
    
        % Place book on shelf
        for i = 1:steps2
            % update CRB
            robot.model.animate(trajPlace(i,:));
            % update gripper to end-effector
            leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
            rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
            leftGripper.model.animate(qClose);
            rightGripper.model.animate(qClose);
            % move book
            bookPos = robot.model.fkine(robot.model.getpos()).T;
            bookPos(2,4) = bookPos(2,4) + gripperOffset;
            book.model.base = bookPos * trotx(pi);
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
    
        % Move arm outside shelf
        for i = 1:steps2
            % update CRB
            robot.model.animate(trajArmOut(i,:));
            % update gripper to end-effector
            leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
            rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
            leftGripper.model.animate(qOpen);
            rightGripper.model.animate(qOpen);
    
            drawnow();
            pause(0)
        end
            
        crbLogging(robot);
    
        % Move arm back to starting position
        for i = 1:steps2
            % update CRB
            robot.model.animate(trajStart(i,:));
            % update gripper to end-effector
            leftGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(-pi/2);    
            rightGripper.model.base = robot.model.fkine(robot.model.getpos()).T * trotx(pi/2) * trotz(pi);
            leftGripper.model.animate(qOpen);
            rightGripper.model.animate(qOpen);
    
            drawnow();
            pause(0)
        end
    
        crbLogging(robot);
    else
        disp("Collision Detected. Aborting Motion.");
    end
end

function crbLogging(robot)
    XYZ = transl(robot.model.fkine(robot.model.getpos()));
    disp("CRB15000 End-Effector Position: ");
    disp(['X: ', num2str(XYZ(1,1))]);
    disp(['Y: ', num2str(XYZ(1,2))]);
    disp(['Z: ', num2str(XYZ(1,3)), newline]);
end