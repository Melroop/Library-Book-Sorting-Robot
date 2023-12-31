%% 41013 Lab Assignment 2 - Library Book Sorting Robot
% 13925490 - Edan Anonuevo
% 14250599 - Melroop Nijjar
% 14231688 - Phu Minh Quang Pham

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
            clf;
            clc;
            set(0,'DefaultFigureWindowStyle','normal')

            % Whole Environment Axis
            axis([-5,10,-5,5,0,4]);
            hold on;

            %% Safe Workspace Environment Setup
            safetyworkspace();

            %% Plot Books
            % Books
            numBooks = 11;
            book = cell(numBooks);
            for i = 1:numBooks
                book{i} = Book; 
            end
            % Book initial positions
            bookStack = [
                0.45,0.30,0.74;
                0.45,0.24,0.74;
                0.45,0.18,0.74;
                0.45,0.12,0.74;
                0.45,0.06,0.74;
                0.45,0.00,0.74;
                0.45,-0.06,0.74;
                0.45,-0.12,0.74;
                0.45,-0.18,0.74;
                0.45,-0.24,0.74;
                0.45,-0.30,0.74;
                ];
            % Book final positions
            bookShelf = [
                0.24,0.75,1.51;
                0.18,0.75,1.51;
                0.12,0.75,1.51;
                0.06,0.75,1.51;
                0.00,0.75,1.51;
                -0.06,0.75,1.51;
                -0.06,0.75,2.06;
                -0.12,0.75,2.06;
                -0.18,0.75,2.06;
                -0.24,0.75,2.06;
                -0.30,0.75,2.05;
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
            ur3.model.base = transl(0.00, -0.25, 0.95);
            crb.model.base = transl(-0.20, 0.20, 0.95);
            % Re-plot robot arms
            q0ur3 = deg2rad([0,-90,-90,0,90,0]);
            q0crb = crb.model.getpos();
            ur3.model.animate(q0ur3);
            crb.model.animate(q0crb);

            %% JGP-P 80-1 Gripper Setup for CRB15000
            % Initialise gripper arms
            leftJGP = JGPLeft;
            rightJGP = JGPRight;
            % Update gripper arms base to CRB15000
            leftJGP.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(-pi/2);
            rightJGP.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(pi/2) * trotz(pi);
            % Re-plot gripper arms
            leftJGP.model.animate(-0.02);
            rightJGP.model.animate(-0.02);

            %% UR3 Scanner Setup
            % Get UR3 end-effector position
            rfkineT = ur3.model.fkine(q0ur3).T;
            % Create the scanner object at the initial end-effector position
            scanner = PlaceObject('barcodescanner5.ply', [rfkineT(1,4), rfkineT(2,4), rfkineT(3,4)]);
            verts = [get(scanner, 'Vertices'), ones(size(get(scanner, 'Vertices'), 1), 1)];
            scannerinitOrientation = eye(3);
            scannerinitPosition = [rfkineT(1,4) rfkineT(2,4) rfkineT(3,4)];
            scannerinitPose = [scannerinitOrientation, scannerinitPosition'; 0,0,0,1];
            scannerTransform = rfkineT * inv(scannerinitPose);  % Calculate the transformation
            newVerts = (verts(:, 1:3) * scannerTransform(1:3, 1:3)') + scannerTransform(1:3, 4)';
            set(scanner, 'Vertices', newVerts);
            
            %% Moving Books
            disp('ENVIRONMENT SETUP COMPLETE. Press ENTER to continue.');
            pause();
            
            for i = 1:numBooks
                disp(['SCANNING & MOVING BOOK #', num2str(i), newline]);
                % Scan Book
                ur3scanningRMRC(ur3, q0ur3, bookStack(i,:), scanner, verts, scannerinitPose);
                % Move Book
                moveCRB(crb, leftJGP, rightJGP, bookStack(i,:), bookShelf(i,:), book{i});
                pause(1)
            end

            %% Forced Collision Detection
            disp('SCANNING & MOVING BOOKS COMPLETE. Press ENTER to continue.');
            pause();
            
            disp(['Simulating Forced Collision.', newline]);
            forcedCollision(ur3,crb,scanner,leftJGP,rightJGP);
            
            %% Complete
            disp([newline,'SYSTEM COMPLETE. Press ENTER to exit.'])
            pause();

        end
    end
end
