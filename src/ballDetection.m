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
filter90 = [0 0 1 0 0;0 0 1 0 0;0 0 1 0 0;0 0 1 0 0;0 0 1 0 0];
linePart = zeros(size(grayImg));
for i = 1 : size(lineAngle{1},2)
    filt = imrotate(filter90,lineAngle{1}(i));
    linePart = linePart + imfilter(grayImg,filt);
    image(linePart)
    pause
end


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
close all
figure
imshow(uint8(gradiImg))

pause

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

