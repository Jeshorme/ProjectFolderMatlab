function s_out = med_process(s_in, flag)
% 中值滤波处理函数
if nargin < 2
    flag = 0;
end

% 判断输入图像的维度
if ndims(s_in) == 3
    % 如果是三通道图像，则将其转换为灰度图像
    I = rgb2gray(s_in);
else
    % 如果是灰度图像，则直接使用
    I = s_in;
end

% 对输入图像进行中值滤波处理
s_out = medfilt2(I);

% 根据标志位进行可视化展示
if flag
    figure;
    subplot(2, 2, 1); imshow(I); title('原图');
    subplot(2, 2, 2); imhist(I); title('原图直方图');
    subplot(2, 2, 3); imshow(s_out); title('中值滤波');
    subplot(2, 2, 4); imhist(s_out); title('中值滤波直方图');
end
