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

[ frameNum, ~, topLeft, botLeft, topRight, botRight, lineAngle ] = courtDetection(fileName,[frame frame+1]);
% image(videoFrames(:,:,:,frame));
grayImg1 = rgb2gray(videoFrames(:,:,:,frame));
grayImg2 = rgb2gray(videoFrames(:,:,:,frame+1));
close all
figure
imshow(grayImg1)
figure
imshow(grayImg2)
diff = zeros(size(grayImg1));
for i = 1 : size(grayImg1,1)
    for j = 1 : size(grayImg1,2)
        diff(i,j) = abs(grayImg1(i,j)-grayImg2(i,j));
    end
end
figure
imshow(diff)

% gradiImg = zeros(size(grayImg));
% for i = floor(topLeft(1)) : floor(botLeft(1))
%     for j = floor(topLeft(2)) : floor(topRight(2))
%         gradiImg(i,j) = double((4*grayImg(i,j) - grayImg(i,j-1) - grayImg(i,j+1) - grayImg(i-1,j) - grayImg(i+1,j)))/4;
%     end
% end
% gradiImg = 255*(gradiImg-min(min(gradiImg))*ones(size(gradiImg)))/(max(max(gradiImg))-min(min(gradiImg)));

disp('Ball detection complete.');

end
