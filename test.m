x = [0 4.5 18 31.5 36];
y = [0 18 39 60 78];
courtPt = zeros(25,2);
for i = 1 : 5
    for j = 1 : 5
        courtPt((i-1)*5+j,:) = [y(i) x(j)];
    end
end
save('src\cache\courtPt.mat','courtPt');