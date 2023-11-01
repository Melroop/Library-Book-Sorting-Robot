function forcedCollision(robot1,robot2)
    
    qUR3Start = robot1.model.getpos();
    qCRBStart = robot2.model.getpos();

    qUR3Collision = [-2.0445, -2.6429, -2.4933, 0, 1.5708, 0];
    qCRBCollision = [1.8949, 0.5735, 0, 0, 0, 0];

    trajUR3 = jtraj(qUR3Start,qUR3Collision,50);
    trajCRB = jtraj(qCRBStart,qCRBCollision,50);

    collisionIndexUR3 = collisionDetection(robot1,trajUR3);
    collisionIndexCRB = collisionDetection(robot2,trajCRB);

    if collisionIndexUR3 == 1
        disp('UR3 Collision Detected. Aborting Motion')
    else
        disp('No UR3 Collision Detected. Continuing Motion')
    end

    if collisionIndexCRB == 1
        disp('CRB Collision Detected. Aborting Motion')
    else
        disp('No CRB Collision Detected. Continuing Motion')
    end
end