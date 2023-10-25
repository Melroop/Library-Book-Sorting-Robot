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

    % Library Walls, Bookshelves, EStop
    library = PlaceObject('Librarybase.ply',[0,0,0]);
    libraryvert = [get(library,'Vertices'), ones(size(get(library,'Vertices'),1),1)];
    set(library,'Vertices',libraryvert(:,1:3))
    
    % Barrier
    barrier = PlaceObject('Barriersingle.ply', [0,0,0]); 
    barriervert = [get(barrier,'Vertices'), ones(size(get(barrier,'Vertices'),1),1)];
    set(barrier,'Vertices',barriervert(:,1:3))

    % Table Set
    table = PlaceObject('Tables.ply', [0,0,0]); 
    tablevert = [get(table,'Vertices'), ones(size(get(table,'Vertices'),1),1)];
    set(table,'Vertices',tablevert(:,1:3))

    % Trolley
    trolley = PlaceObject('Trolley.ply',[-0.15,0.0,0]);
    trolleyvert = [get(trolley,'Vertices'), ones(size(get(trolley,'Vertices'),1),1)];
    set(trolley,'Vertices',trolleyvert(:,1:3))

    % hold off;
end