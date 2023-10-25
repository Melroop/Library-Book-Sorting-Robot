function ur3scanning(ur3,q0ur3,bookStack,scanner,verts,scannerinitPose)

hold on

[numRows, numCols] = size(bookStack);

rfkine = ur3.model.fkine(q0ur3);
rfkineT = rfkine.T;
X0 = rfkineT(1, 4);
Y0 = rfkineT(2, 4);
Z0 = rfkineT(3, 4);
disp('UR3 end effector pose: ');
disp(rfkine);

% % Create the scanner object at the initial end effector position
% scanner = PlaceObject('barcodescanner5.ply', [X0, Y0, Z0]);
% verts = [get(scanner, 'Vertices'), ones(size(get(scanner, 'Vertices'), 1), 1)];
% verts(:, 1) = verts(:, 1);
% set(scanner, 'Vertices', verts(:, 1:3))
% scannerinitOrientation = eye(3);
% scannerinitPosition = [X0 Y0 Z0];
% scannerinitPose = [scannerinitOrientation, scannerinitPosition'; 0,0,0,1];

% qBook = deg2rad([50,-130,-80,0,90,0]);
qBook1 = deg2rad([5,-163,-66,-45,96,0]);
% ur3.model.teach(qBook1);
%
% Initialize cumulative time
cumulativeTime = 0;
%
% Iterate through all the books, one after another
for i = 1:numRows
    bookinitPosition = bookStack(i,:);
    bookinitPositionoffset = [0,-0.1,0.25];
    bookinitOrientation = eye(3);
    bookinitPose = [bookinitOrientation, (bookinitPosition + bookinitPositionoffset)'; 0, 0, 0, 1];

    flipMatrix = trotx(pi);

    % Check if scanstatus is true and it's the current book's turn
    % if scanstatus == true
    steps = 95;
    q1 = ur3.model.ikcon(bookinitPose * flipMatrix, qBook1);
    qtraj1 = jtraj(q0ur3, q1, steps);
    qtraj2 = jtraj(q1, q0ur3, steps);
    % Display the current book index
    disp(['Scanning Book #', num2str(i)]);
    
    % Start timing for the current book
    bookStartTime = tic;

    for j = 1:size(qtraj1, 1)
        % Update the robot's joint angles
        ur3.model.animate(qtraj1(j, :));
        drawnow();
        pause(0.01);  % Add a small delay to slow down the animation
        % % Delete the previous scanner object (if it exists)
        % if exist('scanner', 'var') && ishandle(scanner)
        %     delete(scanner);
        % end
        % Update the end effector pose
        rposition = ur3.model.getpos();
        disp('UR3 current joint state: ');
        disp(rposition);
        endEffectorPose = ur3.model.fkine(rposition).T;
        disp('UR3 end effector pose: ');
        disp(endEffectorPose);
        % Update the scanner's position
        % scanner = PlaceObject('barcodescanner5.ply', [X0, Y0, Z0]);
        scannerTransform = endEffectorPose * inv(scannerinitPose);  % Calculate the transformation
        newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
        set(scanner, 'Vertices', newVerts);
    end

    for k = 1:size(qtraj2, 1)
        % Update the robot's joint angles
        ur3.model.animate(qtraj2(k, :));
        drawnow();
        pause(0.01);  % Add a small delay to slow down the animation

        % % Delete the previous scanner object (if it exists)
        % if exist('scanner', 'var') && ishandle(scanner)
        %     delete(scanner);
        % end

        % Update the end effector pose
        rposition = ur3.model.getpos();
        disp('UR3 current joint state: ');
        disp(rposition);
        endEffectorPose = ur3.model.fkine(rposition).T;

        disp('UR3 end effector pose: ');
        disp(endEffectorPose);

        % Update the scanner's position
        % scanner = PlaceObject('barcodescanner5.ply', [X0, Y0, Z0]);
        scannerTransform = endEffectorPose * inv(scannerinitPose);   % Calculate the transformation
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