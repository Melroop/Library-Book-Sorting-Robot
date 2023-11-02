classdef teachGUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        figure1             matlab.ui.Figure
        RobotDropDown       matlab.ui.control.DropDown
        RobotDropDownLabel  matlab.ui.control.Label
        q6Value             matlab.ui.control.NumericEditField
        q5Value             matlab.ui.control.NumericEditField
        q4Value             matlab.ui.control.NumericEditField
        q3Value             matlab.ui.control.NumericEditField
        q2Value             matlab.ui.control.NumericEditField
        q1Value             matlab.ui.control.NumericEditField
        ZSpinner            matlab.ui.control.Spinner
        ZSpinnerLabel       matlab.ui.control.Label
        YSpinner            matlab.ui.control.Spinner
        YSpinnerLabel       matlab.ui.control.Label
        XSpinner            matlab.ui.control.Spinner
        XSpinnerLabel       matlab.ui.control.Label
        q1Slider            matlab.ui.control.Slider
        q1SliderLabel       matlab.ui.control.Label
        q6Slider            matlab.ui.control.Slider
        q6SliderLabel       matlab.ui.control.Label
        q5Slider            matlab.ui.control.Slider
        q5SliderLabel       matlab.ui.control.Label
        q4Slider            matlab.ui.control.Slider
        q4SliderLabel       matlab.ui.control.Label
        q3Slider            matlab.ui.control.Slider
        q3SliderLabel       matlab.ui.control.Label
        q2Slider            matlab.ui.control.Slider
        q2SliderLabel       matlab.ui.control.Label
        plot                matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        % place your class properties here
        modelCRB % Where I will put the loaded puma
        modelUR3 % Where I will put the loaded UR5
        qCRB = [0,0,0,0,0,0];
        qUR3 = deg2rad([0,-90,-90,0,90,0]);
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function init(app, varargin)
            % Code to run once GUI is loaded successfully
            ax = gca;
            axis([-1.5,1.5,-1.5,1.5,0.0,3]);
            hold on; 
            
            % Trolley
            PlaceObject('Trolley.ply',[-0.15,0.0,0]);

            % Make, save and plot some robots            
            app.modelCRB = CRB15000; 
            app.modelCRB.model.base = transl([-0.20, 0.20, 0.95]);
            app.modelCRB.model.animate(app.qCRB);

            app.modelUR3 = UR3;
            app.modelUR3.model.base = transl([0.00, -0.25, 0.95]);
            app.modelUR3.model.animate(app.qUR3);

            % Delete the green floor surface (need to count backwards
            % because once it is deleted the array is compressed)
            for i = size(ax.Children,1):-1:1
                if strcmp(ax.Children(i).Type,'surface')
                    delete(ax.Children(i));
                end
            end
        end

        % Value changed function: q1Slider
        function q1SliderValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueQ1 = app.q1Slider.Value;                                   % get slider value
                app.qCRB(1,1) = deg2rad(valueQ1);                               % update stored qCRB in rads
                app.modelCRB.model.animate(app.qCRB);                           % update model
                app.q1Value.Value = valueQ1;                                    % update textbox
                
                % get XYZ and update spinner values
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            else
                valueQ1 = app.q1Slider.Value;                                   % get slider value
                app.qUR3(1,1) = deg2rad(valueQ1);                               % update stored qCRB in rads
                app.modelUR3.model.animate(app.qUR3);                           % update model
                app.q1Value.Value = valueQ1;                                    % update textbox
                
                % get XYZ and update spinner values
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            end
        end

        % Value changed function: q2Slider
        function q2SliderValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueQ2 = app.q2Slider.Value;                                   % get slider value
                app.qCRB(1,2) = deg2rad(valueQ2);                               % update stored qCRB in rads
                app.modelCRB.model.animate(app.qCRB);                           % update model
                app.q2Value.Value = valueQ2;                                    % update textbox
                
                % get XYZ and update spinner values
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            else
                valueQ2 = app.q2Slider.Value;                                   % get slider value
                app.qUR3(1,2) = deg2rad(valueQ2);                               % update stored qCRB in rads
                app.modelUR3.model.animate(app.qUR3);                           % update model
                app.q2Value.Value = valueQ2;                                    % update textbox
                
                % get XYZ and update spinner values
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            end
        end

        % Value changed function: q3Slider
        function q3SliderValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueQ3 = app.q3Slider.Value;                                   % get slider value
                app.qCRB(1,3) = deg2rad(valueQ3);                               % update stored qCRB in rads
                app.modelCRB.model.animate(app.qCRB);                           % update model
                app.q3Value.Value = valueQ3;                                    % update textbox
                
                % get XYZ and update spinner values
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            else
                valueQ3 = app.q3Slider.Value;                                   % get slider value
                app.qUR3(1,3) = deg2rad(valueQ3);                               % update stored qCRB in rads
                app.modelUR3.model.animate(app.qUR3);                           % update model
                app.q3Value.Value = valueQ3;                                    % update textbox
                
                % get XYZ and update spinner values
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            end
        end

        % Value changed function: q4Slider
        function q4SliderValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"  
                valueQ4 = app.q4Slider.Value;                                   % get slider value
                app.qCRB(1,4) = deg2rad(valueQ4);                               % update stored qCRB in rads
                app.modelCRB.model.animate(app.qCRB);                           % update model
                app.q4Value.Value = valueQ4;                                    % update textbox
                
                % get XYZ and update spinner values
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            else
                valueQ4 = app.q4Slider.Value;                                   % get slider value
                app.qUR3(1,4) = deg2rad(valueQ4);                               % update stored qCRB in rads
                app.modelUR3.model.animate(app.qUR3);                           % update model
                app.q4Value.Value = valueQ4;                                    % update textbox
                
                % get XYZ and update spinner values
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            end
        end

        % Value changed function: q5Slider
        function q5SliderValueChanged(app, event)
           if app.RobotDropDown.Value == "CRB 15000"
                valueQ5 = app.q5Slider.Value;                                   % get slider value
                app.qCRB(1,5) = deg2rad(valueQ5);                               % update stored qCRB in rads
                app.modelCRB.model.animate(app.qCRB);                           % update model
                app.q5Value.Value = valueQ5;                                    % update textbox
                
                % get XYZ and update spinner values
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
           else
                valueQ5 = app.q5Slider.Value;                                   % get slider value
                app.qUR3(1,5) = deg2rad(valueQ5);                               % update stored qCRB in rads
                app.modelUR3.model.animate(app.qUR3);                           % update model
                app.q5Value.Value = valueQ5;                                    % update textbox
                
                % get XYZ and update spinner values
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
           end
        end

        % Value changed function: q6Slider
        function q6SliderValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueQ6 = app.q6Slider.Value;                                   % get slider value
                app.qCRB(1,6) = deg2rad(valueQ6);                               % update stored qCRB in rads
                app.modelCRB.model.animate(app.qCRB);                           % update model
                app.q6Value.Value = valueQ6;                                    % update textbox
                
                % get XYZ and update spinner values
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            else
                valueQ6 = app.q6Slider.Value;                                   % get slider value
                app.qUR3(1,6) = deg2rad(valueQ6);                               % update stored qCRB in rads
                app.modelUR3.model.animate(app.qUR3);                           % update model
                app.q6Value.Value = valueQ6;                                    % update textbox
                
                % get XYZ and update spinner values
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            end
        end

        % Value changed function: XSpinner
        function XSpinnerValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueX = app.XSpinner.Value;                                    % get spinner value
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));               % get old XYZ value from qCRB
                XYZ(1,1) = valueX;                                              % update X
                q1 = app.modelCRB.model.ikcon(transl(XYZ));                     % get new q
                app.modelCRB.model.animate(q1);                                 % update model
                
                % store new qCRB
                app.qCRB = q1;
                
                % update slider values in degrees
                app.q1Slider.Value = rad2deg(q1(1,1));
                app.q2Slider.Value = rad2deg(q1(1,2));
                app.q3Slider.Value = rad2deg(q1(1,3));
                app.q4Slider.Value = rad2deg(q1(1,4));
                app.q5Slider.Value = rad2deg(q1(1,5));
                app.q6Slider.Value = rad2deg(q1(1,6));
                
                % update textbox values in degrees
                app.q1Value.Value = rad2deg(q1(1,1));
                app.q2Value.Value = rad2deg(q1(1,2));
                app.q3Value.Value = rad2deg(q1(1,3));
                app.q4Value.Value = rad2deg(q1(1,4));
                app.q5Value.Value = rad2deg(q1(1,5));
                app.q6Value.Value = rad2deg(q1(1,6));
            else
                valueX = app.XSpinner.Value;                                    % get spinner value
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));               % get old XYZ value from qCRB
                XYZ(1,1) = valueX;                                              % update X
                q1 = app.modelUR3.model.ikcon(transl(XYZ));                     % get new q
                app.modelUR3.model.animate(q1);                                 % update model
                
                % store new qCRB
                app.qUR3 = q1;
                
                % update slider values in degrees
                app.q1Slider.Value = rad2deg(q1(1,1));
                app.q2Slider.Value = rad2deg(q1(1,2));
                app.q3Slider.Value = rad2deg(q1(1,3));
                app.q4Slider.Value = rad2deg(q1(1,4));
                app.q5Slider.Value = rad2deg(q1(1,5));
                app.q6Slider.Value = rad2deg(q1(1,6));
                
                % update textbox values in degrees
                app.q1Value.Value = rad2deg(q1(1,1));
                app.q2Value.Value = rad2deg(q1(1,2));
                app.q3Value.Value = rad2deg(q1(1,3));
                app.q4Value.Value = rad2deg(q1(1,4));
                app.q5Value.Value = rad2deg(q1(1,5));
                app.q6Value.Value = rad2deg(q1(1,6));
            end
        end

        % Value changed function: YSpinner
        function YSpinnerValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueY = app.YSpinner.Value;                                    % get spinner value
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));               % get old XYZ value from qCRB
                XYZ(1,2) = valueY;                                              % update Y
                q1 = app.modelCRB.model.ikcon(transl(XYZ));                     % get new q
                app.modelCRB.model.animate(q1);                                 % update model
                
                % store new qCRB
                app.qCRB = q1;
                
                % update slider values in degrees
                app.q1Slider.Value = rad2deg(q1(1,1));
                app.q2Slider.Value = rad2deg(q1(1,2));
                app.q3Slider.Value = rad2deg(q1(1,3));
                app.q4Slider.Value = rad2deg(q1(1,4));
                app.q5Slider.Value = rad2deg(q1(1,5));
                app.q6Slider.Value = rad2deg(q1(1,6));
    
                % update textbox values in degrees
                app.q1Value.Value = rad2deg(q1(1,1));
                app.q2Value.Value = rad2deg(q1(1,2));
                app.q3Value.Value = rad2deg(q1(1,3));
                app.q4Value.Value = rad2deg(q1(1,4));
                app.q5Value.Value = rad2deg(q1(1,5));
                app.q6Value.Value = rad2deg(q1(1,6));
            else
                valueY = app.YSpinner.Value;                                    % get spinner value
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));               % get old XYZ value from qCRB
                XYZ(1,2) = valueY;                                              % update Y
                q1 = app.modelUR3.model.ikcon(transl(XYZ));                     % get new q
                app.modelUR3.model.animate(q1);                                 % update model
                
                % store new qCRB
                app.qUR3 = q1;
                
                % update slider values in degrees
                app.q1Slider.Value = rad2deg(q1(1,1));
                app.q2Slider.Value = rad2deg(q1(1,2));
                app.q3Slider.Value = rad2deg(q1(1,3));
                app.q4Slider.Value = rad2deg(q1(1,4));
                app.q5Slider.Value = rad2deg(q1(1,5));
                app.q6Slider.Value = rad2deg(q1(1,6));
    
                % update textbox values in degrees
                app.q1Value.Value = rad2deg(q1(1,1));
                app.q2Value.Value = rad2deg(q1(1,2));
                app.q3Value.Value = rad2deg(q1(1,3));
                app.q4Value.Value = rad2deg(q1(1,4));
                app.q5Value.Value = rad2deg(q1(1,5));
                app.q6Value.Value = rad2deg(q1(1,6));
            end
        end

        % Value changed function: ZSpinner
        function ZSpinnerValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueZ = app.ZSpinner.Value;                                    % get spinner value
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));               % get old XYZ value from qCRB
                XYZ(1,3) = valueZ;                                              % update Y
                q1 = app.modelCRB.model.ikcon(transl(XYZ));                     % get new q
                app.modelCRB.model.animate(q1);                                 % update model
                
                % store new qCRB
                app.qCRB = q1;      
                
                % update slider values in degrees
                app.q1Slider.Value = rad2deg(q1(1,1));
                app.q2Slider.Value = rad2deg(q1(1,2));
                app.q3Slider.Value = rad2deg(q1(1,3));
                app.q4Slider.Value = rad2deg(q1(1,4));
                app.q5Slider.Value = rad2deg(q1(1,5));
                app.q6Slider.Value = rad2deg(q1(1,6));
    
                % update textbox values in degrees
                app.q1Value.Value = rad2deg(q1(1,1));
                app.q2Value.Value = rad2deg(q1(1,2));
                app.q3Value.Value = rad2deg(q1(1,3));
                app.q4Value.Value = rad2deg(q1(1,4));
                app.q5Value.Value = rad2deg(q1(1,5));
                app.q6Value.Value = rad2deg(q1(1,6));
            else
                valueZ = app.YSpinner.Value;                                    % get spinner value
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));               % get old XYZ value from qCRB
                XYZ(1,3) = valueZ;                                              % update Y
                q1 = app.modelUR3.model.ikcon(transl(XYZ));                     % get new q
                app.modelUR3.model.animate(q1);                                 % update model
                
                % store new qCRB
                app.qUR3 = q1;
                
                % update slider values in degrees
                app.q1Slider.Value = rad2deg(q1(1,1));
                app.q2Slider.Value = rad2deg(q1(1,2));
                app.q3Slider.Value = rad2deg(q1(1,3));
                app.q4Slider.Value = rad2deg(q1(1,4));
                app.q5Slider.Value = rad2deg(q1(1,5));
                app.q6Slider.Value = rad2deg(q1(1,6));
    
                % update textbox values in degrees
                app.q1Value.Value = rad2deg(q1(1,1));
                app.q2Value.Value = rad2deg(q1(1,2));
                app.q3Value.Value = rad2deg(q1(1,3));
                app.q4Value.Value = rad2deg(q1(1,4));
                app.q5Value.Value = rad2deg(q1(1,5));
                app.q6Value.Value = rad2deg(q1(1,6));
            end
        end

        % Value changed function: q1Value
        function q1ValueValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueQ1 = app.q1Value.Value;                                    % get slider value
                app.qCRB(1,1) = deg2rad(valueQ1);                               % update stored qCRB in rads
                app.modelCRB.model.animate(app.qCRB);                           % update model
                app.q1Slider.Value = rad2deg(app.qCRB(1,1));                    % update slider
    
                % get XYZ and update spinner values
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            else
                valueQ1 = app.q1Value.Value;                                    % get slider value
                app.qUR3(1,1) = deg2rad(valueQ1);                               % update stored qCRB in rads
                app.modelUR3.model.animate(app.qUR3);                           % update model
                app.q1Slider.Value = rad2deg(app.qUR3(1,1));                    % update slider
    
                % get XYZ and update spinner values
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            end
        end

        % Value changed function: q2Value
        function q2ValueValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueQ2 = app.q2Value.Value;                                    % get slider value
                app.qCRB(1,2) = deg2rad(valueQ2);                               % update stored qCRB in rads
                app.modelCRB.model.animate(app.qCRB);                           % update model
                app.q2Slider.Value = rad2deg(app.qCRB(1,2));                    % update slider
    
                % get XYZ and update spinner values
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            else
                valueQ2 = app.q2Value.Value;                                    % get slider value
                app.qUR3(1,2) = deg2rad(valueQ2);                               % update stored qCRB in rads
                app.modelUR3.model.animate(app.qUR3);                           % update model
                app.q2Slider.Value = rad2deg(app.qUR3(1,2));                    % update slider
    
                % get XYZ and update spinner values
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            end
        end

        % Value changed function: q3Value
        function q3ValueValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueQ3 = app.q3Value.Value;                                    % get slider value
                app.qCRB(1,3) = deg2rad(valueQ3);                               % update stored qCRB in rads
                app.modelCRB.model.animate(app.qCRB);                           % update model
                app.q3Slider.Value = rad2deg(app.qCRB(1,3));                    % update slider
    
                % get XYZ and update spinner values
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            else
                valueQ3 = app.q3Value.Value;                                    % get slider value
                app.qUR3(1,3) = deg2rad(valueQ3);                               % update stored qCRB in rads
                app.modelUR3.model.animate(app.qUR3);                           % update model
                app.q3Slider.Value = rad2deg(app.qUR3(1,3));                    % update slider
    
                % get XYZ and update spinner values
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            end
        end

        % Value changed function: q4Value
        function q4ValueValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueQ4 = app.q4Value.Value;                                    % get slider value
                app.qCRB(1,4) = deg2rad(valueQ4);                               % update stored qCRB in rads
                app.modelCRB.model.animate(app.qCRB);                           % update model
                app.q4Slider.Value = rad2deg(app.qCRB(1,4));                    % update slider
    
                % get XYZ and update spinner values
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            else
                valueQ4 = app.q4Value.Value;                                    % get slider value
                app.qUR3(1,4) = deg2rad(valueQ4);                               % update stored qCRB in rads
                app.modelUR3.model.animate(app.qUR3);                           % update model
                app.q4Slider.Value = rad2deg(app.qUR3(1,4));                    % update slider
    
                % get XYZ and update spinner values
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            end
        end

        % Value changed function: q5Value
        function q5ValueValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueQ5 = app.q5Value.Value;                                    % get slider value
                app.qCRB(1,5) = deg2rad(valueQ5);                               % update stored qCRB in rads
                app.modelCRB.model.animate(app.qCRB);                           % update model
                app.q5Slider.Value = rad2deg(app.qCRB(1,5));                    % update slider
    
                % get XYZ and update spinner values
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            else
                valueQ5 = app.q5Value.Value;                                    % get slider value
                app.qUR3(1,5) = deg2rad(valueQ5);                               % update stored qCRB in rads
                app.modelUR3.model.animate(app.qUR3);                           % update model
                app.q5Slider.Value = rad2deg(app.qUR3(1,5));                    % update slider
    
                % get XYZ and update spinner values
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            end
        end

        % Value changed function: q6Value
        function q6ValueValueChanged(app, event)
            if app.RobotDropDown.Value == "CRB 15000"
                valueQ6 = app.q6Value.Value;                                    % get slider value
                app.qCRB(1,6) = deg2rad(valueQ6);                               % update stored qCRB in rads
                app.modelCRB.model.animate(app.qCRB);                           % update model
                app.q6Slider.Value = rad2deg(app.qCRB(1,6));                    % update slider
    
                % get XYZ and update spinner values
                XYZ = transl(app.modelCRB.model.fkine(app.qCRB));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            else
                valueQ6 = app.q6Value.Value;                                    % get slider value
                app.qUR3(1,6) = deg2rad(valueQ6);                               % update stored qCRB in rads
                app.modelUR3.model.animate(app.qUR3);                           % update model
                app.q6Slider.Value = rad2deg(app.qUR3(1,6));                    % update slider
    
                % get XYZ and update spinner values
                XYZ = transl(app.modelUR3.model.fkine(app.qUR3));
                app.XSpinner.Value = XYZ(1,1);
                app.YSpinner.Value = XYZ(1,2);
                app.ZSpinner.Value = XYZ(1,3);
            end
        end

        % Value changed function: RobotDropDown
        function RobotDropDownValueChanged(app, event)
            % update slider limits for each robot
            if app.RobotDropDown.Value == "CRB 15000"
                app.q1Slider.Limits = [-180 180];
                app.q2Slider.Limits = [-180 180];
                app.q3Slider.Limits = [-225 85];
                app.q4Slider.Limits = [-180 180];
                app.q5Slider.Limits = [-180 180];
                app.q6Slider.Limits = [-270 270];
            else
                app.q1Slider.Limits = [-360 360];
                app.q2Slider.Limits = [-360 360];
                app.q3Slider.Limits = [-360 360];
                app.q4Slider.Limits = [-360 360];
                app.q5Slider.Limits = [-360 360];
                app.q6Slider.Limits = [-360 360];
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
            app.plot.Position = [327 88 445 360];

            % Create q2SliderLabel
            app.q2SliderLabel = uilabel(app.figure1);
            app.q2SliderLabel.HorizontalAlignment = 'right';
            app.q2SliderLabel.Position = [57 204 25 22];
            app.q2SliderLabel.Text = 'q2';

            % Create q2Slider
            app.q2Slider = uislider(app.figure1);
            app.q2Slider.Limits = [-180 180];
            app.q2Slider.MajorTicks = [];
            app.q2Slider.ValueChangedFcn = createCallbackFcn(app, @q2SliderValueChanged, true);
            app.q2Slider.MinorTicks = [];
            app.q2Slider.Position = [103 213 150 3];

            % Create q3SliderLabel
            app.q3SliderLabel = uilabel(app.figure1);
            app.q3SliderLabel.HorizontalAlignment = 'right';
            app.q3SliderLabel.Position = [57 175 25 22];
            app.q3SliderLabel.Text = 'q3';

            % Create q3Slider
            app.q3Slider = uislider(app.figure1);
            app.q3Slider.Limits = [-225 85];
            app.q3Slider.MajorTicks = [];
            app.q3Slider.ValueChangedFcn = createCallbackFcn(app, @q3SliderValueChanged, true);
            app.q3Slider.MinorTicks = [];
            app.q3Slider.Position = [103 184 150 3];

            % Create q4SliderLabel
            app.q4SliderLabel = uilabel(app.figure1);
            app.q4SliderLabel.HorizontalAlignment = 'right';
            app.q4SliderLabel.Position = [57 146 25 22];
            app.q4SliderLabel.Text = 'q4';

            % Create q4Slider
            app.q4Slider = uislider(app.figure1);
            app.q4Slider.Limits = [-180 180];
            app.q4Slider.MajorTicks = [];
            app.q4Slider.ValueChangedFcn = createCallbackFcn(app, @q4SliderValueChanged, true);
            app.q4Slider.MinorTicks = [];
            app.q4Slider.Position = [103 155 150 3];

            % Create q5SliderLabel
            app.q5SliderLabel = uilabel(app.figure1);
            app.q5SliderLabel.HorizontalAlignment = 'right';
            app.q5SliderLabel.Position = [57 117 25 22];
            app.q5SliderLabel.Text = 'q5';

            % Create q5Slider
            app.q5Slider = uislider(app.figure1);
            app.q5Slider.Limits = [-180 180];
            app.q5Slider.MajorTicks = [];
            app.q5Slider.ValueChangedFcn = createCallbackFcn(app, @q5SliderValueChanged, true);
            app.q5Slider.MinorTicks = [];
            app.q5Slider.Position = [103 126 150 3];

            % Create q6SliderLabel
            app.q6SliderLabel = uilabel(app.figure1);
            app.q6SliderLabel.HorizontalAlignment = 'right';
            app.q6SliderLabel.Position = [57 88 25 22];
            app.q6SliderLabel.Text = 'q6';

            % Create q6Slider
            app.q6Slider = uislider(app.figure1);
            app.q6Slider.Limits = [-270 270];
            app.q6Slider.MajorTicks = [];
            app.q6Slider.ValueChangedFcn = createCallbackFcn(app, @q6SliderValueChanged, true);
            app.q6Slider.MinorTicks = [];
            app.q6Slider.Position = [103 97 150 3];

            % Create q1SliderLabel
            app.q1SliderLabel = uilabel(app.figure1);
            app.q1SliderLabel.HorizontalAlignment = 'right';
            app.q1SliderLabel.Position = [57 233 25 22];
            app.q1SliderLabel.Text = 'q1';

            % Create q1Slider
            app.q1Slider = uislider(app.figure1);
            app.q1Slider.Limits = [-180 180];
            app.q1Slider.MajorTicks = [];
            app.q1Slider.ValueChangedFcn = createCallbackFcn(app, @q1SliderValueChanged, true);
            app.q1Slider.MinorTicks = [];
            app.q1Slider.Position = [103 242 150 3];

            % Create XSpinnerLabel
            app.XSpinnerLabel = uilabel(app.figure1);
            app.XSpinnerLabel.HorizontalAlignment = 'right';
            app.XSpinnerLabel.Position = [99 365 25 22];
            app.XSpinnerLabel.Text = 'X';

            % Create XSpinner
            app.XSpinner = uispinner(app.figure1);
            app.XSpinner.Step = 0.025;
            app.XSpinner.ValueDisplayFormat = '%.3f';
            app.XSpinner.ValueChangedFcn = createCallbackFcn(app, @XSpinnerValueChanged, true);
            app.XSpinner.Position = [139 365 100 22];

            % Create YSpinnerLabel
            app.YSpinnerLabel = uilabel(app.figure1);
            app.YSpinnerLabel.HorizontalAlignment = 'right';
            app.YSpinnerLabel.Position = [99 333 25 22];
            app.YSpinnerLabel.Text = 'Y';

            % Create YSpinner
            app.YSpinner = uispinner(app.figure1);
            app.YSpinner.Step = 0.025;
            app.YSpinner.ValueDisplayFormat = '%.3f';
            app.YSpinner.ValueChangedFcn = createCallbackFcn(app, @YSpinnerValueChanged, true);
            app.YSpinner.Position = [139 333 100 22];

            % Create ZSpinnerLabel
            app.ZSpinnerLabel = uilabel(app.figure1);
            app.ZSpinnerLabel.HorizontalAlignment = 'right';
            app.ZSpinnerLabel.Position = [99 304 25 22];
            app.ZSpinnerLabel.Text = 'Z';

            % Create ZSpinner
            app.ZSpinner = uispinner(app.figure1);
            app.ZSpinner.Step = 0.025;
            app.ZSpinner.ValueDisplayFormat = '%.3f';
            app.ZSpinner.ValueChangedFcn = createCallbackFcn(app, @ZSpinnerValueChanged, true);
            app.ZSpinner.Position = [139 304 100 22];

            % Create q1Value
            app.q1Value = uieditfield(app.figure1, 'numeric');
            app.q1Value.RoundFractionalValues = 'on';
            app.q1Value.ValueChangedFcn = createCallbackFcn(app, @q1ValueValueChanged, true);
            app.q1Value.Position = [267 233 34 22];

            % Create q2Value
            app.q2Value = uieditfield(app.figure1, 'numeric');
            app.q2Value.RoundFractionalValues = 'on';
            app.q2Value.ValueChangedFcn = createCallbackFcn(app, @q2ValueValueChanged, true);
            app.q2Value.Position = [267 204 34 22];

            % Create q3Value
            app.q3Value = uieditfield(app.figure1, 'numeric');
            app.q3Value.RoundFractionalValues = 'on';
            app.q3Value.ValueChangedFcn = createCallbackFcn(app, @q3ValueValueChanged, true);
            app.q3Value.Position = [267 175 34 22];

            % Create q4Value
            app.q4Value = uieditfield(app.figure1, 'numeric');
            app.q4Value.RoundFractionalValues = 'on';
            app.q4Value.ValueChangedFcn = createCallbackFcn(app, @q4ValueValueChanged, true);
            app.q4Value.Position = [267 146 34 22];

            % Create q5Value
            app.q5Value = uieditfield(app.figure1, 'numeric');
            app.q5Value.RoundFractionalValues = 'on';
            app.q5Value.ValueChangedFcn = createCallbackFcn(app, @q5ValueValueChanged, true);
            app.q5Value.Position = [267 117 34 22];

            % Create q6Value
            app.q6Value = uieditfield(app.figure1, 'numeric');
            app.q6Value.RoundFractionalValues = 'on';
            app.q6Value.ValueChangedFcn = createCallbackFcn(app, @q6ValueValueChanged, true);
            app.q6Value.Position = [267 88 34 22];

            % Create RobotDropDownLabel
            app.RobotDropDownLabel = uilabel(app.figure1);
            app.RobotDropDownLabel.HorizontalAlignment = 'right';
            app.RobotDropDownLabel.Position = [97 429 38 22];
            app.RobotDropDownLabel.Text = 'Robot';

            % Create RobotDropDown
            app.RobotDropDown = uidropdown(app.figure1);
            app.RobotDropDown.Items = {'CRB 15000', 'UR3'};
            app.RobotDropDown.ValueChangedFcn = createCallbackFcn(app, @RobotDropDownValueChanged, true);
            app.RobotDropDown.Position = [150 429 100 22];
            app.RobotDropDown.Value = 'CRB 15000';

            % Show the figure after all components are created
            app.figure1.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = teachGUI(varargin)

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