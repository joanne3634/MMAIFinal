clc;
clear all;
close all;

addpath('src/');
frameIdx = 1:10:3880;
% load('src\cache\1_frame.mat');
[ frameNum, court, topLeft, botLeft, topRight, botRight ] = courtDetection('1.avi',frameIdx);
[ UpPlayerCenter, DownPlayerCenter, UpPlayerPos, DownPlayerPos ] = playerTrack('1.avi', topLeft, topRight, botLeft, botRight,frameIdx);

load('src\cache\1_frame.mat');
writerObj = VideoWriter('demo2.avi');
writerObj.FrameRate = 3;
open(writerObj);
for i = 1 : frameNum
    if(exist('frameIdx','var'))
        imshow(videoFrames(:,:,:,frameIdx(i)));
    else
        imshow(videoFrames(:,:,:,i));
    end
    if(topLeft(i,1) ~= 0)
        hold on
        for j = 1 : 25
            plot(court{i}(j,2),court{i}(j,1),'gx');
        end
        plot(UpPlayerCenter(i,2),UpPlayerCenter(i,1),'go');
        plot(DownPlayerCenter(i,2),DownPlayerCenter(i,1),'go');
    end
    frame = getframe;
    writeVideo(writerObj,frame.cdata);
    hold off
end
close(writerObj);
