function [flag, rect] = Judge_Direction(bw)
% 判断裂缝的方向
[L, num] = bwlabel(bw);

% 获取连通域的面积和边界框信息
stats = regionprops(bw, 'Area', 'BoundingBox');
Area = cat(1, stats.Area);

% 按照面积进行降序排序
[Area, ind] = sort(Area, 'descend');

% 判断连通域数量
if num == 1
    % 如果只有一个连通域，则直接使用其边界框作为结果
    rect = stats.BoundingBox;
else
    % 如果有多个连通域，则选取面积最大的两个连通域的边界框进行合并
    rect1 = stats(ind(1)).BoundingBox;
    rect2 = stats(ind(2)).BoundingBox;
    
    % 合并两个边界框的位置信息
    s1 = [rect1(1); rect2(1)];
    s2 = [rect1(2); rect2(2)];
    s = [min(s1) min(s2) rect1(3)+rect2(3) rect1(4)+rect2(4)];
    rect = s;
end

% 计算边界框的宽高比
rate = rect(3)/rect(4);

% 根据宽高比判断裂缝的方向
if rate > 1
    % 宽度大于高度，判断为横向裂缝
    flag = 1;
else
    % 宽度小于等于高度，判断为纵向裂缝
    flag = 2;
end
