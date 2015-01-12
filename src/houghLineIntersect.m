function [ pt ] = houghLineIntersect( line1, line2 )

if(abs(line1.theta-line2.theta)<2 && abs(line1.rho-line2.rho)<2)
    pt = [0 0];
    return
end
pt = [cos(line1.theta*pi/180)/line1.rho sin(line1.theta*pi/180)/line1.rho; ...
      cos(line2.theta*pi/180)/line2.rho sin(line2.theta*pi/180)/line2.rho] \ [1;1];

end

