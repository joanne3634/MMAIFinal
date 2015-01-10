function [ frameNum ] = ballDetection( fileName, frame )

disp('Begin ball detection ... ');
[~, name] = fileparts(fileName);

if(exist(['src/cache/' name '_courtDetect.mat'], 'file'))
    load(['src/cache/' name '_courtDetect.mat']);
    return;
end

if(exist(['src/cache/' name '_frame.mat'], 'file'))
    load(['src/cache/' name '_frame.mat']);
else
    videoObj = VideoReader(['video/' fileName]);
    videoFrames = read(videoObj);
    save(['src/cache/' name '_frame.mat'], 'videoFrames', '-v7.3');
end

[ frameNum, ~, topLeft, botLeft, topRight, botRight, lineAngle ] = courtDetection(fileName,frame);
% image(videoFrames(:,:,:,frame));
grayImg = double(rgb2gray(videoFrames(:,:,:,frame)));
gradiImg = zeros(size(grayImg));
for i = floor(topLeft(1)) : floor(botLeft(1))
    for j = floor(topLeft(2)) : floor(topRight(2))
        gradiImg(i,j) = double((4*grayImg(i,j) - grayImg(i,j-1) - grayImg(i,j+1) - grayImg(i-1,j) - grayImg(i+1,j)))/4;
    end
end
gradiImg = 255*(gradiImg-min(min(gradiImg))*ones(size(gradiImg)))/(max(max(gradiImg))-min(min(gradiImg)));
filterSize = 10;
x = linspace(0,1,filterSize);
y = gaussmf(x,[0.12 0.5]);
filter90 = [];
for i = 1 : filterSize
    filter90 = [filter90; y];
end
linePart = zeros(size(grayImg));
for i = 1 : size(lineAngle{1},2)
    fImg = imfilter(gradiImg,imrotate(filter90,lineAngle{1}(i)), 'replicate');
%     imshow(uint8(255*(fImg-min(min(fImg))*ones(size(fImg)))/(max(max(fImg))-min(min(fImg)))))
%     pause
    linePart = linePart + fImg;
end
linePart = 255*(linePart-min(min(linePart))*ones(size(linePart)))/(max(max(linePart))-min(min(linePart)));
% imshow(uint8(linePart))
% pause
lineMean = mean(mean(double(linePart)));
for t = 1 : 20
    thre = (255-lineMean)*((21-t)/20)+lineMean;
    test = linePart;
    for i = 1 : size(linePart,1)
        for j = 1 : size(linePart,1)
            if(linePart(i,j)>thre)
                test(i,j) = linePart(1,1);
            end
        end
    end
    close all
    figure('Position',[700 500 600 600]);
    imshow(uint8(test))
    pause
end
for i = floor(topLeft(1)) : floor(botLeft(1))
    for j = floor(topLeft(2)) : floor(topRight(2))
        if(linePart(i,j)>lineMean)
            gradiImg(i,j) = gradiImg(1,1);
        end
    end
end
imshow(uint8(gradiImg))
pause

% gradiImg = zeros(size(grayImg));
% for i = floor(topLeft(1)) : floor(botLeft(1))
%     for j = floor(topLeft(2)) : floor(topRight(2))
%         gradiImg(i,j) = double((4*grayImg(i,j) - grayImg(i,j-1) - grayImg(i,j+1) - grayImg(i-1,j) - grayImg(i+1,j)))/4;
%     end
% end
% gradiImg = 255*(gradiImg-min(min(gradiImg))*ones(size(gradiImg)))/(max(max(gradiImg))-min(min(gradiImg)));
% 
% pointFilter = fspecial('gaussian',10,2);
% pointFilter = pointFilter - mean(mean(pointFilter))*ones(10,10);
% pointFilter = pointFilter * 10
% pause
% gradiImg = imfilter(gradiImg,pointFilter);
% gradiImg = 255*(gradiImg-min(min(gradiImg))*ones(size(gradiImg)))/(max(max(gradiImg))-min(min(gradiImg)));

% imshow(grayImg)
% pause
% strengh = -inf;
% for i = floor(topLeft(1)) : floor(botLeft(1))
%     for j = floor(topLeft(2)) : floor(topRight(2))
%         tstrengh = sum(sum([-1 -1 -1 -1 -1;-1 0 0 0 -1;-1 0 16 0 -1;-1 0 0 0 -1;-1 -1 -1 -1 -1] .* double(grayImg(i-2:i+2,j-2:j+2))));
%         if(tstrengh>strengh)
%             strengh = tstrengh;
%             ballPos = [i,j];
%         end
%     end
% end
% hold on
% plot(ballPos(2),ballPos(1),'go');
disp('Ball detection complete.');

end

