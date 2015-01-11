clc;
clear all;
close all;

addpath('src/');
frameIdx = 204;
[ frameNum, court, topLeft, botLeft, topRight, botRight ] = courtDetection('1.avi', frameIdx);
[PlayInUpCol, PlayInUpRow, PlayInDownCol, PlayInDownRow] = playerTrack('1.avi', frameIdx, topLeft, topRight, botLeft, botRight);

