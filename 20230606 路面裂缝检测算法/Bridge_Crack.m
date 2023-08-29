function bwn = Bridge_Crack(bw)
% 桥梁裂缝图像处理函数，用于检测和修复裂缝
% 参数：
%   bw：输入的二值化图像
% 返回值：
%   bwn：修复后的二值化图像

[row, col] = size(bw);  % 获取图像的行数和列数
[L, num] = bwlabel(bw);  % 对二值图像进行连通区域标记，获取连通区域数量和标记图像
bwn = bw;  % 复制输入图像，用于修复操作

if num < 2
    return;  % 如果连通区域数量小于2，则无需修复，直接返回
end

stats = regionprops(L, 'BoundingBox');  % 获取每个连通区域的边界框信息

% 遍历每个连通区域，进行裂缝修复
for i = 1:num
    l(i) = round(stats(i).BoundingBox(1) + 0.5);  % 获取边界框的左边界坐标
    b(i) = round(stats(i).BoundingBox(2) - 0.5);  % 获取边界框的下边界坐标
    r(i) = round(stats(i).BoundingBox(1) + stats(i).BoundingBox(3) - 1.5);  % 获取边界框的右边界坐标
    rb(i) = round(stats(i).BoundingBox(2) + stats(i).BoundingBox(4));  % 获取边界框的上边界坐标
end

l(l<=0) = 1;  % 对边界坐标进行修正，确保不越界
b(b<=0) = 1;
r(r>=col) = col;
rb(rb>=row) = row;

try
    % 遍历连通区域，进行裂缝修复操作
    for i = 1:num-1
        for j = b(i):rb(i)
            if bw(j, r(i)) ~= 0
                break;  % 找到裂缝的边界位置，结束循环
            end
        end
        for k = b(i+1):rb(i+1)
            if bw(k, l(i+1)) ~= 0
                break;  % 找到裂缝的边界位置，结束循环
            end
        end

        % 根据裂缝的位置进行修复操作
        Yi = l(i+1);
        Ya = r(i);
        Xi = k;
        Xa = j;
        d = Yi - Ya;
        e = Xa - Xi;

        % 根据裂缝位置的不同情况进行修复
        if e > 0
            if (d > e) || (d == e)
                for p = 1:e
                    bw(j-p, r(i)+p) = 1;
                    bw(j-p-1, r(i)+p) = 1;
                    bw(j-p+1, r(i)+p) = 1;
                end
                for q = e+1:d-1
                    bw(j-e, r(i)+q) = 1;
                    bw(j-e-1, r(i)+q) = 1;
                    bw(j-e+1, r(i)+q) = 1;
                end
            end
            if d < e
                for p = 1:d
                    bw(j-p, r(i)+d) = 1;
                    bw(j-p-1, r(i)+d) = 1;
                    bw(j-p+1, r(i)+d) = 1;
                end
                for q = d+1:e-1
                    bw(j-q, r(i)+d) = 1;
                    bw(j-q, r(i)+d-1) = 1;
                    bw(j-q, r(i)+d+1) = 1;
                end
            end
            if d == 0
                for p = 1:e
                    bw(j-p, r(i)) = 1;
                    bw(j-p, r(i)-1) = 1;
                    bw(j-p, r(i)+1) = 1;
                end
            end
        end
        if e < 0
            e = abs(e);
            if (d > e) || (d == e)
                for p = 1:e
                    bw(j+p, r(i)+p) = 1;
                    bw(j+p-1, r(i)+p) = 1;
                    bw(j+p+1, r(i)+p) = 1;
                end
                for q = e+1:d-1
                    bw(j+e, r(i)+q) = 1;
                    bw(j+e-1, r(i)+q) = 1;
                    bw(j+e+1, r(i)+q) = 1;
                end
            end
            if d < e
                for p = 1:d
                    bw(j+p, r(i)+p) = 1;
                    bw(j+p-1, r(i)+p) = 1;
                    bw(j+p+1, r(i)+p) = 1;
                end
                for q = d+1:e-1
                    bw(j+q, r(i)+d) = 1;
                    bw(j+q, r(i)+d-1) = 1;
                    bw(j+q, r(i)+d+1) = 1;
                end
            end
            if d == 0
                for p = 1:e
                    bw(j+p, r(i)) = 1;
                    bw(j+p, r(i)-1) = 1;
                    bw(j+p, r(i)+1) = 1;
                end
            end
        end
        if e == 0
            for p = 1:d
                bw(j, r(i)+p) = 1;
                bw(j-1, r(i)+p) = 1;
                bw(j+1, r(i)+p) = 1;
            end
        end
        if d < 0
            for p = min(Xa, Xi):max(Xa, Xi)
                for q = min(Ya, Yi):max(Ya, Yi)
                    bw(p, q) = 1;
                end
            end
        end
    end
catch
    bwn = bw;
    return;  % 出现错误时，返回原始图像
end

bwn = bw;  % 返回修复后的图像
