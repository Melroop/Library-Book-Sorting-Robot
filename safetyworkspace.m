function safetyworkspace()
    clc;
    clf;
    clear all; 
    
    axis([-5,10,-5,5,0,4]);
    hold on;
    
    xlabel ('X');
    ylabel ('Y');
    zlabel ('Z');

    % Carpet
    surf([-3.5,9;-3.5,9],[-4.5,-4.5;4,4],[0.0,0.0;0.0,0.0],'CData',imread('carpet.jpg'),'FaceColor','texturemap');

    % Library
    % https://grabcad.com/library/tag/book
    % https://grabcad.com/library/bookshelf-65
    % https://grabcad.com/library/safety-light-curtain-1
    % Library Walls, Bookshelves, EStop
    
    library = PlaceObject('Librarybase.ply',[0,0,0]);
    libraryvert = [get(library,'Vertices'), ones(size(get(library,'Vertices'),1),1)];
    set(library,'Vertices',libraryvert(:,1:3))
    
    % Barrier
    % https://sketchfab.com/3d-models/vip-rope-barrier-d2cbea78a142464ca701383192a500b1
    barrier = PlaceObject('Barriersingle.ply', [0,0,0]); 
    barriervert = [get(barrier,'Vertices'), ones(size(get(barrier,'Vertices'),1),1)];
    set(barrier,'Vertices',barriervert(:,1:3))

    % Table Set
    % https://www.turbosquid.com/3d-models/old-wooden-chair-lowpoly-3d-model-2028528
    table = PlaceObject('Tables.ply', [0,0,0]); 
    tablevert = [get(table,'Vertices'), ones(size(get(table,'Vertices'),1),1)];
    set(table,'Vertices',tablevert(:,1:3))

    % Trolley
    trolley = PlaceObject('Trolley.ply',[-0.15,0.0,0]);
    trolleyvert = [get(trolley,'Vertices'), ones(size(get(trolley,'Vertices'),1),1)];
    set(trolley,'Vertices',trolleyvert(:,1:3))

    % Light Curtain
    curtain = PlaceObject('Lightcurtain.ply',[0,0,0]);
    curtainvert = [get(curtain,'Vertices'), ones(size(get(curtain,'Vertices'),1),1)];
    set(curtain,'Vertices',curtainvert(:,1:3))

    % hold off;
end