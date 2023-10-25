%% 41013 Lab Assignment 2
% 13925490 - Edan Anonuevo
% 14250599 - Melroop Nijjar
% - Phu Minh Quang Pham


%% Main file to call all the functions
classdef main < handle

    methods
        function self = main()
            cla;
            self.mainFunction();
        end
    end

    methods (Static)
        function mainFunction()
            %% Display Setup
            clear all;
            set(0,'DefaultFigureWindowStyle','normal')

            % Whole Environment Axis
            axis([-2,2,-2,2,-0.1,3.5]);
            hold on;

            %% Safe Workspace Environment Setup
            safetyworkspace();

            %% Plot Books
            % Books
            book = cell(11);
            for i = 1:11
                book{i} = Book;
            end

            % Book positions
            bookStack = [
                0.60,0.61,0.74;
                0.60,0.55,0.74;
                0.60,0.49,0.74;
                0.60,0.43,0.74;
                0.60,0.37,0.74;
                0.60,0.31,0.74;
                0.60,0.25,0.74;
                0.60,0.19,0.74;
                0.60,0.13,0.74;
                0.60,0.07,0.74;
                0.60,0.01,0.74;
                ];

            bookShelf = [
                0.26,1.05,1.50;
                0.20,1.05,1.50;
                0.14,1.05,1.50;
                0.08,1.05,1.50;
                0.02,1.05,1.50;
                0.26,1.05,2.05;
                0.20,1.05,2.05;
                0.14,1.05,2.05;
                0.08,1.05,2.05;
                0.02,1.05,2.05;
                -0.04,1.05,2.05;
                ];

            % Update book base
            for i = 1:11
                book{i}.model.base = transl(bookStack(i,1),bookStack(i,2),bookStack(i,3));
                book{i}.model.animate(0);
            end

            %% Robot Arms Setup
            % Initialise robot arms
            ur3 = UR3;
            crb = CRB15000;

            % Update robot arms base on table
            ur3.model.base = transl(0.15, 0.15, 0.95);
            crb.model.base = transl(0.15, 0.50, 0.95);

            % Re-plot robot arms
            q0ur3 = deg2rad([0,-90,-90,0,90,0]);
            q0crb = crb.model.getpos();
            ur3.model.animate(q0ur3);
            crb.model.animate(q0crb);

            %             % Teach Test
            % crb.model.teach(q0crb);
            %             ur3.model.teach(q0ur3);

            %% CRB Gripper Setup
            leftJGP = JGPLeft;
            leftJGP.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(-pi/2);

            rightJGP = JGPRight;
            rightJGP.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(pi/2) * trotz(pi);

            leftJGP.model.animate(-0.02);
            rightJGP.model.animate(-0.02);

            %% UR3 Scanner Setup
            rfkine = ur3.model.fkine(q0ur3);
            rfkineT = rfkine.T;
            X0 = rfkineT(1, 4);
            Y0 = rfkineT(2, 4);
            Z0 = rfkineT(3, 4);
            disp('UR3 end effector pose: ');
            disp(rfkine);

            % Create the scanner object at the initial end effector position
            scanner = PlaceObject('barcodescanner5.ply', [X0, Y0, Z0]);
            verts = [get(scanner, 'Vertices'), ones(size(get(scanner, 'Vertices'), 1), 1)];
            verts(:, 1) = verts(:, 1);
            set(scanner, 'Vertices', verts(:, 1:3))
            scannerinitOrientation = eye(3);
            scannerinitPosition = [X0 Y0 Z0];
            scannerinitPose = [scannerinitOrientation, scannerinitPosition'; 0,0,0,1];

            %% Moving Books
            % Book 1
            % Scan
            ur3scanning(ur3,q0ur3,bookStack(1,:),scanner,verts,scannerinitPose);

            % Move Book
            moveCRB(crb, leftJGP, rightJGP, bookStack(1,:), bookShelf(1,:), book{1});
            pause(1)

            % Book 2
            % Scan
            ur3scanning(ur3,q0ur3,bookStack(2,:),scanner,verts,scannerinitPose);
            % Move Book
            moveCRB(crb, leftJGP, rightJGP, bookStack(2,:), bookShelf(2,:), book{2});
            pause(1)

            % Book 3
            % Scan
            ur3scanning(ur3,q0ur3,bookStack(3,:),scanner,verts,scannerinitPose);
            % Move Book
            moveCRB(crb, leftJGP, rightJGP, bookStack(3,:), bookShelf(3,:), book{3});
            pause(1)

            % Book 4
            % Scan
            ur3scanning(ur3,q0ur3,bookStack(4,:),scanner,verts,scannerinitPose);
            % Move Book
            moveCRB(crb, leftJGP, rightJGP, bookStack(4,:), bookShelf(4,:), book{4});
            pause(1)

            % Book 5
            % Scan
            ur3scanning(ur3,q0ur3,bookStack(5,:),scanner,verts,scannerinitPose);
            % Move Book
            moveCRB(crb, leftJGP, rightJGP, bookStack(5,:), bookShelf(5,:), book{5});
            pause(1)

            % Book 6
            % Scan
            ur3scanning(ur3,q0ur3,bookStack(6,:),scanner,verts,scannerinitPose);
            % Move Book
            moveCRB(crb, leftJGP, rightJGP, bookStack(6,:), bookShelf(6,:), book{6});
            pause(1)

            % Book 7
            % Scan
            ur3scanning(ur3,q0ur3,bookStack(7,:),scanner,verts,scannerinitPose);
            % Move Book
            moveCRB(crb, leftJGP, rightJGP, bookStack(7,:), bookShelf(7,:), book{7});
            pause(1)

            % Book 8
            % Scan
            ur3scanning(ur3,q0ur3,bookStack(8,:),scanner,verts,scannerinitPose);
            % Move Book
            moveCRB(crb, leftJGP, rightJGP, bookStack(8,:), bookShelf(8,:), book{8});
            pause(1)

            % Book 9
            % Scan
            ur3scanning(ur3,q0ur3,bookStack(9,:),scanner,verts,scannerinitPose);
            % Move Book
            moveCRB(crb, leftJGP, rightJGP, bookStack(9,:), bookShelf(9,:), book{9});
            pause(1)

            % Book 10
            % Scan
            ur3scanning(ur3,q0ur3,bookStack(10,:),scanner,verts,scannerinitPose);
            % Move Book
            moveCRB(crb, leftJGP, rightJGP, bookStack(10,:), bookShelf(10,:), book{10});
            pause(1)

            % Book 11
            % Scan
            ur3scanning(ur3,q0ur3,bookStack(11,:),scanner,verts,scannerinitPose);
            % Move Book
            moveCRB(crb, leftJGP, rightJGP, bookStack(11,:), bookShelf(11,:), book{11});
            pause(1)

            disp([newline,'Complete. Press ENTER to exit.'])
            pause();

        end
    end
end
