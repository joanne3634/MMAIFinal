function [RGB,V] = count_HSV(VideofileName,Threshold,numberOfFrame)

VThreshold = Threshold;
numberOfLevelsForV = 256;

%read the frame from video
xyloObj = VideoReader(VideofileName);
rows = xyloObj.Height;
cols = xyloObj.Width;
RGB = read(xyloObj,numberOfFrame);

%trans to HSV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HSV = rgb2hsv(RGB);
H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);
Voriginal = HSV(:,:,3);

%show the image of value(hsv)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure,imshow(RGB);title('Image');
figure,imshow(H);title('H');
%figure,imshow(S);title('S');
figure,imshow(Voriginal);title('V');

%count HSV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[qValueForEveryPixel,everyLavelValue]=quntize(V,256);
everyLavelValue = everyLavelValue/sum(everyLavelValue);
maxValueForV = max(V(:));
for i=1:numberOfLevelsForV
    
    if (everyLavelValue(i,1) > VThreshold)
       everyLavelValue(i,1) = everyLavelValue(i,1);
    else
       everyLavelValue(i,1)=0;
    end
    %fprintf ('Number %d :%d\n',i,vColorHistogram(i,1))
end
thres = 0;
for i=(numberOfLevelsForV:-1:1)
    if (everyLavelValue(i,1) == 0)
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
        if (V(row, col)>threshold)
            continue;
        else
            V(row,col) = 0;
        end
    end
end
%figure,imshow(V);title('¬D¿ï¹L«á');
end

