%%
rosshutdown;
%%
rosinit('192.168.27.1'); % If unsure, please ask a tutor
jointStateSubscriber = rossubscriber('joint_states','sensor_msgs/JointState');
%%
jointStateSubscriber = rossubscriber('joint_states','sensor_msgs/JointState');
pause(2); % Pause to give time for a message to appear
%%
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Note the default order of the joints is 3,2,1,4,5,6
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)];

jointStateSubscriber.LatestMessage
jointNames = {'shoulder_pan_joint','shoulder_lift_joint', 'elbow_joint', 'wrist_1_joint', 'wrist_2_joint', 'wrist_3_joint'};
[client, goal] = rosactionclient('/scaled_pos_joint_traj_controller/follow_joint_trajectory');
goal.Trajectory.JointNames = jointNames;
goal.Trajectory.Header.Seq = 1;
goal.Trajectory.Header.Stamp = rostime('Now','system');
goal.GoalTimeTolerance = rosduration(0.05);
bufferSeconds = 1; % This allows for the time taken to send the message. If the network is fast, this could be reduced.
durationSeconds = 5; % This is how many seconds the movement will take

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);     
      
endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');


%my code
nextJointState_123456 = deg2rad ([-92.20,-86.46, -5.39, -166.70, 87.68, 90.22]); 
%nextJointState_123456 = deg2rad ([-98.55,-97.11, -61.90, -105.86, 90.28, 76.93]);
%nextJointState_123456 = deg2rad ([-98.55, -100.37, -72.03, -99.13, 90.92, 79.93]);
%nextJointState_123456 = deg2rad ([-74.96, -92.86, -19.19, -156.18, 88.38, 81.09]);
%nextJointState_123456 = deg2rad ([-26.92, -118.84, -87.74, -124.64, 151.18, 20.34]);
%nextJointState_123456 = deg2rad ([-37.07, -118.84, -74.91, -122.06, 141.25, 32.73]);

% % Define your list of joint configurations
% jointConfigurations = {
%     [-92.20,-86.46, -5.39, -166.70, 87.68, 90.22],
%     [-98.55,-97.11, -61.90, -105.86, 90.28, 76.93],
%     [-98.55, -100.37, -72.03, -99.13, 90.92, 79.93],
%     [-74.96, -92.86, -19.19, -156.18, 88.38, 81.09]),
%     [-26.92, -118.84, -87.74, -124.64, 151.18, 20.34]),
%     [-37.07, -118.84, -74.91, -122.06, 141.25, 32.73]),
% };
% 
% Iterate through joint configurations and send goals
% for i = 1:length(jointConfigurations)
%     nextJointState_123456 = deg2rad(jointConfigurations{i});
%     endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
%     endJointSend.Positions = nextJointState_123456;
%     endJointSend.TimeFromStart = rosduration(durationSeconds);
% 
%     Set the trajectory points in the goal
%     goal.Trajectory.Points = [startJointSend; endJointSend];
% 
%     Set the goal timestamp
%     goal.Trajectory.Header.Stamp = rostime('Now','system') + rosduration(bufferSeconds);
% 
%     Send the goal to the robot
%     sendGoalAndWait(client, goal, rosduration(durationSeconds + bufferSeconds));
% 
%     Update startJointSend for the next iteration
%     startJointSend.Positions = nextJointState_123456;
% end

endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);
goal.Trajectory.Points = [startJointSend; endJointSend];

%%
goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);
sendGoal(client,goal);
