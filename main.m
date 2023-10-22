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
            % Book positions
            book1Stack = [0.65,0.65,0.7];
            book1Scan = [0.65,0.4,0.8];
            book1Shelf = [0.25,1.05,1.5];
            
            book2Stack = [0,0,0];
            book2Scan = [0,0,0];
            book2Shelf = [0,0,0];

            % book3Stack = [0,0,0];
            % book3Scan = [0,0,0];
            % book3Shelf = [0,0,0];
            
            book1 = Book;
            book1.model.base = transl(book1Stack(1,1),book1Stack(1,2),book1Stack(1,3));
            book1.model.animate(0);

            book2 = Book;
            book2.model.base = transl(book2Stack(1,1),book2Stack(1,2),book2Stack(1,3));
            book2.model.animate(0);

            
            
            %% Robot Arms Setup
            % Initialise robot arms
            ur3 = UR3;
            crb = CRB15000;
            
            % Update robot arms base on table
            ur3.model.base = transl(0, 0.05, 0.95);
            crb.model.base = transl(0.15, 0.5, 0.95);

            % Re-plot robot arms
            q0ur3 = deg2rad([0,-90,-90,0,90,0]);
            q0crb = crb.model.getpos();
            ur3.model.animate(q0ur3);
            crb.model.animate(q0crb);

%             % Teach Test
%             crb.model.teach(q0crb);
%             ur3.model.teach(q0ur3);
            
            %% Gripper Setup          
            leftJGP = JGPLeft;
            leftJGP.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(-pi/2);
            
            rightJGP = JGPRight;
            rightJGP.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(pi/2) * trotz(pi);

            %% Moving CRB15000
            % moveCRB(robot,leftGripper,rightGripper,finalPosition,book,gripperOrientation,gripperToggle,bookToggle)
                % gripperOrientation:
                    % 1 = Down, 2 = Forward, 3 = Backward, 4 = Right, 5 = Left
                % gripperToggle: 
                    % 0 = closing, 1 = opening, 2 = close, 3 = open
                % bookToggle:
                    % 0 = not moving book, 1 = moving book

            % Book 1
            moveCRB(crb, leftJGP, rightJGP, book1Stack, book1, 5, 0, 0);    % Pickup
            pause(2)
            moveCRB(crb, leftJGP, rightJGP, book1Scan, book1, 1, 2, 1);     % Scan
            pause(2)
            moveCRB(crb, leftJGP, rightJGP, book1Shelf, book1, 4, 1, 1);    % Place
            pause(2)

            % Book 2
            
            disp([newline,'Complete. Press ENTER to exit.'])
            pause();

        end
    end
end
