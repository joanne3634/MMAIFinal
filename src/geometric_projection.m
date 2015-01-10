clear all;
close all;
clc;

img1 =imread('tenniscourt.jpg' );
[h1 w1] = size(img1);
mask = uint8(ones(h1,w1));

[frame,a,b,c,d]=courtDetection('1.avi');


[h2 w2] = size(frame);

imshow(img1);
figure;imshow(frame);

p1 =[ 1 , 1 ;w1, 1 ; 1 ,h1;w1,h1];
p2 = [a(1),a(2);b(1),b(2);c(1),c(2);d(1),d(2)]
size(p2)
T = calc_homography(p1,p2); %???????
T =maketform( 'projective' ,T); %????

[imgn,X,Y] = imtransform(img1,T); %??
mask = imtransform(mask,T);
T2 =eye( 3 );
if X( 1 )> 0 , T2( 3 , 1 )= X( 1 ); end 
if Y( 1 )> 0 , T2( 3 , 2 )= Y( 1 ); end 
T2 =maketform( 'affine' ,T2); %????

imgn =imtransform(imgn,T2, 'XData' ,[ 1 w2], 'YData' ,[ 1 h2]); %??
mask =imtransform(mask,T2, 'XData' ,[ 1 w2], 'YData' ,[ 1 h2]);

img =frame.*( 1 -mask)+imgn.* mask; %??
figure;imshow(img,[])