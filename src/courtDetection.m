function [numberOfFrame,lt,rt,lb,rb ] = courtDetection( fileName,numberOfFrame )

[~, name] = fileparts(fileName);

if(exist(['src/cache/' name '_courtDetect.mat'], 'file'))
    load(['src/cache/' name '_courtDetect.mat']);
    return;
end

if(exist(['src/cache/' name '_frame.mat'], 'file'))
    load(['src/cache/' name '_frame.mat']);
else
    videoObj = VideoReader(['video/' fileName]);
    videoFrames = read(videoObj);
    save(['src/cache/' name '_frame.mat'], 'videoFrames', '-v7.3');
end

close all
fig = figure;
%for i = 204 : size(videoFrames,4)
    i=numberOfFrame;
    numberOfFrame=i;
    z=videoFrames(:,:,:,i);
    l = whitePixelDetection(videoFrames(:,:,:,i));
    image(l*255)
    
%     pause
    [h, theta, rho] = hough(l);
    peaks = houghpeaks(h, 10, 'Threshold', 0.1*max(h(:)), 'NHoodSize', [ceil(size(h,1)/100)+1 ceil(size(h,2)/100)+1]);
%     size(peaks)
    lines = houghlines(l, theta, rho, peaks);
%     clf(fig);
    verLines = {};
    horLines = {};
    for j = 1 : size(lines,2)
        if(abs(lines(j).theta)<45)
            verLines = [verLines lines(j)];
        else
            horLines = [horLines lines(j)];
        end
%         line([lines(j).point1(1) lines(j).point2(1)], [lines(j).point1(2) lines(j).point2(2)]);
%         lines(j).rho
%         pause
    end
    lx = inf;
    rx = -inf;
    for j = 1 : size(verLines,2)
        tmp = (verLines{j}.rho - sin(verLines{j}.theta*pi/180)*(size(l,1)/2)) / cos(verLines{j}.theta*pi/180);
        if(tmp < lx)
            lLine = verLines{j};
            lx = tmp;
        end
        if(tmp > rx)
            rLine = verLines{j};
            rx = tmp;
        end
    end
    ty = -inf;
    by = inf;
    for j = 1 : size(horLines,2)
        if(horLines{j}.rho <0)
            
        if(horLines{j}.rho > ty)
            tLine = horLines{j};
            ty = horLines{j}.rho;
        end
        if(horLines{j}.rho < by)
            bLine = horLines{j};
            by = horLines{j}.rho;
        end
        end
    end
    line([lLine.point1(1) lLine.point2(1)], [lLine.point1(2) lLine.point2(2)]);
    line([rLine.point1(1) rLine.point2(1)], [rLine.point1(2) rLine.point2(2)]);
    line([tLine.point1(1) tLine.point2(1)], [tLine.point1(2) tLine.point2(2)]);
    line([bLine.point1(1) bLine.point2(1)], [bLine.point1(2) bLine.point2(2)]);
    lt = houghLineIntersect(lLine, tLine);
    rt = houghLineIntersect(rLine, tLine);
    lb = houghLineIntersect(lLine, bLine);
    rb = houghLineIntersect(rLine, bLine);
    %drawnow
    %pause
%end

% save(['src\cache\' name '_courtDetect.mat'], 'court');

end

