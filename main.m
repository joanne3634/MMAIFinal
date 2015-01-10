clc;
clear all;
close all;

addpath('src\');

[numberOfFrame,lt,rt,lb,rb ] = courtDetection('1.avi');
[ courtDownHalf ] = playerTrack('1.avi',numberOfFrame ,lt,rt,lb,rb);