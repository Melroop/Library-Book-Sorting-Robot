classdef CRB15000 < RobotBaseClass
    %% GoFa 5 CRB 15000 by ABB

    properties(Access = public)              
        plyFileNameStem = 'CRB15000';
    end
    
    methods
    %% Define robot function 
        function self = CRB15000(baseTr)
			self.CreateModel();
            if nargin < 1			
				baseTr = eye(4);				
            end
            self.model.base = self.model.base.T * baseTr;
            
            self.PlotAndColourRobot();         
        end

    %% Create the robot model
        function CreateModel(self)   
            % Create the UR3 model mounted on a linear rail
            link(1) = Link('d',0.265,'a',0,'alpha',-pi/2,'qlim',deg2rad([-180 180]), 'offset',0);
            link(2) = Link('d',0,'a',0.444,'alpha',0,'qlim', deg2rad([-180 180]), 'offset',-pi/2);
            link(3) = Link('d',0,'a',0.110,'alpha',-pi/2,'qlim', deg2rad([-225 85]), 'offset', 0);
            link(4) = Link('d',0.470,'a',0,'alpha',pi/2,'qlim',deg2rad([-180 180]),'offset', 0);
            link(5) = Link('d',0,'a',0.080,'alpha',-pi/2,'qlim',deg2rad([-180 180]), 'offset',0);
            link(6) = Link('d',0.101,'a',0,'alpha',0,'qlim',deg2rad([-270 270]), 'offset', 0);
            
            % Incorporate joint limits
            link(1).qlim = [-180 180]*pi/180;
            link(2).qlim = [-180 180]*pi/180;
            link(3).qlim = [-225 85]*pi/180;
            link(4).qlim = [-180 180]*pi/180;
            link(5).qlim = [-180 180]*pi/180;
            link(6).qlim = [-270 270]*pi/180;
        
            link(2).offset = -pi/2;
            
            self.model = SerialLink(link,'name',self.name);
        end
     
    end
end