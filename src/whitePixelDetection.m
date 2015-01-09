function [ output ] = whitePixelDetection( img )

% white pixel candidate
img = rgb2ycbcr(img);
img = img(:,:,1);
output = zeros(size(img));
tau = 8;
sigma_l = 100;
sigma_d = 15;
for i = 1 : size(img,1)
    for j = 1 : size(img,2)
        if(i-tau<1)
            g_up = 0;
        else
            g_up = img(i-tau,j);
        end
        if(i+tau>size(img,1))
            g_down = 0;
        else
            g_down = img(i+tau,j);
        end
        if(j-tau<1)
            g_left = 0;
        else 
            g_left = img(i,j-tau);
        end
        if(j+tau>size(img,2))
            g_right = 0;
        else 
            g_right = img(i,j+tau);
        end
        output(i,j) = img(i,j)>=sigma_l && ...
            ((abs(img(i,j)-g_up)>sigma_d && abs(img(i,j)-g_down)>sigma_d) ...
            || (abs(img(i,j)-g_left)>sigma_d && abs(img(i,j)-g_right)>sigma_d));
    end
end

% texture region remove
% b = 5;
% for i = 1 : size(img,1)
%     for j = 1 : size(img,2)
%         if(output(i,j))
%             if(i-b<1)
%                 up = 1;
%             else 
%                 up = i-b;
%             end
%             if(i+b>size(img,1))
%                 down = size(img,1);
%             else 
%                 down = i+b;
%             end
%             if(j-b<1)
%                 left = 1;
%             else 
%                 left = j-b;
%             end
%             if(j+b>size(img,2))
%                 right = size(img,2);
%             else 
%                 right = j+b;
%             end
%             gradient_g = gradient(double(img(up:down,left:right)));
%             S = gradient_g * gradient_g';
%             eigenvalues = eig(S);
%             k = 1;
%             while(k<size(eigenvalues,2))
%                 if(~isreal(eigenvalues(k)))
%                     eigenvalues(k) = [];
%                 else
%                     k = k+1;
%                 end
%             end
%             eigenvalues = sort(eigenvalues,'descend');
%             if(eigenvalues(1)>4*eigenvalues(2))
%                 output(up:down,left:right) = zeros(down-up+1,right-left+1);
%             end
%         end
%     end
% end

end

