function [ court ] = courtDetection( fileName )

[~, name] = fileparts(fileName);

if(exist(['src\cache\' name '_courtDetect.mat'], 'file'))
    load(['src\cache\' name '_courtDetect.mat']);
    return;
end

if(exist(['src\cache\' name '_frame.mat'], 'file'))
    load(['src\cache\' name '_frame.mat']);
else
    videoObj = VideoReader(['video\' fileName]);
    videoFrames = read(videoObj);
    save(['src\cache\' name '_frame.mat'], 'videoFrames', '-v7.3');
end

close all
fig = figure;
for i = 200 : size(videoFrames,4)
    i
    l = whitePixelDetection(videoFrames(:,:,:,i));
    image(l*255)
%     pause
    [h, theta, rho] = hough(l);
    peaks = houghpeaks(h, 10);
    lines = houghlines(l, theta, rho, peaks);
%     clf(fig);
    verLines = {};
    horLines = {};
    for j = 1 : size(lines,2)
        if(abs(lines(j).theta)<45)
            verLines = [verLines lines(j)];
            if(~exist('dl','var') || lines(j).rho < dl)
                dl = lines(j).rho;
                lLine = lines(j);
            end
            if(~exist('dr','var') || lines(j).rho > dr)
                dr = lines(j).rho;
                rLine = lines(j);
            end
        else
            horLines = [horLines lines(j)];
            if(~exist('dt','var') || lines(j).rho > dt)
                dt = lines(j).rho;
                tLine = lines(j);
            end
            if(~exist('dd','var') || lines(j).rho < dd)
                dd = lines(j).rho;
                bLine = lines(j);
            end
        end
%         line([lines(j).point1(1) lines(j).point2(1)], [lines(j).point1(2) lines(j).point2(2)]);
%         pause
    end
    lt = houghLineIntersect(lLine, tLine)
    rt = houghLineIntersect(rLine, tLine)
    lb = houghLineIntersect(lLine, bLine)
    rb = houghLineIntersect(rLine, bLine)
    drawnow
    pause
end

court = 0;
% save(['src\cache\' name '_courtDetect.mat'], 'court');

end

