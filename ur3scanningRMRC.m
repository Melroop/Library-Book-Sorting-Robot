function ur3scanningRMRC(ur3, q0ur3, bookStack, scanner, verts, scannerinitPose)
hold on;

rfkine = ur3.model.fkine(q0ur3);
rfkineT = rfkine.T;
X0 = rfkineT(1, 4);
Y0 = rfkineT(2, 4);
Z0 = rfkineT(3, 4);
disp('UR3 end effector pose: ');
disp(rfkine);

qBook1 = deg2rad([5, -163, -66, -45, 96, 0]);

% Initialize cumulative time
cumulativeTime = 0;

% Iterate through all the books, one after another
bookinitPosition = bookStack;
bookinitPositionoffset = [0, -0.1, 0.25];
bookcompletePosition = bookinitPosition + bookinitPositionoffset;
bookinitOrientation = eye(3);
bookinitPose = [bookinitOrientation, bookcompletePosition'; 0, 0, 0, 1];

flipMatrix = trotx(pi);

steps = 210;
bookStartTime = tic;
x1 = [X0; Y0; Z0; 0; 0; 0];  % Define the initial pose for RMRC
x2 = [bookcompletePosition'; -pi/4; pi/4 ; pi/4];  % Define the final pose for RMRC
deltaT = 0.05;

x = zeros(6, steps);
s = lspb(0, 1, steps);
for i = 1:steps
    x(:, i) = x1 * (1 - s(i)) + s(i) * x2;  % Create trajectory in 6D space
end

qMatrix = zeros(steps, 6);
qMatrix(1, :) = q0ur3;
error = nan(6,steps);

% Calculate the RMRC joint trajectory
for i = 1:steps - 1
    xdot = (x(:, i + 1) - x(:, i)) / deltaT;  % Calculate velocity at discrete time step

    % Calculate the distance between the robot's end-effector and the book position
    distance = norm(bookcompletePosition - x(1:3, i));
    J = ur3.model.jacob0(qMatrix(i, :));  % Get the Jacobian at the current state
    J = J(1:6, :);  % Take all 6 rows (for a 6-DOF robot)

    if distance < 1.5 % Define your threshold here
        % Apply Damped Least Squares (DLS) instead of RMRC
        % Calculate the DLS solution
        lambda = 0.1; % Adjust the damping parameter as needed
        qdot = pinv(J' * J + lambda * eye(6)) * J' * xdot;
    else
        qdot = inv(J) * xdot;
    end
    error(:,i) = xdot - J*qdot;
    qMatrix(i+1,:) = qMatrix(i,:) + deltaT * qdot';
end

% Collision Check (0 = no collision)
disp(['CHECKING COLLISION...', newline]);
collisionIndex = collisionDetection(ur3,qMatrix);
% Continue animation if no collision
if collisionIndex == 0
    % Display the current book index
    disp(['No Collision Detected. Scanning Book.', newline]);

    % Iterate through the joint trajectory (scanning) and update the robot's position
    for i = 1:size(qMatrix, 1)
        % Update the robot's joint angles
        ur3.model.animate(qMatrix(i, :));
        drawnow();
        pause(0.01);  % Add a small delay to slow down the animation

        % Get end-effector position
        rposition = ur3.model.getpos();
        endEffectorPose = ur3.model.fkine(rposition).T;

        % Update the scanner's position
        scannerTransform = endEffectorPose * inv(scannerinitPose);  % Calculate the transformation
        newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
        set(scanner, 'Vertices', newVerts);

        % figure(1)
        % set(gcf,'units','normalized','outerposition',[0 0 1 1])
        % ur3.model.plot(qMatrix,'trail','r-')                                               % Animate the robot
        % figure(2)
        % plot(x,'k','LineWidth',1);                                                  % Plot the Manipulability
        % title('Manipulability of 6-Link Planar')
        % ylabel('Manipulability')
        % xlabel('Step')
        % figure(3)
        % plot(error','Linewidth',1)
        % ylabel('Error (m/s)')
        % xlabel('Step')
        % legend('x-velocity','y-velocity');
    end

    % Logging and cumulative time calculation
    rposition = ur3.model.getpos();
    disp('UR3 Current Joint State 1: ');
    disp(rposition);
    endEffectorPose = ur3.model.fkine(rposition).T;
    disp('UR3 End-Effector Pose 1: ');
    disp(endEffectorPose);

    % Iterate through the joint trajectory (returning) and update the robot's position
    for j = size(qMatrix, 1):-1:1
        % Update the robot's joint angles
        ur3.model.animate(qMatrix(j, :));
        drawnow();
        pause(0.01);  % Add a small delay to slow down the animation

        % Get end-effector position
        rposition = ur3.model.getpos();
        endEffectorPose = ur3.model.fkine(rposition).T;

        % Update the scanner's position
        scannerTransform = endEffectorPose * inv(scannerinitPose);  % Calculate the transformation
        newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
        set(scanner, 'Vertices', newVerts);
    end

    % Logging and cumulative time calculation
    rposition = ur3.model.getpos();
    disp('UR3 Current Joint State 1: ');
    disp(rposition);
    endEffectorPose = ur3.model.fkine(rposition).T;
    disp('UR3 End-Effector Pose 1: ');
    disp(endEffectorPose);

    % End timing for the current book and calculate elapsed time
    bookEndTime = toc(bookStartTime);
    cumulativeTime = cumulativeTime + bookEndTime;

    % Display the cumulative time for the current book
    disp(['Cumulative Time for Scanning: ', num2str(cumulativeTime), ' seconds', newline]);
    % Stop animation if collision detected
else
    disp("Collision Detected. Aborting Motion.");
end
end
