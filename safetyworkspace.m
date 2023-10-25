function safetyworkspace()
    clc;
    clf;
    clear all; 
    
    % axis([-2,2,-2,2,0,3.5]);
    hold on;
    
    % xlabel ('X');
    % ylabel ('Y');
    % zlabel ('Z');

    % Carpet
    % surf([-2,-2;2,2],[-2,2;-2,2],[0.0,0.0;0.0,0.0],'CData',imread('carpet.jpg'),'FaceColor','texturemap');

    % Library
    library = PlaceObject('Librarybase.ply',[0,0,0]);
    libraryvert = [get(library,'Vertices'), ones(size(get(library,'Vertices'),1),1)];
    % trolleyvert(:,1) = trolleyvert(:,1) * 0.1;  % scale X
    % trolleyvert(:,2) = trolleyvert(:,2) * 0.1;  % scale Y
    % trolleyvert(:,3) = trolleyvert(:,3) * 0.1;  % scale Z
    set(library,'Vertices',libraryvert(:,1:3))

    % % Trolley
    % trolley = PlaceObject('Trolley.ply',[0,0,0]);
    % trolleyvert = [get(trolley,'Vertices'), ones(size(get(trolley,'Vertices'),1),1)];
    % % trolleyvert(:,1) = trolleyvert(:,1) * 0.1;  % scale X
    % % trolleyvert(:,2) = trolleyvert(:,2) * 0.1;  % scale Y
    % % trolleyvert(:,3) = trolleyvert(:,3) * 0.1;  % scale Z
    % set(trolley,'Vertices',trolleyvert(:,1:3))
    
    
    % Barrier
    barrier = PlaceObject('Barriersingle.ply', [0,0,0]); 
    barriervert = [get(barrier,'Vertices'), ones(size(get(barrier,'Vertices'),1),1)];
    % trolleyvert(:,1) = trolleyvert(:,1) * 0.1;  % scale X
    % trolleyvert(:,2) = trolleyvert(:,2) * 0.1;  % scale Y
    % trolleyvert(:,3) = trolleyvert(:,3) * 0.1;  % scale Z
    set(barrier,'Vertices',barriervert(:,1:3))

    % Table Set
    table = PlaceObject('Tables.ply', [0,0,0]); 
    tablevert = [get(table,'Vertices'), ones(size(get(table,'Vertices'),1),1)];
    % trolleyvert(:,1) = trolleyvert(:,1) * 0.1;  % scale X
    % trolleyvert(:,2) = trolleyvert(:,2) * 0.1;  % scale Y
    % trolleyvert(:,3) = trolleyvert(:,3) * 0.1;  % scale Z
    set(table,'Vertices',tablevert(:,1:3))

    % hold off;
end