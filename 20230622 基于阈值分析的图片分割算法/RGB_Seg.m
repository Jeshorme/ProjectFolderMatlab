% 读取图像
image = imread('0341564ec1534f24191ff60a17e8a37.png'); % 替换为你的图像文件名

% 创建图形界面
figure('Name', 'RGB彩色图像分割界面展示', 'NumberTitle', 'off');

% 显示原图像
subplot(2, 3, 1);
imshow(image);
title('原图像');

% 获取R、G、B通道
R = image(:,:,1);
G = image(:,:,2);
B = image(:,:,3);

% 显示R通道
subplot(2, 3, 2);
imshow(R);
title('R通道');

% 显示G通道
subplot(2, 3, 3);
imshow(G);
title('G通道');

% 显示B通道
subplot(2, 3, 4);
imshow(B);
title('B通道');

% 设置颜色阈值
redThreshold = 10;   % 红色阈值
greenThreshold = 10; % 绿色阈值
blueThreshold = 10;  % 蓝色阈值

% 进行彩色分割
segmented_image = (R > redThreshold) & (G > greenThreshold) & (B > blueThreshold);

% 显示彩色分割结果
subplot(2, 3, 6);
imshow(segmented_image);
title('彩色分割结果');

% 调整子图间距
subplots = get(gcf, 'Children');
for i = 1:numel(subplots)
    subplotPos = get(subplots(i), 'Position');
    subplotPos(1) = subplotPos(1) - 0.05;
    subplotPos(2) = subplotPos(2) - 0.05;
    subplotPos(3) = subplotPos(3) + 0.05;
    subplotPos(4) = subplotPos(4) + 0.05;
    set(subplots(i), 'Position', subplotPos);
end

% 调整子图标题位置
titlePos = get(get(gca, 'Title'), 'Position');
titlePos(2) = titlePos(2) + 0.05;
set(get(gca, 'Title'), 'Position', titlePos);
