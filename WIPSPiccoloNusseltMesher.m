classdef WIPSPiccoloNusseltMesher < handle
    %WIPSPiccoloNusseltMesher. For a given airfoil ,piccolotube configuration and
    %Nusselt number correlation, make a mesh of the airfoil to map the
    %Nusselt numbers on it. Depending on the impingement jets.
    
    properties
        airfoil;            % Airfoil Object
        piccoloTube;        % PiccoloTube Object
        Nu;                 % Nusselt number correlation
        meshX;              % Filled in the method Calculate (2D mesh)
        meshY;              % Filled in the method Calculate (2D mesh)
        nusseltMatrix;      % Filled in the method calculate (2D mesh with Nu values)
        wingWidth;          % The width of the wing, centered around y=0
        wingWidthNodes;     % Amount of nodes the wingWidth is divided in
        zn;                 % List with the distances from the hole to the plate
    end
    
    methods
        % Constructor
        function obj = WIPSPiccoloNusseltMesher(airfoil,        ...
                                                piccoloTube,    ...                         
                                                wingWidthNodes) % Amount of datapoints in the width)
            % Check if the airfoil is an airfoil object
            if (~isa(airfoil,'Airfoil'))
                error('Not an airfoil object!')
            end
            obj.airfoil = airfoil;
            
            % Check if the piccoloTube is a piccoloTube object
            if (~isa(piccoloTube,'piccoloTube'))
                error('Not a piccoloTube object!')
            end
            obj.piccoloTube = piccoloTube;                
              
            % Check if the wingWidthNodes is a valid double
            if (~isa(wingWidthNodes,'double'))
                error('wingWidthNodes is not a valid number!')
            end
            obj.wingWidthNodes = wingWidthNodes;     
            
            % set wing width to the hole spacing
            obj.wingWidth = obj.piccoloTube.c;
            
        end
        
        function calculate( obj,            ...
                            upAngle,        ...
                            downAngle)

            % The upAngle and the Down angle determines the rotational
            % angle used for cutting the airfoil, for the analysis mesh.
            
            % cut the airfoil
            obj.airfoil.cut(obj.piccoloTube.Xloc, ...
                            obj.piccoloTube.Yloc, ...
                            upAngle,...
                            downAngle);
                        
            % Unwrap airfoil
            obj.airfoil.unwrapAirfoil();
            
            % Create 2D mesh
            [obj.meshX, obj.meshY] = meshgrid(  obj.airfoil.unwrappedX, ...                                                
                                                linspace(   -.5*obj.wingWidth, ...
                                                            .5*obj.wingWidth, ...
                                                            obj.wingWidthNodes));
            
            % Define other values (in the future these will be calculated)
            Re = 80000;
