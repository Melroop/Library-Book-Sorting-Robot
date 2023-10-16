close all;

% axis([-0.3,0.3,-0.3,0.3,-0.3,0.3]);
hold on;

crb = CRB15000;

left = JGPLeft;
left.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(-pi/2);

right = JGPRight;
right.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(pi/2) * trotz(pi);


% qlim - -0.05 to -0.01
qOpen = -0.05;
qClose = -0.01;

steps1 = 100;    % Arm

qClosing = jtraj(qOpen,qClose,steps1);  % closing matrix left gripper
qOpening = jtraj(qClose,qOpen,steps1);  % opening matrix left gripper

q0 = crb.model.getpos();
q1 = [0,0,pi/2,0,0,pi/4]; 

qTraj = jtraj(q0,q1,steps1); % Current to initial brick position

pause(2)

for i = 1:steps1
    crb.model.animate(qTraj(i,:));                                               
    left.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(-pi/2);    
    right.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(pi/2) * trotz(pi);  
    left.model.animate(qClose);                                                              
    right.model.animate(qClose);                                                             
    drawnow();
    pause(0)
end

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
