function safetyworkspace()
    clc;
    clf;
    clear all; 
    
%     axis([-2,2,-2,2,-2,2]);
    hold on;
    
    xlabel ('X');
    ylabel ('Y');
    zlabel ('Z');

    % Carpet
    surf([-2,-2;2,2],[-2,2;-2,2],[0.0,0.0;0.0,0.0],'CData',imread('carpet.jpg'),'FaceColor','texturemap');

%     % Book
%     book1 = PlaceObject('Bluebook.ply', [0.65,0.65,0.65]);
%     book1vert = [get(book1,'Vertices'), ones(size(get(book1,'Vertices'),1),1)];
%     % book1vert(:,1) = book1vert(:,1) * 0.5;  % scale X
%     % book1vert(:,2) = book1vert(:,2) * 0.5;  % scale Y
%     % book1vert(:,3) = book1vert(:,3) * 1;  % scale Z
%     % book1vert(:,2) = book1vert(:,1) - 1;  % set X coordinate
%     % book1vert(:,2) = book1vert(:,2) - 1;  % set Y coordinate
%     % book1vert(:,3) = book1vert(:,3) - 1;  % set Z coordinate
%     set(book1,'Vertices',book1vert(:,1:3))
    
    % Trolley
    trolley = PlaceObject('Trolley.ply',[0,0,0]);
    trolleyvert = [get(trolley,'Vertices'), ones(size(get(trolley,'Vertices'),1),1)];
    % trolleyvert(:,1) = trolleyvert(:,1) * 0.1;  % scale X
    % trolleyvert(:,2) = trolleyvert(:,2) * 0.1;  % scale Y
    % trolleyvert(:,3) = trolleyvert(:,3) * 0.1;  % scale Z
    set(trolley,'Vertices',trolleyvert(:,1:3))

    % Bookshelf
    Bookshelf = PlaceObject('Bookshelf.ply', [0,1.2,0]); 
    Bookshelfvert = [get(Bookshelf,'Vertices'), ones(size(get(Bookshelf,'Vertices'),1),1)];
    % trolleyvert(:,1) = trolleyvert(:,1) * 0.1;  % scale X
    % trolleyvert(:,2) = trolleyvert(:,2) * 0.1;  % scale Y
    % trolleyvert(:,3) = trolleyvert(:,3) * 0.1;  % scale Z
    set(Bookshelf,'Vertices',Bookshelfvert(:,1:3))

    % Barrier (rotate with trotz)
    barrier = PlaceObject('Barrier.ply', [0,-1.5,0]); 
    barriervert = [get(barrier,'Vertices'), ones(size(get(barrier,'Vertices'),1),1)];
    % trolleyvert(:,1) = trolleyvert(:,1) * 0.1;  % scale X
    % trolleyvert(:,2) = trolleyvert(:,2) * 0.1;  % scale Y
    % trolleyvert(:,3) = trolleyvert(:,3) * 0.1;  % scale Z
    set(barrier,'Vertices',barriervert(:,1:3))

    % hold off;
end