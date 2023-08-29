
% 读取图像
filename = 'solder_leakage_1.jpg'; % 替换为实际PCB图像文件名
pcb_image = imread(filename);

% 转换为灰度图像
gray_image = rgb2gray(pcb_image);

% 使用边缘检测算子进行预处理
edge_image = edge(gray_image, 'sobel');

% 设置Hough圆变换参数
radii_range = [10, 40]; % 根据实际焊点的大小调整
sensitivity = 0.9; % 用于调整检测的灵敏度，范围：0-1，越大检测越严格

% 进行Hough圆变换
[centers, radii] = imfindcircles(edge_image, radii_range, 'Sensitivity', sensitivity);

% 显示结果
imshow(pcb_image);
hold on;
viscircles(centers, radii, 'EdgeColor', 'b'); % 在检测到的焊点位置绘制圆
hold off;

% 其他代码与之前相同

% 显示结果
imshow(pcb_image);
hold on;
viscircles(centers, radii, 'EdgeColor', 'b'); % 在检测到的焊点位置绘制圆
hold off;

% 从原始图像中切出焊点并保存为图片
num_solder_points = size(centers, 1);
padding = 5; % 图片周围留一定的边距

for i = 1:num_solder_points
    x = round(centers(i, 1) - radii(i) - padding);
    y = round(centers(i, 2) - radii(i) - padding);
    width = round(2 * (radii(i) + padding));
    height = width;
    
    % 切出焊点
    solder_point = imcrop(pcb_image, [x, y, width, height]);
    
    % 保存图片
    output_filename = sprintf('焊点图片/solder_point_%d.png', i);
    imwrite(solder_point, output_filename);
end

