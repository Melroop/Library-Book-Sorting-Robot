r = UR3();
q0 = zeros(1,6);
rfkine = r.model.fkine(q0);
rfkineT = rfkine.T;
X = rfkineT(1,4);
Y = rfkineT(2,4);
Z = rfkineT(3,4);
hold on

s = PlaceObject('barcodescanner2.ply', [X,Y,Z]);


book1initPosition = [-0.6, 0.4, 0];
book1initOrientation = eye(3);
book1initPose = [book1initOrientation, book1initPosition'; 0, 0, 0, 1];

book1finalPosition = [-0.2, -0.5, 0];
book1finalOrientation = eye(3);
book1finalPose = [book1finalOrientation, book1finalPosition'; 0, 0, 0, 1];

h_book = PlaceObject('BlueBook.ply', book1initPosition);
h_bookVerts = [get(h_book, 'Vertices'), ones(size(get(h_book, 'Vertices'), 1), 1)];
h_bookVerts(:, 1) = h_bookVerts(:, 1);
set(h_book, 'Vertices', h_bookVerts(:,1:3));

flipMatrix = trotx(pi);
q1 = r.model.ikcon(book1initPose * flipMatrix);
q2 = r.model.ikcon(book1finalPose * flipMatrix);

steps = 100;
trailLine = [];
delete(trailLine); % this line to ensure the trail line from previous brick will be deleted
trailLine = [];

qtraj1 = jtraj(q0, q1, steps);
qtraj2 = jtraj(q1, q2, steps);

for i = 1:size(qtraj1, 1)
    r.model.animate(qtraj1(1, :));
    drawnow();
    pause(0);

    % Update the end effector pose
    rposition = r.model.getpos();
    endEffectorPose = r.model.fkine(rposition).T;

    % Update the trail line for jtraj1
    if isempty(trailLine)
        trailLine = plot3(endEffectorPose(1, 4), endEffectorPose(2, 4), endEffectorPose(3, 4), 'r.'); % Create the trail line
    else
        xData = [get(trailLine, 'XData'), endEffectorPose(1, 4)];
        yData = [get(trailLine, 'YData'), endEffectorPose(2, 4)];
        zData = [get(trailLine, 'ZData'), endEffectorPose(3, 4)];
        set(trailLine, 'XData', xData, 'YData', yData, 'ZData', zData);
    end
end

% Delete the trail line for jtraj1
delete(trailLine);

% Calculate the transformation matrix that maps the initial brick position to the end effector position
bookTransform = endEffectorPose * inv(book1initPose) * transl(0,0,-0.036);  % Calculate the transformation
% Set h_book based on the end effector pose at the end of the first phase
h_bookVerts = [get(h_book, 'Vertices'), ones(size(get(h_book, 'Vertices'), 1), 1)];
newVerts = (h_bookVerts(:, 1:3) * bookTransform(1:3, 1:3)') + bookTransform(1:3, 4)';
set(h_book, 'Vertices', newVerts);

% Create a new trail line for jtraj2
trailLine = [];

for i = 1:size(qtraj2, 1)
    r.model.animate(qtraj2(1, :));
    rposition = r.model.getpos();
    endEffectorPose = r.model.fkine(rposition).T;
    % Calculate the transformation matrix that maps the initial brick position to the end effector position
    bookTransform = endEffectorPose * inv(book1initPose) *transl(0,0,-0.036);  % Calculate the transformation
    newVerts = (h_bookVerts(:, 1:3) * bookTransform(1:3, 1:3)') + bookTransform(1:3, 4)';
    set(h_book, 'Vertices', newVerts);

    % Update the trail line for jtraj2
    if isempty(trailLine)
        trailLine = plot3(endEffectorPose(1, 4), endEffectorPose(2, 4), endEffectorPose(3, 4), 'r.'); % Create the trail line
    else
        xData = [get(trailLine, 'XData'), endEffectorPose(1, 4)];
        yData = [get(trailLine, 'YData'), endEffectorPose(2, 4)];
        zData = [get(trailLine, 'ZData'), endEffectorPose(3, 4)];
        set(trailLine, 'XData', xData, 'YData', yData, 'ZData', zData);
    end
    drawnow();
    pause(0);
end

