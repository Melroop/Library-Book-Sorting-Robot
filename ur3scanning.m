function ur3scanning(ur3,book1Stack,q0ur3)
hold on
% r = UR3();
% q0 = zeros(1, 6);

rfkine = ur3.model.fkine(q0ur3);
rfkineT = rfkine.T;
X0 = rfkineT(1, 4);
Y0 = rfkineT(2, 4);
Z0 = rfkineT(3, 4);

% Create the scanner object at the initial end effector position
scanner = PlaceObject('barcodescanner4.ply', [X0, Y0, Z0]);
verts = [get(scanner, 'Vertices'), ones(size(get(scanner, 'Vertices'), 1), 1)];
% verts = [get(scanner, 'Vertices'), ones(size(get(scanner, 'Vertices'), 1), 1)];
verts(:, 1) = verts(:, 1);
set(scanner, 'Vertices', verts(:, 1:3))
scannerinitOrientation = eye(3);
scannerinitPosition = [X0 Y0 Z0];
scannerinitPose = [scannerinitOrientation, scannerinitPosition'; 0,0,0,1];

book1initOrientation = eye(3);
book1initPosition = book1Stack;
book1initPose = [book1initOrientation, book1initPosition'; 0, 0, 0, 1];

flipMatrix = trotx(pi);
% flipMatrix = eye(4);

q1 = ur3.model.ikcon(book1initPose * flipMatrix);
% q2 = r.model.ikcon(book1finalPose * flipMatrix);

steps = 200;
qtraj1 = jtraj(q0ur3, q1, steps);
qtraj2 = jtraj(q1, q0ur3, steps);

for i = 1:size(qtraj1, 1)
    % Update the robot's joint angles
    ur3.model.animate(qtraj1(i, :));
    drawnow();
    pause(0.01);  % Add a small delay to slow down the animation

    % Delete the previous scanner object (if it exists)
    if exist('scanner', 'var') && ishandle(scanner)
        delete(scanner);
    end

    % Update the end effector pose
    rposition = ur3.model.getpos();
    endEffectorPose = ur3.model.fkine(rposition).T;

    % Update the scanner's position
    scanner = PlaceObject('barcodescanner4.ply', [X0, Y0, Z0]);
    scannerTransform = endEffectorPose * inv(scannerinitPose);  % Calculate the transformation
    newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
    set(scanner, 'Vertices', newVerts);
end

for i = 1:size(qtraj2, 1)
    % Update the robot's joint angles
    ur3.model.animate(qtraj2(i, :));
    drawnow();
    pause(0.01);  % Add a small delay to slow down the animation

    % Delete the previous scanner object (if it exists)
    if exist('scanner', 'var') && ishandle(scanner)
        delete(scanner);
    end

    % Update the end effector pose
    rposition = ur3.model.getpos();
    endEffectorPose = ur3.model.fkine(rposition).T;

    % Update the scanner's position
    scanner = PlaceObject('barcodescanner4.ply', [X0, Y0, Z0]);
    scannerTransform = endEffectorPose * inv(scannerinitPose);   % Calculate the transformation
    newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
    set(scanner, 'Vertices', newVerts);
end
end