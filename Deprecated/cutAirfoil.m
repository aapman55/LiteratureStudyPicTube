function [ coordinatesOut ] = cutAirfoil( coordinates, pX, pY, upAngle, downAngle )
%cutAirfoil Assumes a piccolo tube at location x/c and y/c. Then define the
%angles for the upper side and lower to to cut. 

% Copy the input coordinates to the output coordinates
coordinatesOut = coordinates;

% Translate all coordinate points so that the center of the piccolo tube is
% at the origin.
coordinatesOut(:,1) = coordinates(:,1) - pX;
coordinatesOut(:,2) = coordinates(:,2) - pY;

% Pre define the array for the node angles
nodeAngles = zeros(size(coordinates(:,1)));

% Now calculate the angles of all airfoil points
for i=1:length(coordinates(:,1))
    nodeAngles(i) = fixedReferenceAtand(coordinatesOut(i,1), coordinatesOut(i,2));
end

% The angle for the up and down angle are defined clockwise positve. The
% reference for the angle to be zero is the point on the horizontal on the
% piccolotube closest to the leadign edge. The real Angle has reference
% angle 0 for unit vector (1,0) and going counterclockwise positive.
realUpAngle = 180 - upAngle;
realDownAngle = 180 - downAngle;

% Filter out the nodes that are within those bounds
nodeIndices = nodeAngles >= realUpAngle;
nodeIndices = nodeIndices.* (nodeAngles <= realDownAngle);
nodeIndices = nodeIndices == 1;

% Select the coordinate points that are within the angle bounds
coordinatesOut = coordinates(nodeIndices,:);
end

