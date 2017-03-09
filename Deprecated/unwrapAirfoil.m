function [ outputX ] = unwrapAirfoil( coordinates)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Retrieve the x and y coordinates
X = coordinates(:,1);
Y = coordinates(:,2);

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

end

