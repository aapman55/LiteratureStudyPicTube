classdef Airfoil < handle
    %Airfoil. This class contains the x and y coordinates of an airfoil.
    %Also it contains the chord length, so the scaled coordinates can be
    %requested.
    
    properties
        origX,          % X Coordinates (original)
        origY,          % Y coordinates (original)
        chord = 1,      % Set default value to 1
        x,              % Current X coordinates
        y,              % Current Y coordinates
        unwrappedX;     % Unwrapped coordinates on the x-axis. Set after running unwrapAirfoil

    end
    
    methods
        % Constructor method. Needs a file name.
        function obj = Airfoil(filename)
           airfoilData = load(filename);
           obj.x = airfoilData(:,1);
           obj.y = airfoilData(:,2);
           obj.origX = obj.x;
           obj.origY = obj.y;
        end
        
        % Method to set the chord length. This automatically also
        % calculates the scaled.. properties.
        function setChord(obj, chord)
            obj.chord = chord;
            obj.x = obj.origX.*chord;
            obj.y = obj.origY.*chord;
        end
        
        % Method to cut the airfoil.
        function [ coordinatesOut ] = cut( obj, pX, pY, upAngle, downAngle )
            %cutAirfoil Assumes a piccolo tube at location x/c and y/c. Then define the
            %angles for the upper side and lower to to cut. 
            coordinates = [obj.x,obj.y];
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
            
            % put the cut coordinates
            obj.x = coordinatesOut(:,1);
            obj.y = coordinatesOut(:,2);
        end
        
        % Function to unwrap an airfoil. The points will lie on the x axis.
        % The upper side of the airfoil will lie on the negative x axis and
        % the lower side will lie on the positive x axis.
        
        function [ outputX ] = unwrapAirfoil(obj)
            % Retrieve the x and y coordinates
            X = obj.x;
            Y = obj.y;

            % retrieve the leading edge index
            [LEminX , LEIndex] = min(X);

            % Calculate the difference in X and Y
            diffX = X(2:end) - X(1:end-1);
            diffY = Y(2:end) - Y(1:end-1);

            % Calculate the length of each segment
            segmentLengths = sqrt(diffX.^2+diffY.^2);

            % Cumulatively add the length
            outputX = [0;cumsum(segmentLengths)];

            % Recenter the leading edge
            outputX = outputX - (outputX(LEIndex) - LEminX);
            
            % Set the class propertie unwrappedX
            obj.unwrappedX = outputX;
            end
    end
    
end

