function s_out = hist_con(s_in, flag)
% 输入参数s_in为图像数据，flag为是否显示结果的标志位
% 如果未提供flag参数，默认为0，不显示结果

if nargin < 2
    flag = 0;
end

% 判断输入图像的维度，如果为3维则将其转换为灰度图像
if ndims(s_in) == 3
    I = rgb2gray(s_in);
else
    I = s_in;
end

% 对灰度图像进行直方图均衡化
s_out = histeq(I);

% 如果flag为真，则显示原图、原图直方图、均衡化结果和均衡化结果直方图
if flag
    figure;
    subplot(2, 2, 1); imshow(I); title('原图');
    subplot(2, 2, 2); imhist(I); title('原图直方图');
    subplot(2, 2, 3); imshow(s_out); title('均衡化结果');
    subplot(2, 2, 4); imhist(s_out); title('均衡化结果直方图');
end
