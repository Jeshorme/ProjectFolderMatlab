function bwn = Judge_Crack(bw, Ig, th)
% 根据给定的阈值判断裂缝
if nargin < 3
    th = 20;
end

% 对输入的二值化图像进行标记连通域操作
[L, num] = bwlabel(bw);

% 将灰度图像转换为uint8类型，并进行归一化处理
Ig = im2uint8(mat2gray(Ig));
Ig = double(Ig);

% 对每个连通域进行处理
stats = regionprops(L, 'Area', 'BoundingBox');
for i = 1 : num
    % 获取连通域的边界框坐标
    Ymin = round(stats(i).BoundingBox(1));
    Ymax = round(stats(i).BoundingBox(1) + stats(i).BoundingBox(3));
    Xmin = round(stats(i).BoundingBox(2));
    Xmax = round(stats(i).BoundingBox(2) + stats(i).BoundingBox(4));
    
    % 计算边界框内像素的灰度值总和
    sum1(i) = 0; 
    for k1 = Xmin : Xmax-1
        for k2 = Ymin : Ymax-1
            sum1(i) = sum1(i) + Ig(k1, k2);
        end
    end
    
    % 计算边界框的面积
    RectArea(i) = stats(i).BoundingBox(3)*stats(i).BoundingBox(4);
    
    % 计算边界框内像素的平均灰度值
    Average1(i) = sum1(i)/RectArea(i);
    
    % 提取连通域内的像素灰度值
    [r, c] = find(L == i);
    Ln(i) = length(find(L==i));
    for j = 1 : Ln(i)
        gv(i, j) = Ig(r(j), c(j));
    end
    
    % 计算连通域内像素的灰度值总和
    sum2(i) = sum(gv(i, :));
    
    % 计算连通域内像素的平均灰度值
    Average2(i) = sum2(i)/Ln(i);
    
    % 计算两个平均灰度值之间的差值
    Sub(i) = abs(Average1(i) - Average2(i));
    
    % 如果差值小于阈值，则将该连通域标记为非裂缝区域
    if Sub(i) < th
        bw(find(L==i)) = 0;
    end
end

% 输出处理后的二值化图像
bwn = bw;
