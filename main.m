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
            book1Stack = [0.60,0.60,0.74];
            book1Shelf = [0.25,1.05,1.50];
            
            book2Stack = [0.60,0.55,0.74];
            book2Shelf = [0.20,1.05,1.50];

            book3Stack = [0.60,0.50,0.74];
            book3Shelf = [0.25,1.05,2.05];
            
            book1 = Book;
            book1.model.base = transl(book1Stack(1,1),book1Stack(1,2),book1Stack(1,3));
            book1.model.animate(0);

            book2 = Book;
            book2.model.base = transl(book2Stack(1,1),book2Stack(1,2),book2Stack(1,3));
            book2.model.animate(0);

            book3 = Book;
            book3.model.base = transl(book3Stack(1,1),book3Stack(1,2),book3Stack(1,3));
            book3.model.animate(0);
            
            bookPositions = {book1Stack,book2Stack,book3Stack};
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
            

            %% Moving Books
            % Book 1
                % Scan
            scanstatus = true;
            ur3scanning(ur3,q0ur3,scanstatus,bookPositions);

            moveCRB(crb, leftJGP, rightJGP, book1Stack, book1Shelf, book1); % Move Book
            pause(2)

            % % Book 2
                % Scan
            scanstatus = true;
            ur3scanning(ur3,q0ur3,scanstatus,bookPositions);
            moveCRB(crb, leftJGP, rightJGP, book2Stack, book2Shelf, book2); % Move Book
            pause(2)

            % % Book 3
                % Scan
            scanstatus = true;
            ur3scanning(ur3,q0ur3,scanstatus,bookPositions);
            moveCRB(crb, leftJGP, rightJGP, book3Stack, book3Shelf, book3); % Move Book
            pause(2)
            
            disp([newline,'Complete. Press ENTER to exit.'])
            pause();

        end
    end
end
