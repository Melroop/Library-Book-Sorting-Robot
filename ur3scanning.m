r = UR3();
q = zeros(1,6);
rfkine = r.model.fkine(q);
rfkineT = rfkine.T;
X = rfkineT(1,4);
Y = rfkineT(2,4);
Z = rfkineT(3,4);
hold on

s = PlaceObject('barcodescanner2.ply', [X,Y,Z]);

