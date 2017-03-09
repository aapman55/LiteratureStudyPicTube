% Main program
clear all; close all; clc; clear classes;

% All units are in SI units. The airfoil can be scaled by specifying the
% chord lentgth. 

% Import an airfoil
af = Airfoil('naca0012.txt');

% Define piccolotube properties
PT = piccoloTube(   0.1, ... X location
                    0, ... Y location
                    0.025, ... tube Diameter
                    0.5, ...  Hole to hole spacing
                    0.005, ...  Hole diameter
                    [-30,30]); %List with jet angles
                
mesher = WIPSPiccoloNusseltMesher(  af,...      % Airfoil object
                                    PT,...      % PiccoloTube object
                                    150);       % How many nodes in the width

% Define cutting angles with origin at piccolotube
upAngle = 120;
downAngle = -120;

% Calculate NusseltNumber grid
mesher.calculate(upAngle, downAngle);

% Visualise Nusselt number distribution and piccolotube configuration
mesher.plotNu3D();

%% Test equal mesh size
[xq, yq, Nuq] = mesher.mapNuToEquiGrid(0.005);

figure
h = pcolor(xq,yq,Nuq);
set(h, 'Edgecolor','none');
axis image

figure
h = pcolor(mesher.meshX,mesher.meshY,mesher.nusseltMatrix);
set(h, 'Edgecolor','none');
axis image