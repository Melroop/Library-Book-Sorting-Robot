function collisionIndex = collisionDetection(robot, qMatrix)
%     clf;
%     clear all;
    hold on;
    
    % safetyworkspace();
    % axis([-2,2,-1.3,2,-0.1,3.5]);
    % PlaceObject('Bookshelf.ply',[-0.01,0.8,0]);
    
    % trolley = PlaceObject('Trolley.ply',[-0.15,0.0,0]);
    
    plotOptions.plotFaces = false;
    
    %% Trolley Collision Models
    % Trolley Collision Model 1 (Lower Body)
    centerpnt1 = [0.145,0.01,0.30];
    length1 = 1.23;
    width1 = 0.827;
    height1 = 0.66; 
    [trolleyV1,trolleyF1,trolleyFN1] = Prism(centerpnt1,length1,width1,height1,plotOptions);
    
    % Trolley Collision Model 2 (Upper Body)
    centerpnt2 = [-0.15,0.01,0.77];
    length2 = 0.64;
    width2 = 0.827;
    height2 = 0.355; 
    [trolleyV2,trolleyF2,trolleyFN2] = Prism(centerpnt2,length2,width2,height2,plotOptions);
    
    % Trolley Collision Model 3 (Left Handle)
    centerpnt3 = [-0.343,0.404,0.96];
    length3 = 1.024;
    width3 = 0.039;
    height3 = 0.059; 
    [trolleyV3,trolleyF3,trolleyFN3] = Prism(centerpnt3,length3,width3,height3,plotOptions);
    
    % Trolley Collision Model 4 (Right Handle)
    centerpnt4 = [-0.343,-0.384,0.96];
    length4 = 1.024;
    width4 = 0.039;
    height4 = 0.059; 
    [trolleyV4,trolleyF4,trolleyFN4] = Prism(centerpnt4,length4,width4,height4,plotOptions);
    
    % Trolley Collision Model 5 (Front Handle)
    centerpnt5 = [-0.835,0.01,0.96];
    length5 = 0.039;
    width5 = 0.827;
    height5 = 0.059; 
    [trolleyV5,trolleyF5,trolleyFN5] = Prism(centerpnt5,length5,width5,height5,plotOptions);
    
    %% Bookshelf Collision Models
    
    bookshelfLength1 = 0.1;
    bookshelfLength2 = 0.04;
    bookshelfLength3 = 2.05;
    bookshelfWidth1 = 0.34;
