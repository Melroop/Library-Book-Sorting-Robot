function ur3scanning()
hold on
r = UR3();
q0 = zeros(1, 6);

rfkine = r.model.fkine(q0);
rfkineT = rfkine.T;
X = rfkineT(1, 4);
Y = rfkineT(2, 4);
Z = rfkineT(3, 4);

% Create the scanner object at the initial end effector position
scanner = PlaceObject('barcodescanner3.ply', [X, Y, Z]);
verts = [get(scanner, 'Vertices'), ones(size(get(scanner, 'Vertices'), 1), 1)] * trotz(pi/2);
verts(:, 1) = verts(:, 1);
set(scanner, 'Vertices', verts(:, 1:3))

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
    X1 = endEffectorPose(1, 4);
    Y1 = endEffectorPose(2, 4);
    Z1 = endEffectorPose(3, 4);

    % Update the scanner's position
    scanner = PlaceObject('barcodescanner3.ply', [X1, Y1, Z1]);
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
    X2 = endEffectorPose(1, 4);
    Y2 = endEffectorPose(2, 4);
    Z2 = endEffectorPose(3, 4);

    % Update the scanner's position
    scanner = PlaceObject('barcodescanner3.ply', [X2, Y2, Z2]);
end
end