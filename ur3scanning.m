r = UR3();
q = zeros(1,6);
rfkine = r.model.fkine(q);


hold on

s = PlaceObject('barcodescannercolored.ply', [X,Y,Z]);
