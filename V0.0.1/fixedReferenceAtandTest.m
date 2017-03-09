%fixedReferenceAtandTest
clear all; close all; clc;

% Define verification precision
precision = 0.0000001;

% Create a vector with equally spaced angles
angle = 0:359;

% Turn angles into xy coordinates of a unit vector
x = cosd(angle);
y = sind(angle);

% Predefine size of the result vector
calcAngle = zeros(size(angle));

% For every unit vector calculate the corresponding angle
for i=1:length(angle)
    calcAngle(i) = fixedReferenceAtand(x(i) , y(i));
end

% plot the results
plot(calcAngle)

% Check if the input angles are equal to the calculated angles
if (sum(abs(calcAngle-angle) < precision) == 360)
    disp(['Validated with precision: ',num2str(precision)]);
else
    disp(['Validation failed! Amount failed: ',num2str(360 - sum(abs(calcAngle-angle) < precision))]);
end