%     bookshelfWidth2 = 0.00;
    bookshelfHeight1 = 3.05; 
    bookshelfHeight2 = 0.04; 
    
    % Bookshelf Columns
    centerpnt1 = [-0.375,0.885,1.525];
    [bookshelfV1,bookshelfF1,bookshelfFN1] = Prism(centerpnt1,bookshelfLength1,bookshelfWidth1,bookshelfHeight1,plotOptions);
    centerpnt2 = [0.33,0.885,1.525];
    [bookshelfV2,bookshelfF2,bookshelfFN2] = Prism(centerpnt2,bookshelfLength1,bookshelfWidth1,bookshelfHeight1,plotOptions);
    centerpnt3 = [-1.045,0.885,1.525];
    [bookshelfV3,bookshelfF3,bookshelfFN3] = Prism(centerpnt3,bookshelfLength2,bookshelfWidth1,bookshelfHeight1,plotOptions);
    centerpnt4 = [1,0.885,1.525];
    [bookshelfV4,bookshelfF4,bookshelfFN4] = Prism(centerpnt4,bookshelfLength2,bookshelfWidth1,bookshelfHeight1,plotOptions);
    % Bookshelf Rows
    centerpnt5 = [-0.025,0.885,2.45];
    [bookshelfV5,bookshelfF5,bookshelfFN5] = Prism(centerpnt5,bookshelfLength3,bookshelfWidth1,bookshelfHeight2,plotOptions);
    centerpnt6 = [-0.025,0.885,1.85];
    [bookshelfV6,bookshelfF6,bookshelfFN6] = Prism(centerpnt6,bookshelfLength3,bookshelfWidth1,bookshelfHeight2,plotOptions);
    centerpnt7 = [-0.025,0.885,1.3];
    [bookshelfV7,bookshelfF7,bookshelfFN7] = Prism(centerpnt7,bookshelfLength3,bookshelfWidth1,bookshelfHeight2,plotOptions);
    centerpnt8 = [-0.025,0.885,0.76];
    [bookshelfV8,bookshelfF8,bookshelfFN8] = Prism(centerpnt8,bookshelfLength3,bookshelfWidth1,bookshelfHeight2,plotOptions);
    centerpnt9 = [-0.025,0.885,0.2];
    [bookshelfV9,bookshelfF9,bookshelfFN9] = Prism(centerpnt9,bookshelfLength3,bookshelfWidth1,bookshelfHeight2,plotOptions);
    
    %% Book Collision Models
    
    bookLength1 = 2.0;
    bookLength2 = 0.22;
    bookLength3 = 0.28;
    bookWidth1 = 0.278;
    bookHeight1 = 0.376;
    
    centerpnt1 = [-0.025,0.89,2.66];
    [bookV1,bookF1,bookFN1] = Prism(centerpnt1,bookLength1,bookWidth1,bookHeight1,plotOptions);
    centerpnt2 = [-0.025,0.89,0.97];
    [bookV2,bookF2,bookFN2] = Prism(centerpnt2,bookLength1,bookWidth1,bookHeight1,plotOptions);
    centerpnt3 = [-0.025,0.89,0.41];
    [bookV3,bookF3,bookFN3] = Prism(centerpnt3,bookLength1,bookWidth1,bookHeight1,plotOptions);
    
    centerpnt4 = [0.125,0.89,2.06];
    [bookV4,bookF4,bookFN4] = Prism(centerpnt4,bookLength3,bookWidth1,bookHeight1,plotOptions);
    centerpnt5 = [-0.205,0.89,1.51];
    [bookV5,bookF5,bookFN5] = Prism(centerpnt5,bookLength2,bookWidth1,bookHeight1,plotOptions);
    centerpnt6 = [-0.578,0.89,2.06];
    [bookV6,bookF6,bookFN6] = Prism(centerpnt6,bookLength3,bookWidth1,bookHeight1,plotOptions);
    centerpnt7 = [0.498,0.89,1.51];
    [bookV7,bookF7,bookFN7] = Prism(centerpnt7,bookLength2,bookWidth1,bookHeight1,plotOptions);
    
    %% Setup
    % crb = CRB15000;
    % 
    % robot.model.base = transl(-0.20, 0.20, 0.95);
    % q0crb = robot.model.getpos();
    % robot.model.animate(q0crb);
    % 
    % qBook = [-0.1995, 0.8009, 0.4641, -0.2992, 0.3491, 0];
    % qCollision1 = [0, 2.5681, -2.7676, -0.2992, 0.3491, 0];
    % qCollision2 = [0.1995, 0.8477, 1.0327, -0.2992, 0.3491, 0];
    % qCollision3 = [-2.3188, 1.4461, -0.4273, -0.2743, 0.4987, -0.8602];
    % qShelf = [1.5708, -0.3491, 0.8727, 0, -0.5236, 0];
    
    % robot.model.teach(qCollision1);
    
    % qMatrix = jtraj(qBook,qShelf,50);
    
    % for i = 1:50
    %     robot.model.animate(qMatrix(i,:));
    %     pause(0)
    % end
    
    %% Collision Check
    % 0 = no collision
    
    % Trolley Check
    if IsCollision(robot.model,qMatrix,trolleyF1,trolleyV1,trolleyFN1)
        collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,trolleyF2,trolleyV2,trolleyFN2)
        collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,trolleyF3,trolleyV3,trolleyFN3)
        collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,trolleyF4,trolleyV4,trolleyFN4)
        collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,trolleyF5,trolleyV5,trolleyFN5)
        collisionIndex = 1;
    % Bookshelf Check
    elseif IsCollision(robot.model,qMatrix,bookshelfF1,bookshelfV1,bookshelfFN1)
        collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookshelfF2,bookshelfV2,bookshelfFN2)
        collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookshelfF3,bookshelfV3,bookshelfFN3)
    collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookshelfF4,bookshelfV4,bookshelfFN4)
    collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookshelfF5,bookshelfV5,bookshelfFN5)
    collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookshelfF6,bookshelfV6,bookshelfFN6)
    collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookshelfF7,bookshelfV7,bookshelfFN7)
    collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookshelfF8,bookshelfV8,bookshelfFN8)
    collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookshelfF9,bookshelfV9,bookshelfFN9)
    collisionIndex = 1;
    % Book Check
    elseif IsCollision(robot.model,qMatrix,bookF1,bookV1,bookFN1)
        collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookF2,bookV2,bookFN2)
        collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookF3,bookV3,bookFN3)
        collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookF4,bookV4,bookFN4)
        collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookF5,bookV5,bookFN5)
        collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookF6,bookV6,bookFN6)
        collisionIndex = 1;
    elseif IsCollision(robot.model,qMatrix,bookF7,bookV7,bookFN7)
        collisionIndex = 1;
    % Pass
    else
        collisionIndex = 0;
    end 
    
    %% Continue Animation
%     if collisionIndex == 0
%         disp('ALL PASS. No collision found');
%     %     for i = 1:50
%     %         robot.model.animate(qMatrix(i,:));
%     %         pause(0)
%     %     end
%     else
%         disp('Collision detected!!');
%     end
end