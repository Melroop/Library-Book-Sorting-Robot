function ur3scanning()
hold on
r = UR3();
q0 = zeros(1, 6);

rfkine = r.model.fkine(q0);
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
book1initPosition = [-0.6, -0.3, 0];
book1initPose = [book1initOrientation, book1initPosition'; 0, 0, 0, 1];

book1finalOrientation = eye(3);
book1finalPosition = [0.4, 0.1, 0];
book1finalPose = [book1finalOrientation, book1finalPosition'; 0, 0, 0, 1];

flipMatrix = trotx(pi);
% flipMatrix = eye(4);

q1 = r.model.ikcon(book1initPose * flipMatrix);
q2 = r.model.ikcon(book1finalPose * flipMatrix);

steps = 200;
qtraj1 = jtraj(q0, q1, steps);
qtraj2 = jtraj(q1, q2, steps);

for i = 1:size(qtraj1, 1)
    % Update the robot's joint angles
    r.model.animate(qtraj1(i, :));
    drawnow();
    pause(0.01);  % Add a small delay to slow down the animation

    % Delete the previous scanner object (if it exists)
    if exist('scanner', 'var') && ishandle(scanner)
        delete(scanner);
    end

    % Update the end effector pose
    rposition = r.model.getpos();
    endEffectorPose = r.model.fkine(rposition).T;

    % Update the scanner's position
    scanner = PlaceObject('barcodescanner4.ply', [X0, Y0, Z0]);
    scannerTransform = endEffectorPose * inv(scannerinitPose);  % Calculate the transformation
    newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
    set(scanner, 'Vertices', newVerts);
end

for i = 1:size(qtraj2, 1)
    % Update the robot's joint angles
    r.model.animate(qtraj2(i, :));
    drawnow();
    pause(0.01);  % Add a small delay to slow down the animation

    % Delete the previous scanner object (if it exists)
    if exist('scanner', 'var') && ishandle(scanner)
        delete(scanner);
    end

    % Update the end effector pose
    rposition = r.model.getpos();
    endEffectorPose = r.model.fkine(rposition).T;

    % Update the scanner's position
    scanner = PlaceObject('barcodescanner4.ply', [X0, Y0, Z0]);
    scannerTransform = endEffectorPose * inv(scannerinitPose);   % Calculate the transformation
    newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
    set(scanner, 'Vertices', newVerts);
end
end