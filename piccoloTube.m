classdef piccoloTube
    %piccoloTube
    
    properties
        Xloc,
        Yloc,
        tubeDia, 
        c,                  % hole spacing
        d,                  % Hole diameter
        angles,             % List of jet angles
        zn                  % Hole to plate spacing
    end
    
    methods
        function obj = piccoloTube(Xloc, Yloc, tubeDia, c, d, angles)
           obj.Xloc = Xloc;
           obj.Yloc = Yloc;
           obj.tubeDia = tubeDia;
           obj.c = c;
           obj.d = d; 
           obj.angles = angles;
        end

    end
    
end

