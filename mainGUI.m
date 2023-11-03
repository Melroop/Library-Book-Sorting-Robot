classdef mainGUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        figure1       matlab.ui.Figure
        RESUMEButton  matlab.ui.control.Button
        ESTOPButton   matlab.ui.control.Button
        plot          matlab.ui.control.UIAxes
    end


    properties (Access = private)
        % place your class properties here
        modelCRB % Where I will put the loaded puma
        modelUR3 % Where I will put the loaded UR5
        animationPaused = false; % Flag to pause animation
        eStopActivated = false; % E-Stop state
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function init(app, varargin)
            %% Display Setup
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

            %% Moving Books
            disp('ENVIRONMENT SETUP COMPLETE. Press ENTER to continue.');
            pause();
            
            for i = 1:numBooks
                disp(['SCANNING & MOVING BOOK #', num2str(i), newline]);
                % Check if E-Stop is activated
                if app.eStopActivated
                    % Handle E-Stop action
                    disp('E-Stop is active. Pausing book movement.');
                    pause(1000);
                    break % Skip 
                end
                % Perform animation step
                if ~app.animationPaused
                    ur3scanningRMRC(ur3, q0ur3, bookStack(i,:), scanner, verts, scannerinitPose);
                    moveCRB(crb, leftJGP, rightJGP, bookStack(i,:), bookShelf(i,:), book{i});
                    pause(1);
                end
            end

            %% Forced Collision Detection
            disp('SCANNING & MOVING BOOKS COMPLETE. Press ENTER to continue.');
            pause();
            
            disp(['Simulating forced collision.', newline]);
            forcedCollision(ur3,crb,scanner, leftJGP, rightJGP);

            %% Complete
            disp([newline,'SYSTEM COMPLETE. Press ENTER to exit.'])
            pause();
        end

        % Button pushed function: ESTOPButton
        function ESTOPButtonPushed(app, event)
            % Set the E-Stop state to true
            app.eStopActivated = true;
            % Set the animation pause flag to true
            app.animationPaused = true;
            % You can add code to perform E-Stop actions here if needed
            % For now, you can display a message
            disp('E-Stop activated. System is paused.');
        end

        % Button pushed function: RESUMEButton
        function RESUMEButtonPushed(app, event)
            % If E-Stop is activated, deactivate it
            if app.eStopActivated
                app.eStopActivated = false;
                % Set the animation pause flag to false
                app.animationPaused = false;
                % You can add code to perform recovery actions here if needed
                % For now, you can display a message
                disp('E-Stop deactivated. System can now resume.');
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create figure1 and hide until all components are created
            app.figure1 = uifigure('Visible', 'off');
            app.figure1.Position = [100 100 812 560];
            app.figure1.Name = 'TestRobotPlot_V2';
            app.figure1.HandleVisibility = 'callback';
            app.figure1.Tag = 'figure1';

            % Create plot
            app.plot = uiaxes(app.figure1);
            xlabel(app.plot, 'X')
            ylabel(app.plot, 'Y')
            app.plot.FontSize = 12;
            app.plot.NextPlot = 'replace';
            app.plot.Tag = 'axes1';
            app.plot.Position = [63 80 678 458];

            % Create ESTOPButton
            app.ESTOPButton = uibutton(app.figure1, 'push');
            app.ESTOPButton.ButtonPushedFcn = createCallbackFcn(app, @ESTOPButtonPushed, true);
            app.ESTOPButton.Position = [228 41 100 22];
            app.ESTOPButton.Text = 'ESTOP';

            % Create RESUMEButton
            app.RESUMEButton = uibutton(app.figure1, 'push');
            app.RESUMEButton.ButtonPushedFcn = createCallbackFcn(app, @RESUMEButtonPushed, true);
            app.RESUMEButton.Position = [475 41 100 22];
            app.RESUMEButton.Text = 'RESUME';

            % Show the figure after all components are created
            app.figure1.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = mainGUI(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.figure1)

                % Execute the startup function
                runStartupFcn(app, @(app)init(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.figure1)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.figure1)
        end
    end
end