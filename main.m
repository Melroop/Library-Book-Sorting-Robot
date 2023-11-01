%% 41013 Lab Assignment 2
% 13925490 - Edan Anonuevo
% 14250599 - Melroop Nijjar
% - Phu Minh Quang Pham


%% Main file to call all the functions
classdef main < handle

    properties
        eStopEnabled = false;  % Flag to indicate whether the E-Stop is enabled
        recoveryActionCounter = 0;  % Counter for recovery actions
    end

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
            numBooks = 11;
            book = cell(numBooks);
            for i = 1:numBooks
                book{i} = Book; 
            end

            % Book positions
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

            %% Implement an E-Stop
%             % Simulated E-Stop
%             disp('Press "e" to activate E-Stop. Two "r" presses are required to resume.');
% 
%             while true
%                 if main.self.eStopEnabled
%                     % Perform actions to stop robot motion (e.g., set joint velocities to zero)
%                 else
%                     % Normal operation
%                     % Existing code for robot motion and tasks
%                 end
% 
%                 % Check for E-Stop activation and recovery actions
%                 if kbhit
%                     key = getkey;
%                     if key == 'e' && ~main.self.eStopEnabled
%                         main.self.eStopEnabled = true;  % Activate E-Stop
%                         disp('E-Stop activated. System is paused.');
%                     elseif key == 'r' && main.self.eStopEnabled
%                         main.self.recoveryActionCounter = main.self.recoveryActionCounter + 1;
%                         if main.self.recoveryActionCounter >= 2
%                             main.self.eStopEnabled = false;  % Deactivate E-Stop
%                             main.self.recoveryActionCounter = 0;  % Reset recovery action counter
%                             disp('E-Stop deactivated. System can now resume.');
%                         end
%                     end
%                 end
%             end

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
            for i = 1:numBooks
%                 ur3scanningRMRC(ur3, q0ur3, bookStack, scanner, verts, scannerinitPose);
                ur3scanning(ur3,q0ur3,bookStack(i,:),scanner,verts,scannerinitPose);            % Scan Book
                moveCRB(crb, leftJGP, rightJGP, bookStack(i,:), bookShelf(i,:), book{i});   % Move Book to Shelf
                pause(1)
            end

            %% Forced Collision Detection
            

            disp([newline,'Complete. Press ENTER to exit.'])
            pause();

        end
    end
end
