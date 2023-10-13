r = UR3();
q = zeros(1,6);
rfkine = r.model.fkine(q);
X = rfkine(1:3,4);

hold on

s = PlaceObject('barcodescannercolored.ply', [X,Y,Z]);

