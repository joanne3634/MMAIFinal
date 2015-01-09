function [ pt ] = houghLineIntersect( line1, line2 )

% disp('hou')
% line1.theta
% line1.rho
% line2.theta
% line2.rho
pt = [cos(line1.theta*pi/180)/line1.rho sin(line1.theta*pi/180)/line1.rho; ...
      cos(line2.theta*pi/180)/line2.rho sin(line2.theta*pi/180)/line2.rho] \ [1;1];
% pause
end

