function [ qValueForEveryPixel,everyLavelValue ] = quntize(Value,numberOfLevels)
%QUNTIZE Summary of this function goes here
%   Detailed explanation goes here

[rows,cols]=size(Value);
count = 1;
qValueForEveryPixel=zeros(rows, cols);
index = zeros(rows*cols,1);
maxValueForV = max(Value(:));
for row = 1:rows
    for col = 1 :cols
        qValueForEveryPixel(row, col) = ceil(numberOfLevels * Value(row, col)/maxValueForV);
        
        % keep indexes where 1 should be put in matrix hsvHist
        index(count,1) = qValueForEveryPixel(row, col);
        if index(count,1)==numberOfLevels+1
            index(count,1)=index(count,1)-1;
        end
        count = count+1;
    end
end
everyLavelValue=zeros(numberOfLevels,1);
for row = 1:size(index,1)
    if (index(row, 1) == 0)
        continue;
    end
    everyLavelValue(index(row, 1)) = everyLavelValue((index(row, 1))) + 1;
end

end

