function bwn = Identify_Object(bw, MinArea, MinRate)
% 输入参数bw为二值图像，MinArea为最小区域面积，MinRate为最小长宽比
% 如果未提供MinArea和MinRate参数，默认值分别为20和3

if nargin < 3
    MinRate = 3;
end
if nargin < 2
    MinArea = 20;
end

% 对二值图像进行连通区域标记
[L, num] = bwlabel(bw);

% 计算各个连通区域的面积、主轴长度和次轴长度
stats = regionprops(L, 'Area', 'MajorAxisLength', 'MinorAxisLength');
Ap = cat(1, stats.Area);
Lp1 = cat(1, stats.MajorAxisLength);
Lp2 = cat(1, stats.MinorAxisLength);

% 计算各个连通区域的长宽比
Lp = Lp1 ./ Lp2;

% 根据最小区域面积MinArea，将面积小于MinArea的连通区域设为背景
for i = 1:num
    if Ap(i) < MinArea
        bw(L == i) = 0;
    end
end

% 计算最小长宽比阈值MinRate
MinRate = max(Lp) * 0.4;

% 根据最小长宽比MinRate，将长宽比小于MinRate的连通区域设为背景
for i = 1:num
    if Lp(i) < MinRate
        bw(L == i) = 0;
    end
end

bwn = bw;
