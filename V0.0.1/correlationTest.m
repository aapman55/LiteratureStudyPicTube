% CorrelationTest

% Define piccolotube properties
PT = piccoloTube(   0.2, ... X location
                    0, ... Y location
                    0.05, ... tube Diameter
                    0.5, ...  Hole to hole spacing
                    0.005, ...  Hole diameter
                    [-45,45]); %List with jet angles

Re = 80000;
zn = 0.05;

% Define Nusselt Number correlation
Nu = @(r) Re.^0.76.*(24 - abs(zn./PT.d-7.75))./(533+44.*(r./PT.d).^1.285);

% create mesh
[X,Y] = meshgrid(linspace(-.5,3,351),linspace(-.5,.5,101));

% Distance matrix (Assuming jet at origin)
R = sqrt(X.^2+Y.^2);
% Second jet at x = 2
R2 = sqrt((X-1).^2+Y.^2);

Nus = Nu(R)+Nu(R2);
image(Nus(:,:))
axis image