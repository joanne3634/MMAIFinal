function [UpPlayerCenter, DownPlayerCenter, UpPlayerPos, DownPlayerPos] = playerTrack( VideofileName, lt, rt, lb, rb, frame, videoFrames)

disp('Begin player track ...');
%read the frame from video
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~, name] = fileparts(VideofileName);

if(exist(['src/cache/' name '_playerTract.mat'], 'file'))
    load(['src/cache/' name '_playerTract.mat']);
    disp('Player track done.');
    return;
end

if(~exist('videoFrames','var'))
    if(exist(['src/cache/' name '_frame.mat'], 'file'))
        load(['src/cache/' name '_frame.mat']);
    else
        videoObj = VideoReader(['video/' VideofileName]);
        videoFrames = read(videoObj);
        save(['src/cache/' name '_frame.mat'], 'videoFrames', '-v7.3');
    end
end
RGB = videoFrames;

if(exist('frame','var'))
    numOfFrame = size(frame,2);
else
    numOfFrame = size(RGB,4);
end

UpPlayerCenter = zeros(numOfFrame,2);
DownPlayerCenter = zeros(numOfFrame,2);
UpPlayerPos = cell(1,numOfFrame);
DownPlayerPos = cell(1,numOfFrame);

if(exist('frame','var'))
    for i = 1 : numOfFrame
        disp([num2str(i) ' / ' num2str(numOfFrame)]);
        [UpPlayerCenter(i,:), DownPlayerCenter(i,:), UpPlayerPos{i}, DownPlayerPos{i}] = ...
            playerTrackSub(RGB(:,:,:,frame(i)), lt(i,:), rt(i,:), lb(i,:), rb(i,:));
    end
else
    for i = 1 : numOfFrame
        disp([num2str(i) ' / ' num2str(numOfFrame)]);
        [UpPlayerCenter(i,:), DownPlayerCenter(i,:), UpPlayerPos{i}, DownPlayerPos{i}] = ...
            playerTrackSub(RGB(:,:,:,i), lt(i,:), rt(i,:), lb(i,:), rb(i,:));
    end
end
save(['src/cache/' name '_playerTract.mat'], 'UpPlayerCenter', 'DownPlayerCenter', 'UpPlayerPos', 'DownPlayerPos');
disp('Player track done.');

end

function [UpPlayerCenter, DownPlayerCenter, UpPlayerPos, DownPlayerPos] = playerTrackSub (RGB, lt, rt, lb, rb)

if(lt(1) == 0)
    UpPlayerCenter = [0 0];
    DownPlayerCenter = [0 0];
    UpPlayerPos = [];
    DownPlayerPos = [];
    return
end
%spilt court
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lm = [ceil((lt(1)+lb(1))/2) ceil((lt(2)+lb(2))/2)];
rm = [ceil((rt(1)+rb(1))/2) ceil((rt(2)+rb(2))/2)];
if(lm(1)<0 || lm(2)<0 || rm(1)<0 || rm(2)<0) %% hot fix
    UpPlayerCenter = [0 0];
    DownPlayerCenter = [0 0];
    UpPlayerPos = [];
    DownPlayerPos = [];
    return
end
frameUpHalf = RGB(1:lm(1),:,:);
frameDownHalf = RGB(lm(1):end,:,:);

%Upframe quntize and count
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
upFramePos = highDiffPoint(frameUpHalf);
% image(upFramePos*80)
% pause

%Downframe quntize and count
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
downFramePos = highDiffPoint(frameDownHalf);
% image(downFramePos*80)
% drawnow

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
offset = 0;
x = [lt(2)-offset rt(2)+offset rm(2)+offset lm(2)-offset];
y = [lt(1)-offset rt(1)-offset rm(1) lm(1)];
mask = poly2mask(x,y,size(upFramePos,1),size(upFramePos,2));
for i = 1 : size(upFramePos,1)
    for j = 1 : size(upFramePos,2)
        if(mask(i,j) == 0)
            upFramePos(i,j) = 0;
        end
    end
end
% image(upFramePos*80)
% pause
% upFramePos(floor(size(upFramePos,1)/2):end,1:lm(2)) = ...
%     zeros(size(upFramePos,1)-floor(size(upFramePos,1)/2)+1,lm(2));
x = [lm(2)-offset rm(2)+offset rb(2)+offset lb(2)-offset];
y = [1 1 rb(1)+offset-lm(1) lb(1)+offset-lm(1)];
mask = poly2mask(x,y,size(downFramePos,1),size(downFramePos,2));
for i = 1 : size(downFramePos,1)
    for j = 1 : size(downFramePos,2)
        if(mask(i,j) == 0)
            downFramePos(i,j) = 0;
        end
    end
end
% image(downFramePos*80)
% pause
% downFramePos(1:floor(size(downFramePos,1)/2),1:lm(2)) = ...
%     zeros(floor(size(downFramePos,1)/2),lm(2));

rowSum = 0;
rowCnt = 0;
colSum = 0;
colCnt = 0;
for i = 1 : size(upFramePos,1)
    for j = 1 : size(upFramePos,2)
        if(upFramePos(i,j))
            rowSum = rowSum+i;
            colSum = colSum+j;
            rowCnt = rowCnt+1;
            colCnt = colCnt+1;
        end
    end
end
UpPlayerCenter = [rowSum/rowCnt colSum/colCnt];
tUpPlayerPos = zeros(size(upFramePos));
for i = 1 : size(upFramePos,1)
    for j = 1 : size(upFramePos,2)
        if(upFramePos(i,j) && norm(UpPlayerCenter-[i j],2)<50)
            tUpPlayerPos(i,j) = 1;
        end
    end
end
UpPlayerPos = zeros(size(RGB(:,:,1)));
UpPlayerPos(1:lm(1),:) = tUpPlayerPos;
% image(UpPlayerPos*80)
% drawnow

rowSum = 0;
rowCnt = 0;
colSum = 0;
colCnt = 0;
for i = 1 : size(downFramePos,1)
    for j = 1 : size(downFramePos,2)
        if(downFramePos(i,j))
            rowSum = rowSum+i;
            colSum = colSum+j;
            rowCnt = rowCnt+1;
            colCnt = colCnt+1;
        end
    end
end
DownPlayerCenter = [rowSum/rowCnt colSum/colCnt];
tDownPlayerPos = zeros(size(downFramePos));
for i = 1 : size(downFramePos,1)
    for j = 1 : size(downFramePos,2)
        if(downFramePos(i,j) && norm(DownPlayerCenter-[i j],2)<50)
            tDownPlayerPos(i,j) = 1;
        end
    end
end
DownPlayerCenter(1) = DownPlayerCenter(1)+lm(1);
DownPlayerPos = zeros(size(RGB(:,:,1)));
DownPlayerPos(lm(1):end,:) = tDownPlayerPos;
% image(DownPlayerPos*80)
% drawnow

end

function [ pos ] = highDiffPoint ( img )

[H, ~, V] = rgb2hsv(img);
qH = quntize(H,12);
qV = quntize(V,12);
H_mean = mean(qH(:));
H_var = var(qH(:));
V_mean = mean(qV(:));
V_var = var(qV(:));
pos = zeros(size(img,1), size(img,2));
for i = 1 : size(img,1)
    for j = 1 : size(img,2)
        if((qH(i,j) && abs(double(qH(i,j))-H_mean) > double(sqrt(H_var))) || ...
                (qV(i,j) && abs(double(qV(i,j))-V_mean) > double(sqrt(V_var))))
            pos(i,j) = 1;
        end
    end
end

end