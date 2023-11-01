function ur3scanning(ur3,q0ur3,bookStack,scanner,verts,scannerinitPose)

    hold on;
    [numRows, ~] = size(bookStack);
    
    rfkine = ur3.model.fkine(q0ur3);
    disp('UR3 end effector pose: ');
    disp(rfkine);
    
    qBook1 = deg2rad([5,-163,-66,-45,96,0]);
    
    % Initialize cumulative time
    cumulativeTime = 0;
    
    % Iterate through all the books, one after another
    for i = 1:numRows
        bookinitPosition = bookStack(i,:);
        bookinitPositionoffset = [0,-0.1,0.25];
        bookinitOrientation = eye(3);
        bookinitPose = [bookinitOrientation, (bookinitPosition + bookinitPositionoffset)'; 0, 0, 0, 1];
    
        flipMatrix = trotx(pi);
    
        steps = 95;
        q1 = ur3.model.ikcon(bookinitPose * flipMatrix, qBook1);
        qtraj1 = jtraj(q0ur3, q1, steps);
        qtraj2 = jtraj(q1, q0ur3, steps);
        
        % Collision Check (0 = no collision)
        disp("Checking Collision...");
        collisionIndex = collisionDetection(ur3,qtraj1);
        if collisionIndex == 0
            collisionIndex = collisionDetection(ur3,qtraj2);
        end
        
        % Continue animation if no collision
        if collisionIndex == 0
            % Display the current book index
            disp(['Scanning Book #', num2str(i)]);
            
            % Start timing for the current book
            bookStartTime = tic;
        
            for j = 1:size(qtraj1, 1)
                % Update the robot's joint angles
                ur3.model.animate(qtraj1(j, :));
                drawnow();
                pause(0.01);  % Add a small delay to slow down the animation
        
                % Logging
                rposition = ur3.model.getpos();
                disp('UR3 current joint state: ');
                disp(rposition);
                endEffectorPose = ur3.model.fkine(rposition).T;
                disp('UR3 end effector pose: ');
                disp(endEffectorPose);
        
                % Update the scanner's position
                scannerTransform = endEffectorPose * inv(scannerinitPose);  % Calculate the transformation
                newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
                set(scanner, 'Vertices', newVerts);
            end
        
            for k = 1:size(qtraj2, 1)
                % Update the robot's joint angles
                ur3.model.animate(qtraj2(k, :));
                drawnow();
                pause(0.01);  % Add a small delay to slow down the animation
        
                % Logging
                rposition = ur3.model.getpos();
                disp('UR3 current joint state: ');
                disp(rposition);
                endEffectorPose = ur3.model.fkine(rposition).T;
                disp('UR3 end effector pose: ');
                disp(endEffectorPose);
        
                % Update the scanner's position
                scannerTransform = endEffectorPose * inv(scannerinitPose);   % Calculate the transformation
                newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
                set(scanner, 'Vertices', newVerts);
            end
            
            % End timing for the current book and calculate elapsed time
            bookEndTime = toc(bookStartTime);
            cumulativeTime = cumulativeTime + bookEndTime;
        
            % Display the cumulative time for the current book
            disp(['Cumulative Time for Book #', num2str(i), ': ', num2str(cumulativeTime), ' seconds']);
    
        % Stop animation if collision detected
        else
            disp("Collision Detected. Aborting Motion");
        end
    end
end