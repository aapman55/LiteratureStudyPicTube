% Main program
clear all; close all; clc; clear classes

% Import an airfoil
af = Airfoil('naca0012.txt');

% Define piccolotube properties
PT = piccoloTube(   0.2, ... X location
                    0, ... Y location
                    0.05, ... tube Diameter
                    0.5, ...  Hole to hole spacing
                    0.005, ...  Hole diameter
                    [-45,45]); %List with jet angles

mesher = WIPSPiccoloNusseltMesher(af, PT, 50);

% Define cutting angles with origin at piccolotube
upAngle = 120;
downAngle = -120;

mesher.calculate(upAngle, downAngle);

figure
hold on
plot(af.x,af.y)

% plot
scatter(af.unwrappedX, zeros(size(af.unwrappedX)));
axis image

figure
Z = zeros(size(mesher.meshY));
scatter3(mesher.meshX(:),mesher.meshY(:),Z(:));

%% Determine jet impingement locations
% impingeLocsInd = zeros(size(PT.angles));
% 
% % Pre define the array for the node angles
% nodeAngles = zeros(size(af.x));
% 
% % Now calculate the angles of all airfoil points
% for i=1:length(af.x)
%     nodeAngles(i) = fixedReferenceAtand(af.x(i) - PT.Xloc, af.y(i) -PT.Yloc);
% end
% 
% for i = 1 : length(impingeLocsInd)
%     [~, tempNode] = min(abs(nodeAngles - (180 - PT.angles(i))));
%     impingeLocsInd(i) = tempNode;
% end
% 
% impingeLocsX = af.unwrappedX(impingeLocsInd,1);
% impingeLocsY = zeros(size(impingeLocsX));
% % Create radius matrix for each impingement jet
% % Predefine radius matrices
% RadiusMatrix = zeros([size(mesher.meshX),length(impingeLocsX)]);
% 
% % Predefine Nusselt Number matrix
% nusseltMatrix = zeros(size(mesher.meshX));
% 
% for i=1:length(impingeLocsInd)
%     RadiusMatrix(:,:,i) = sqrt((mesher.meshX-impingeLocsX(i)).^2+(mesher.meshY-impingeLocsY(i)).^2);
%     nusseltMatrix = nusseltMatrix + mesher.Nu(RadiusMatrix(:,:,i));
% end

%% Plot on a 3D part
% Wrap airfoil

% wrapX = repmat(af.x',mesher.wingWidthNodes,1);
% wrapZ = repmat(af.y',mesher.wingWidthNodes,1);
% 
% surf(wrapX,mesher.meshY,wrapZ,mesher.nusseltMatrix)
% hold on
% 
% % Create piccolo tube
% [x,y,z] = cylinder(mesher.piccoloTube.tubeDia/2,100);
% 
% % Move center to origin
% geom = Geom();
% [x,y,z] = geom.translate(x,y,z,0,0,-.5);
% 
% % Align z axis with y axis
% [x, y, z] = geom.rotate(x,y,z,1,0,0,90);
% 
% % Move to piccolo tube location
% [x,y,z] = geom.translate(x,y,z,PT.Xloc,PT.Yloc,0);
% 
% % Scale the piccolotube
% [x,y,z] = geom.scale(x,y,z,1,mesher.wingWidth,1);
% 
% surface(x,y,z)
% 
% axis image

mesher.plotNu3D();
