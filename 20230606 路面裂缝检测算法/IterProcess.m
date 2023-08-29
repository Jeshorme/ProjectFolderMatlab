function [bw, th] = IterProcess(Img)
% 判断输入图像的维度，如果是三维则转换为灰度图像
if ndims(Img) == 3
    I = rgb2gray(Img);
else
    I = Img;
end

% 初始阈值的设置
T0 = (double(max(I(:))) + double(min(I(:))))/2;
flag = 1; 

% 迭代过程，直到阈值不再变化
while flag
    % 根据当前阈值将图像分为两部分：大于阈值和小于等于阈值
    ind1 = I > T0; 
    ind2 = ~ind1;
    
    % 根据两部分的平均灰度值计算新的阈值
    T1 = (mean(double(I(ind1))) + mean(double(I(ind2))))/2;
    
    % 判断新旧阈值之间的差异是否大于0.5
    flag = abs(T1-T0) > 0.5;
    
    % 更新阈值为新计算得到的值
    T0 = T1; 
end

% 输出二值化结果和最终确定的阈值
bw = ind1;
th = T1;
