function handle = Geom()
%Geom Geometry utilities. Includes functions to rotate, translate and
%scale.
% Written by Zhi-Li Liu
%
% Note : not finished yet
%

handle.translate = @translate;
handle.scale = @scale;
handle.rotateX = @rotateX;
handle.rotateY = @rotateY;
handle.rotateZ = @rotateZ;
handle.rotate = @rotate;
end

function [x,y,z] = translate(x,y,z,tx,ty,tz)
x = x+tx;
y =  y+ty;
z = z+tz;
end

function [x,y,z] = scale(x,y,z,nx,ny,nz)
    x = nx*x;
    y = ny*y;
    z = nz*z;
end

function [X,Y,Z] = rotateX(x,y,z,deg)
    X = x;
    Y = cosd(deg)*y - sind(deg)*z;
    Z = sind(deg)*y + cosd(deg)*z;
end

function [X,Y,Z] = rotateY(x,y,z,deg)
    X = cosd(deg)*x + sind(deg)*z;
    Y = y;
    Z = -sind(deg)*x + cosd(deg)*z;
end

function [X,Y,Z] = rotateZ(x,y,z,deg)
    X = cosd(deg)*x - sind(deg)*y;
    Y = sind(deg)*x + cosd(deg)*y;
    Z = z;
end

function [X,Y,Z] = rotate(x,y,z,ex,ey,ez,deg)
len = sqrt(ex^2+ey^2+ez^2);
EX = ex/len;
EY = ey/len;
EZ = ez/len;

X = (cosd(deg)+EX^2*(1-cosd(deg)))*x + ...
    (EX*EY*(1-cosd(deg))-EZ*sind(deg))*y +...
    (EX*EZ*(1-cosd(deg))+EY*sind(deg))*z;
Y = (EY*EX*(1-cosd(deg))+EZ*sind(deg))*x + ...
    (cosd(deg)+EY^2*(1-cosd(deg)))*y + ...
    (EY*EZ*(1-cosd(deg))-EX*sind(deg))*z;
Z = (EZ*EX*(1-cosd(deg))-EY*sind(deg))*x + ...
    (EZ*EY*(1-cosd(deg))+EX*sind(deg))*y + ...
    (cosd(deg)+EZ^2*(1-cosd(deg)))*z;
end


