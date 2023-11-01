function ur3scanningRMRC(ur3, q0ur3, bookStack, scanner, verts, scannerinitPose)

    hold on

    [numRows, ~] = size(bookStack);

    rfkine = ur3.model.fkine(q0ur3);
    rfkineT = rfkine.T;
    X0 = rfkineT(1, 4);
    Y0 = rfkineT(2, 4);
    Z0 = rfkineT(3, 4);
    disp('UR3 end effector pose: ');
    disp(rfkine);

    qBook1 = deg2rad([5, -163, -66, -45, 96, 0]);
    cumulativeTime = 0;

    % Iterate through all the books, one after another
    for i = 1:numRows
        bookinitPosition = bookStack(i, :);
        bookinitPositionoffset = [0, -0.1, 0.25];
        bookcompletePosition = bookinitPosition + bookinitPositionoffset;
        bookinitOrientation = eye(3);
        bookinitPose = [bookinitOrientation, bookcompletePosition'; 0, 0, 0, 1];

        flipMatrix = trotx(pi);

        % Check if scanstatus is true and it's the current book's turn
        % if scanstatus == true
        steps = 95;

        x1 = [X0; Y0; Z0; 0; 0; 0];  % Define the initial pose for RMRC
        x2 = [bookcompletePosition'; 0; 0; 0] * flipMatrix;  % Define the final pose for RMRC
        deltaT = 0.05;

        x = zeros(6, steps);
        s = lspb(0, 1, steps);
        for j = 1:steps
            x(:, j) = x1 * (1 - s(j)) + s(j) * x2;  % Create trajectory in 6D space
        end

        qMatrix = nan(steps, 6);
        qMatrix(1, :) = q0ur3;

        % Calculate the RMRC joint trajectory
        for j = 1:steps - 1
            xdot = (x(:, j + 1) - x(:, j)) / deltaT;  % Calculate velocity at discrete time step
            J = ur3.model.jacob0(qMatrix(j, :));  % Get the Jacobian at the current state
            J = J(1:6, :);  % Take all 6 rows (for a 6-DOF robot)
            qdot = pinv(J) * xdot;  % Solve velocities via RMRC
            qMatrix(j + 1, :) = qMatrix(j, :) + deltaT * qdot';  % Update next joint state
        end

        % Iterate through the RMRC joint trajectory and update the robot's position
        for j = 1:size(qMatrix, 1)
            % Update the robot's joint angles
            ur3.model.animate(qMatrix(j, :));
            drawnow();
            pause(0.01);  % Add a small delay to slow down the animation

            % Update the end effector pose
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

        % End timing for the current book and calculate elapsed time
        bookEndTime = toc(bookStartTime);
        cumulativeTime = cumulativeTime + bookEndTime;

        % Display the cumulative time for the current book
        disp(['Cumulative Time for Book #', num2str(i), ': ', num2str(cumulativeTime), ' seconds']);
        % % Set scanstatus to false after scanning
        % scanstatus = false;
    end
end
