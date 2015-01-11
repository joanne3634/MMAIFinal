clc;
clear all;
close all;

addpath('src\');
for i = 204:10:2000
[numberOfFrame,lt,rt,lb,rb ] = courtDetection('1.avi',i);
[PlayInUpCol,PlayInUpRow,PlayInDownCol,PlayInDownRow] = playerTrack('1.avi',i ,lt,rt,lb,rb)
pause
end