close all;

ur3 = UR3;
crb = CRB15000;

% crb.model.teach();

% Move robot base to location on table
ur3.model.base = transl(2, 2, 0);
crb.model.base = transl(0, 0, 0);

q0_ur3 = ur3.model.getpos();
q0_crb = crb.model.getpos();


