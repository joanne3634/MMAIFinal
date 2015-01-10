clc;
clear all;
close all;

addpath('src/');
frameIdx = [200 204];
[ frameNum, court, topLeft, botLeft, topRight, botRight ] = courtDetection('1.avi', frameIdx);
[ courtDownHalf ] = playerTrack('1.avi', frameIdx, topLeft, topRight, botLeft, botRight);
