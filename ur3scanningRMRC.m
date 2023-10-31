%% Quesiton 3
% Joint Interpolation
clear all
close all
clc
set(0,'DefaultFigureWindowStyle','docked');

% 3.1
steps = 50;
mdl_planar2;                                  % Load 2-Link Planar Robot

% 3.2
T1 = [eye(3) [1.5 1 0]'; zeros(1,3) 1];       % First pose
T2 = [eye(3) [1.5 -1 0]'; zeros(1,3) 1];      % Second pose

% 3.3
M = [1 1 zeros(1,4)];                         % Masking Matrix

% UPDATE: ikine function now has different syntax when entering
% arguments into the function call. The argument must be prefaced by
% its argument name. E.g. Initial Q Guess = 'q0', q & Mask = 'mask', m.
q1 = p2.ikine(T1,'q0', [0 0], 'mask', M);                    % Solve for joint angles
q2 = p2.ikine(T2, 'q0', [0 0], 'mask', M);                    % Solve for joint angles
p2.plot(q1,'trail','r-');
pause(3)
% 3.4
qMatrix = jtraj(q1,q2,steps);
p2.plot(qMatrix,'trail','r-');

% 3.5: Resolved Motion Rate Control
steps = 50;

% 3.6
x1 = [1.5 1]';
x2 = [1.5 -1]';
deltaT = 0.05;                                        % Discrete time step

% 3.7
x = zeros(2,steps);
s = lspb(0,1,steps);                                 % Create interpolation scalar
for i = 1:steps
    x(:,i) = x1*(1-s(i)) + s(i)*x2;                  % Create trajectory in x-y plane
end

% 3.8
qMatrix = nan(steps,2);

% 3.9
% UPDATE: ikine function now has different syntax when entering
% arguments into the function call. The argument must be prefaced by
% its argument name. E.g. Initial Q Guess = 'q0', q & Mask = 'mask', m.
qMatrix(1,:) = p2.ikine(T1, 'q0', [0 0], 'mask', M);                 % Solve for joint angles

% 3.10
for i = 1:steps-1
    xdot = (x(:,i+1) - x(:,i))/deltaT;                             % Calculate velocity at discrete time step
    J = p2.jacob0(qMatrix(i,:));            % Get the Jacobian at the current state
    J = J(1:2,:);                           % Take only first 2 rows
    qdot = inv(J)*xdot;                             % Solve velocitities via RMRC
    qMatrix(i+1,:) =  qMatrix(i,:) + deltaT*qdot';                   % Update next joint state
end

p2.plot(qMatrix,'trail','r-');