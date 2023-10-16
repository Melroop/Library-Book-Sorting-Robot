close all;

axis([-0.3,0.3,-0.3,0.3,-0.3,0.3]);
hold on;

left = JGPLeft;
right = JGPRight;

% qlim - -0.05 to -0.01
qOpen = -0.05;
qClose = -0.01;

steps1 = 100;    % Arm

qClosing = jtraj(qOpen,qClose,steps1);  % closing matrix left gripper
qOpening = jtraj(qClose,qOpen,steps1);  % opening matrix left gripper

pause(2)

for i = 1:steps1
    left.model.animate(qOpening(i,:));
    right.model.animate(qOpening(i,:));
    drawnow();
    pause(0)
end

pause(2)

for i = 1:steps1
    left.model.animate(qClosing(i,:));
    right.model.animate(qClosing(i,:));
    drawnow();
    pause(0)
end

% q = r.model.getpos();
% r.model.teach(q);