%             zn = 0.05;
            
            % Define Nusselt number correlation
            obj.Nu = @(r, zn) Re.^0.76*(24 - abs(zn./obj.piccoloTube.d-7.75))./(533+44.*(r/obj.piccoloTube.d).^1.285);
            
            % predefine the array of impingement location indices
            impingeLocsInd = zeros(size(obj.piccoloTube.angles));

            % Pre define the array for the node angles
            nodeAngles = zeros(size(obj.airfoil.x));

            % Now calculate the angles of all airfoil points
            for i=1:length(obj.airfoil.x)
                nodeAngles(i) = fixedReferenceAtand(obj.airfoil.x(i) - obj.piccoloTube.Xloc, obj.airfoil.y(i) -obj.piccoloTube.Yloc);
            end
            
            % Choose the closest node for every jet
            for i = 1 : length(impingeLocsInd)
                [~, tempNode] = min(abs(nodeAngles - (180 - obj.piccoloTube.angles(i))));
                impingeLocsInd(i) = tempNode;
            end
            
            % Calculate the zn for each impingement jet
            obj.zn = zeros(size(impingeLocsInd));
            
            for i=1:length(obj.zn)
               obj.zn(i) = sqrt((obj.airfoil.x(impingeLocsInd(i)) - obj.piccoloTube.Xloc).^2+...
                            (obj.airfoil.y(impingeLocsInd(i)) - obj.piccoloTube.Yloc).^2)-...
                            (obj.piccoloTube.tubeDia/2);                            
            end
            
            % gather the unwrapped X values of the nodes
            impingeLocsX = obj.airfoil.unwrappedX(impingeLocsInd,1);
            
            % Set the Y locations to 0 (this is a non-staggered case,
            % stagger case not implemented)
            impingeLocsY = zeros(size(impingeLocsX));
            
            % Create radius matrix for each impingement jet
            % Predefine radius matrices
            RadiusMatrix = zeros([size(obj.meshX),length(impingeLocsX)]);

            % Predefine Nusselt Number matrix
            obj.nusseltMatrix = zeros(size(obj.meshX));

            for i=1:length(impingeLocsInd)
                RadiusMatrix(:,:,i) = sqrt((obj.meshX-impingeLocsX(i)).^2+(obj.meshY-impingeLocsY(i)).^2);
                obj.nusseltMatrix = obj.nusseltMatrix + obj.Nu(RadiusMatrix(:,:,i), obj.zn(i));
            end
        end
        
        % Plot in 3D the Nusseltnumber correlation on the airfoil including
        % the piccolotube
        function plotNu3D(obj)
            % Check if the command calculate has been run
            if(sum(size(obj.nusseltMatrix))==0)
               error('Please execute the calculate command first!') 
            end
            
            wrapX = repmat(obj.airfoil.x',obj.wingWidthNodes,1);
            wrapZ = repmat(obj.airfoil.y',obj.wingWidthNodes,1);
            
            %=========================================
            % draw Nusselt umber distribution
            %=========================================
            
            h = surf(wrapX,obj.meshY,wrapZ,obj.nusseltMatrix);
            set(h, 'edgecolor','none');
            hold on
            
            %=========================================
            % draw piccolo tube
            %=========================================
            
            % Create piccolo tube
            [x,y,z] = cylinder(obj.piccoloTube.tubeDia/2,100);

            % Move center to origin
            geom = Geom();
            [x,y,z] = geom.translate(x,y,z,0,0,-.5);

            % Align z axis with y axis
            [x, y, z] = geom.rotate(x,y,z,1,0,0,90);

            % Move to piccolo tube location
            [x,y,z] = geom.translate(x,y,z,obj.piccoloTube.Xloc,0,obj.piccoloTube.Yloc);

            % Scale the piccolotube
            [x,y,z] = geom.scale(x,y,z,1,obj.wingWidth,1);

            surface(x,y,z)
            
            %=========================================
            % draw jets
            %=========================================
            
            for i=1:length(obj.zn)
                % Create cylinder
                [x,y,z] = cylinder(obj.piccoloTube.d/2);
                % scale in length
                [x,y,z] = geom.scale(x,y,z,1,1,obj.zn(i));
                % translate tube radius distance
                [x,y,z] = geom.translate(x,y,z,0,0,obj.piccoloTube.tubeDia/2);
                % rotate to correct angle
                [x,y,z] = geom.rotate(x,y,z,0,-1,0,obj.piccoloTube.angles(i)+90);
                % move to the piccolotube center location
                [x,y,z] = geom.translate(x,y,z,obj.piccoloTube.Xloc,0,obj.piccoloTube.Yloc);
                % Draw the jet
                surface(x,y,z);
            end
            
            axis image
        end
        
        % Map the nusselt number correlation mesh onto a equi grid mesh
        function [Xq, Yq, Nuq] = mapNuToEquiGrid(obj, gridspacing)
            % Check if the command calculate has been run
            if(sum(size(obj.nusseltMatrix))==0)
               error('Please execute the calculate command first!') 
            end
            
            tempX = obj.airfoil.unwrappedX(1):gridspacing:obj.airfoil.unwrappedX(end);
            tempY = -obj.piccoloTube.c/2:gridspacing:obj.piccoloTube.c/2;
            
            [Xq,Yq] = meshgrid(tempX, tempY);
            
            Nuq = interp2(obj.meshX, obj.meshY, obj.nusseltMatrix, Xq, Yq);
        end
    end
    
end

