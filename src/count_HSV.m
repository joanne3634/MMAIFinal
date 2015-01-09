function [V,vColorHistogram,threshold] = count_HSV( img )
%COUNT_HSV Summary of this function goes here
%   Detailed explanation goes here
RGB = imread(img);
HSV = rgb2hsv(RGB);
V = HSV(:,:,3);
[rows, cols, ~]  = size(RGB) ;
numberOfLevelsForV = 256;
maxValueForV = max(V(:));
%show the image of V-value(hsv)
figure,imshow(V)
figure,imhist(V);title('V分量直方?');

count = 1;
quantizedValueForV=zeros(rows, cols);
index = zeros(rows*cols,1);
for row = 1:rows
    for col = 1 :cols
        quantizedValueForV(row, col) = ceil(numberOfLevelsForV * V(row, col)/maxValueForV);
        
        % keep indexes where 1 should be put in matrix hsvHist
        index(count,1) = quantizedValueForV(row, col);
        count = count+1;
    end
end
vColorHistogram=zeros(numberOfLevelsForV,1);
for row = 1:size(index,1)
    if (index(row, 1) == 0)
        continue;
    end
    vColorHistogram(index(row, 1)) =vColorHistogram((index(row, 1))) + 1;
end

vColorHistogram = vColorHistogram/sum(vColorHistogram);

for i=1:numberOfLevelsForV
    
    if (vColorHistogram(i,1) > 0.005)
       vColorHistogram(i,1) = vColorHistogram(i,1);
    else
       vColorHistogram(i,1)=0;
    end
    %fprintf ('Number %d :%d\n',i,vColorHistogram(i,1))
end
threshold = 0;
thres = 0;
for i=(numberOfLevelsForV:-1:1)
    if (vColorHistogram(i,1) == 0)
        continue;
    else
       %fprintf ('Number %d :%d\n',i,vColorHistogram(i,1))
       thres = i+1;
       break;
    end
end

threshold=(thres*maxValueForV/numberOfLevelsForV);

for row = 1:rows
    for col = 1 :cols
        if (V(row, col)>0.5898)
            continue;
        else
            V(row,col) = 0;
        end
    end
end

figure,imshow(V)
figure,imhist(V);title('V分量直方?');
end

