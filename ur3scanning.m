function ur3scanning(ur3,q0ur3,scanstatus,bookPositions)

hold on

[numRows, numCols] = size(bookPositions);

rfkine = ur3.model.fkine(q0ur3);
rfkineT = rfkine.T;
X0 = rfkineT(1, 4);
Y0 = rfkineT(2, 4);
Z0 = rfkineT(3, 4);
disp('UR3 end effector pose: ');
disp(rfkine);

% Create the scanner object at the initial end effector position
scanner = PlaceObject('barcodescanner5.ply', [X0, Y0, Z0]);
verts = [get(scanner, 'Vertices'), ones(size(get(scanner, 'Vertices'), 1), 1)];
verts(:, 1) = verts(:, 1);
set(scanner, 'Vertices', verts(:, 1:3))
scannerinitOrientation = eye(3);
scannerinitPosition = [X0 Y0 Z0];
scannerinitPose = [scannerinitOrientation, scannerinitPosition'; 0,0,0,1];

% Iterate through all the books, one after another
for i = 1:numCols
    bookinitPosition = bookPositions(i,:);
    bookinitOrientation = eye(3);
    bookinitPose = [bookinitOrientation, bookinitPosition'; 0, 0, 0, 1];

    flipMatrix = trotx(pi);

    % Check if scanstatus is true and it's the current book's turn
    if scanstatus == true
        steps = 150;
        q1 = ur3.model.ikcon(bookinitPose * flipMatrix);
        qtraj1 = jtraj(q0ur3, q1, steps);
        qtraj2 = jtraj(q1, q0ur3, steps);

        for j = 1:size(qtraj1, 1)
            % Update the robot's joint angles
            ur3.model.animate(qtraj1(j, :));
            drawnow();
            pause(0.01);  % Add a small delay to slow down the animation
            % Delete the previous scanner object (if it exists)
            if exist('scanner', 'var') && ishandle(scanner)
                delete(scanner);
            end
            % Update the end effector pose
            rposition = ur3.model.getpos();
            endEffectorPose = ur3.model.fkine(rposition).T;
            disp('UR3 end effector pose: ');
            disp(endEffectorPose);
            % Update the scanner's position
            scanner = PlaceObject('barcodescanner5.ply', [X0, Y0, Z0]);
            scannerTransform = endEffectorPose * inv(scannerinitPose);  % Calculate the transformation
            newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
            set(scanner, 'Vertices', newVerts);
        end

        for k = 1:size(qtraj2, 1)
            % Update the robot's joint angles
            ur3.model.animate(qtraj2(k, :));
            drawnow();
            pause(0.01);  % Add a small delay to slow down the animation

            % Delete the previous scanner object (if it exists)
            if exist('scanner', 'var') && ishandle(scanner)
                delete(scanner);
            end

            % Update the end effector pose
            rposition = ur3.model.getpos();
            endEffectorPose = ur3.model.fkine(rposition).T;

            disp('UR3 end effector pose: ');
            disp(endEffectorPose);

            % Update the scanner's position
            scanner = PlaceObject('barcodescanner5.ply', [X0, Y0, Z0]);
            scannerTransform = endEffectorPose * inv(scannerinitPose);   % Calculate the transformation
            newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
            set(scanner, 'Vertices', newVerts);
        end
        % Set scanstatus to false after scanning
        scanstatus = false;
    end
end