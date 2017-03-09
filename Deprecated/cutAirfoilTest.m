% cutAirfoilTest
clear all; close all; clc;

airfoil = load('naca0012.txt');

% define the input parameters for the airfoil cutter
% piccolo tube location as a fraction of the chord
piccoloX = 0.2;
piccoloY = 0;

% Up and down angle 
upAngle = 45;
downAngle = -45;

% Cut the airfoil
cuttedFoil = cutAirfoil(airfoil, piccoloX, piccoloY, upAngle, downAngle);

% create figure
figure
hold on

% plot the result
plot(cuttedFoil(:,1),cuttedFoil(:,2))

% plot center of the piccolo tube
scatter(piccoloX, piccoloY)

% load geometry utilities
geom = Geom();

% Create horizontal vector and rotate
[upVecX, upVecY] = geom.rotateZ(-.4,0,0,-upAngle);
% Translate to the piccolotube location
[upVecX, upVecY] = geom.translate(upVecX,upVecY,0,piccoloX, piccoloY, 0);

% plot the vector
plot([piccoloX, upVecX],[piccoloY, upVecY])

% Create horizontal vector and rotate
[upVecX, upVecY] = geom.rotateZ(-.4,0,0, -downAngle);
% Translate to the piccolotube location
[upVecX, upVecY] = geom.translate(upVecX,upVecY,0,piccoloX, piccoloY, 0);

% plot the vector
plot([piccoloX, upVecX],[piccoloY, upVecY])
