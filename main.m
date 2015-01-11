clc;
% clear all;
close all;

addpath('src/');
frameIdx = 204;
[ frameNum, court, topLeft, botLeft, topRight, botRight ] = courtDetection('1.avi', frameIdx, videoFrames);
[ UpPlayerCenter, DownPlayerCenter, UpPlayerPos, DownPlayerPos ] = playerTrack('1.avi', frameIdx, topLeft, topRight, botLeft, botRight, videoFrames);

imshow(videoFrames(:,:,:,frameIdx));
hold on
plot(UpPlayerCenter(2),UpPlayerCenter(1),'go');
plot(DownPlayerCenter(2),DownPlayerCenter(1),'go');