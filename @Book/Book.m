classdef Book < RobotBaseClass
    %% Book model for moving

    properties(Access = public)              
        plyFileNameStem = 'Book';
    end
    
    methods
    %% Define robot Function 
        function self = Book(baseTr)
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
            link(1) = Link('d',0.001,'a',0,'alpha',0,'qlim',deg2rad([0 0]), 'offset',0);
            
            % Incorporate joint limits
            link(1).qlim = [0 0];
            
            self.model = SerialLink(link,'name',self.name);
        end
     
    end
end