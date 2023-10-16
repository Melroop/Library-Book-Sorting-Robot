%% 41013 Lab Assignment 2
% 13925490 - Edan Anonuevo
% Melroop Nijjar
% Phu Minh Quang Pham


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
            axis([-1,1,-1,1,0,1.5]);     
            hold on;
            
            %% Safe Workspace Environment Setup
            environment();
            
            %% Robot Arms Setup
%             ur3 = UR3;
            crb = CRB15000;        
            
            %% Gripper Setup          
            leftJGP = JGPLeft;
            leftJGP.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(-pi/2);
            
            rightJGP = JGPRight;
            rightJGP.model.base = crb.model.fkine(crb.model.getpos()).T * trotx(pi/2) * trotz(pi);

            %% Moving CRB15000
            position = [0.2,0.8,0.4];

            % moveCRB(robot,leftGripper,rightGripper,position,pose,gripperToggle)
                % pose == 1 > Down, pose == 2 > Forward, pose == 3 > Backward,
                % pose == 4 > Right, pose == 5 > Left
                % gripperToggle == 0 > closing, gripperToggle == 1 > opening
            moveCRB(crb, leftJGP, rightJGP, position, 1, 1);
            
            disp([newline,'Complete. Press ENTER to exit.'])
            pause();

        end
    end
end
