function [ degAngle ] = fixedReferenceAtand( x, y )
%fixedReferenceAtand Keeps the angle at (1,0) at 0 degrees and rotate
%counterclockwise.

% Catch all cases multiples of 90 degrees
if (x==0 && y==0)
    degAngle = nan;
elseif (x == 0 && y > 0)
    degAngle = 90;
elseif (x == 0 && y < 0)
    degAngle = 270;
elseif (x > 0 && y == 0)
    degAngle = 0;
elseif( x < 0 && y == 0)
    degAngle = 180;
end

% Now catch all cases in the four quadrants
% First quadrant
if (x > 0 && y > 0)
    degAngle = atand(y/x);
elseif (x < 0 && y > 0)
    degAngle = (90 - atand(y/x)*-1)+90;
elseif (x < 0 && y < 0)
    degAngle = atand(y/x)+180;
elseif (x > 0 && y < 0)
    degAngle = (90 - atand(y/x)*-1)+270;
end

end

