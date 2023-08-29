function bwn = bw_filter(bw, keepnum)
% 输入参数bw为二值图像，keepnum为保留的连通区域数量
% 如果未提供keepnum参数，默认为15

if nargin < 2
    keepnum = 15;
end

% 对输入的二值图像进行连通区域标记，使用8连通区域标记
[L, num] = bwlabel(bw, 8);

% 创建一个大小为num的零向量Ln
Ln = zeros(1, num);

% 获取各个连通区域的面积并存储到Ln中
stats = regionprops(L, 'Area');
Ln = cat(1, stats.Area);

% 对Ln按照面积进行排序，并返回排序后的结果Ln和对应的索引ind
[Ln, ind] = sort(Ln);

% 如果连通区域的数量大于等于keepnum
if num > keepnum || num == keepnum
    % 遍历前num-keepnum个连通区域
    for i = 1 : num - keepnum
        % 将这些连通区域对应的像素置为0，即去除这些连通区域
        bw(L == ind(i)) = 0;
    end
end

% 将处理后的二值图像返回
bwn = bw;
