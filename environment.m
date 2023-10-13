function environment()

clc;
clf;
clear all; 

hold on

axis ([-2 2 -2 2 -2 2])

xlabel ('X');
ylabel ('Y');
zlabel ('Z');

% Load the PLY model
[f, v, data] = plyread('new bookshelf.ply', 'tri');
% [f, v, data] = plyread('BlueBook.ply', 'tri'); 

% Scale the colours to be 0-to-1 (they are originally 0-to-255)
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

% Calculate the center of the model
center = mean(v);

% Translate the model to the desired coordinates [0, 1, 0]
translation = [0, 0, 0];
v = v - center + translation;

% Plot the PLY model
trisurf(f, v(:,1), v(:,2), v(:,3), 'FaceVertexCData', vertexColours, 'EdgeColor', 'interp', 'EdgeLighting', 'flat');

% Turn on a light and make the axis equal
camlight;

% % Calculate the extents of the model
% xExtents = [min(v(:,1)), max(v(:,1))];
% yExtents = [min(v(:,2)), max(v(:,2))];
% zExtents = [min(v(:,3)), max(v(:,3))];
% 
% % Adjust the X-axis limits to span from -5 to 5
% xCenter = mean(xExtents);
% yCenter = mean(yExtents);
% zCenter = mean(zExtents);
% 
% axis([xCenter - 5, xCenter + 5, yCenter - 5, yCenter + 5, zCenter - 5, zCenter + 5]);

%PlaceObject('book.ply', [1.5,1.5,0])

axis equal;
view(3);
hold off;
end



