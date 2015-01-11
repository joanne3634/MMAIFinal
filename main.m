clc;
clear all;
close all;

addpath('src/');
frameIdx = 150:153;
[ frameNum, court, topLeft, botLeft, topRight, botRight ] = courtDetection('1.avi',frameIdx);
[ UpPlayerCenter, DownPlayerCenter, UpPlayerPos, DownPlayerPos ] = playerTrack('1.avi', topLeft, topRight, botLeft, botRight);

load('src\cache\1_frame.mat');
writerObj = VideoWriter('demo.avi');
open(writerObj);
for i = 1 : frameNum
    imshow(videoFrames(:,:,:,frameIdx(i)));
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
