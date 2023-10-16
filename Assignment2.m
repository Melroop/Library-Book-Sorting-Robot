close all;

% ur3 = UR3;
crb = CRB15000;

left = JGPLeft;
right = JGPRight;

% qlim - -0.05 to -0.01
qOpen = -0.05;
qClose = -0.01;

% Move robot base to location on table
% ur3.model.base = transl(0, 0.25, 0);
crb.model.base = transl(0, -0.25, 0);

q0_ur3 = zeros(1,6);
q0_crb = zeros(1,6);

% ur3.model.animate(q0_ur3);
crb.model.animate(q0_crb);

left.model.base = r.model.fkine(crb.model.getpos()).T;
right.model.base = r.model.fkine(crb.model.getpos()).T;

left.model.animate(qOpen);
right.model.animate(qOpen);


