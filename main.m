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
            % set(0,'DefaultFigureWindowStyle','normal')
            
            % Whole Environment Axis
            axis([-1,1,-1,1,0,1.5]);
            hold on;
            
            %% Safe Workspace Environment Setup
            environment();
            
            %% Robot Arms Setup
            % Initialise robot arms
            ur3 = UR3;
            crb = CRB15000;
            
            % Update robot arms base on table
            ur3.model.base = transl(0, -0.25, 0);
            crb.model.base = transl(0, 0.25, 0);

            % Re-plot robot arms
            q0ur3 = ur3.model.getpos();
            q0crb = crb.model.getpos();
            ur3.model.animate(q0ur3);
            crb.model.animate(q0crb);
            
            %% Gripper Setup          
            leftJGP = JGPLeft;
            leftJGP.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(-pi/2);
            
            rightJGP = JGPRight;
            rightJGP.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(pi/2) * trotz(pi);

            %% Moving CRB15000
            % Book positions
            book1Stack = [-0.2,-0.8,0.4];
            book1Scan = [0.2,0.4,0.3];
            book1Shelf = [0.2,0.8,0.4];
            
            % book2Stack = [0,0,0];
            % book2Scan = [0,0,0];
            % book2Shelf = [0,0,0];

            % book3Stack = [0,0,0];
            % book3Scan = [0,0,0];
            % book3Shelf = [0,0,0];

            % moveCRB(robot,leftGripper,rightGripper,position,gripperOrientation,gripperToggle)
                % gripperOrientation:
                    % 1 = Down, 2 = Forward, 3 = Backward, 4 = Right, 5 = Left
                % gripperToggle: 
                    % 0 = closing, 1 = opening, 2 = close, 3 = open
            moveCRB(crb, leftJGP, rightJGP, book1Stack, 5, 0);
            moveCRB(crb, leftJGP, rightJGP, book1Scan, 1, 2);
            moveCRB(crb, leftJGP, rightJGP, book1Shelf, 4, 1);
            
            disp([newline,'Complete. Press ENTER to exit.'])
            pause();

        end
    end
end
