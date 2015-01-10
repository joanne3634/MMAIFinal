function [ point ] = fourDirDetect( img, bound )

pointImg = zeros(size(img));
for i = bound(1) : bound(2)
    for j = bound(3) : bound(4)
        pointImg(i,j) = pointImg(i,j) + img(i,j)-img(i+1,j)
    end
end

end

