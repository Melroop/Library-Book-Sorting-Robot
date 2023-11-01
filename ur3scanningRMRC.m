function ur3scanningRMRC(ur3, q0ur3, bookStack, scanner, verts, scannerinitPose)

hold on

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

steps = 250;
bookStartTime = tic;
x1 = [X0; Y0; Z0; 0; 0; 0];  % Define the initial pose for RMRC
x2 = [bookcompletePosition'; 0; 0; 0];  % Define the final pose for RMRC
deltaT = 0.05;

x = zeros(6, steps);
s = lspb(0, 1, steps);
for j = 1:steps
    x(:, j) = x1 * (1 - s(j)) + s(j) * x2;  % Create trajectory in 6D space
end

qMatrix = zeros(steps, 6);
qMatrix(1, :) = q0ur3;

% Calculate the RMRC joint trajectory
for j = 1:steps - 1
    xdot = (x(:, j + 1) - x(:, j)) / deltaT;  % Calculate velocity at discrete time step

    % Calculate the distance between the robot's end-effector and the book position
    distance = norm(bookcompletePosition - x(1:3, j));

    if distance < 1.5 % Define your threshold here
        % Apply Damped Least Squares (DLS) instead of RMRC
        J = ur3.model.jacob0(qMatrix(j, :));  % Get the Jacobian at the current state
        J = J(1:6, :);  % Take all 6 rows (for a 6-DOF robot)

        % Calculate the DLS solution
        lambda = 0.01; % Adjust the damping parameter as needed
        qdot = pinv(J' * J + lambda * eye(6)) * J' * xdot;
    else
        % Continue with RMRC
        J = ur3.model.jacob0(qMatrix(j, :));  % Get the Jacobian at the current state
        J = J(1:6, :);  % Take all 6 rows (for a 6-DOF robot)
        qdot = pinv(J) * xdot;  % Solve velocities via RMRC
    end

    qMatrix(j + 1, :) = qMatrix(j, :) + deltaT * qdot';  % Update next joint state
end

% Iterate through the joint trajectory and update the robot's position
for j = 1:size(qMatrix, 1)
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
end
