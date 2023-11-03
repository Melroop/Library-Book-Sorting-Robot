function lightcurtaindetection ()

    clc
    clf
    clear all; 
    

    safetyworkspace(); 

    % % Define the initial and final positions for the human PLY
    % initial_human_position = [7, 0, 0];
    % final_human_position = [3, 0, 0]; % Change to your desired end position
    % 
    % % Create a PLY object (human model)
    % human = PlaceObject('personMaleCasual.ply'); % Replace 'human.ply' with your human model file
    % humanvert = [get(human,'Vertices'), ones(size(get(human,'Vertices'),1),1)];
    % set(human,'Vertices',humanvert(:,1:3))
    % 
    %         % Animate the movement of the human PLY
    %         for t = 0:0.1:1 % Adjust the step size as needed
    %             current_human_position = (1 - t) * initial_human_position + t * final_human_position;
    % 
    %             % Update the human PLY's position
    %             human.model.base = transl(current_human_position);
    %             human.model.animate(0);
    % 
    %             % Check if the human PLY has reached the final position
    %             if norm(current_human_position - final_human_position) < 0.01 % Adjust the threshold as needed
    %                 disp('Human PLY has reached the final position. Stopping the robots.');
    %                 break; % Stop the robots when the PLY reaches its destination
    %             end
    % 
    %             pause(0.01);
    %         end
    % Define the initial and final positions for the human PLY
    initial_human_position = [7, 0, 0];
    final_human_position = [3, 0, 0]; % Change to your desired end position

    % Number of animation steps
    num_steps = 100; % Adjust as needed

    % Create a PLY object (human model)
    human = GetHumanModel();

    % Define the translation vector
    translation_vector = final_human_position - initial_human_position;

     % Animate the movement of the human PLY
    for t = 0:1/num_steps:1
        current_human_position = initial_human_position + t * translation_vector;

        % Update the human PLY's position by applying the translation
        human.base = transl(current_human_position);

        % Animate the movement by calling the animate method
        human.animate(0);

        % Pause to control animation speed
        pause(0.01);
    end

    disp('Human PLY has reached the final position.');
end
