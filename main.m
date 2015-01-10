clc;
clear all;
close all;

addpath('src/');
[ frameNum, court, topLeft, botLeft, topRight, botRight ] = courtDetection('1.avi');
[ courtDownHalf ] = playerTrack('1.avi', numberOfFrame, topLeft, topRight, botLeft, botRight);
