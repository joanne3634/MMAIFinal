function [ courtDownHalf ] = playerTrack( VideofileName, frameIdx, lt, rt, lb, rb)
%read the frame from video
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xyloObj = VideoReader(['video/' VideofileName]);
rows = xyloObj.Height;
cols = xyloObj.Width;

for idx = 1 : size(frameIdx,2)
    RGB = read(xyloObj,frameIdx(idx));

    %trans to HSV
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     HSV = rgb2hsv(RGB);
%     H = HSV(:,:,1);
%     S = HSV(:,:,2);
%     V = HSV(:,:,3);
%     Voriginal = HSV(:,:,3);

    %spilt court
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure,imshow(RGB);title('�y��');
    for i=(int16(lb(2,1))-(rows/4)):int16(lb(2,1))
        for j=int16(lb(1,1)):int16(rb(1,1))
            courtDownHalf(i,j,:)=RGB(i,j,:);
        end
    end

    for i=(int16(lb(2,1))-(rows/4)):rows
        for j=1:cols
            frameDownHalf(i,j,:)=RGB(i,j,:);
        end
    end
    subplot(1,3,1),imshow(RGB);title('Image');
    subplot(1,3,2),imshow(frameDownHalf);title('Image�U�b');
    subplot(1,3,3),imshow(courtDownHalf);title('�y���U�b');

    %translate to HSV of spilt court
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    HSV = rgb2hsv(courtDownHalf);
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);
    Voriginal = HSV(:,:,3);

    %quntize and count
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [QframeDownHalfH,~] = quntize(H,12);
    [QframeDownHalfV,~] = quntize(V,12);

    YM=mean(QframeDownHalfH);
    YV=var(double(QframeDownHalfH(:)));
    VM=mean(QframeDownHalfV);
    VV=var(double(QframeDownHalfV(:)));

    xY=(0.5/12+VV^2)/(VV^2);
    xV=(0.5/12+VV^2)/(VV^2);

    for i=(int16(lb(2,1))-(rows/4)):rows
       for j=1:cols
           if (abs(double(H(i,j))-double(YM)) > double(xY*YV^2)) | ...
                   (abs(double(V(i,j))-double(VM)) > double(xV*VV^2))
               RGB(i,j) =255;
           else
               RGB(i,j) =0;
       end
       end
    end
    figure,imshow(RGB)
    %figure,imshow(HSV)
    %figure,imhist(HSV);title('V���q����?');
end

end
