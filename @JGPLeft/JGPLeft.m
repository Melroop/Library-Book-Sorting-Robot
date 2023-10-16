classdef JGPLeft < RobotBaseClass
    %% LinearUR3 UR5 on a non-standard linear rail created by a student

    properties(Access = public)              
        plyFileNameStem = 'JGPLeft';
    end
    
    methods
    %% Define robot Function 
        function self = JGPLeft(baseTr)
			self.CreateModel();
            if nargin < 1			
				baseTr = eye(4);				
            end
            self.model.base = self.model.base.T * baseTr * trotx(-pi/2) * troty(pi/2);   

            self.PlotAndColourRobot(); 
        end

    %% Create the robot model
        function CreateModel(self)   
            % Create the UR3 model mounted on a linear rail
            link(1) = Link([pi     0       0       pi/2    1]); % PRISMATIC Link
            
            % qlim
            link(1).qlim = [0.01 0.05];
            
            self.model = SerialLink(link,'name',self.name);
        end
     
    end
end