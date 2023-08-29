function edge_img = segment_image(input_img)
% SEGMENT_IMAGE: 使用Canny算法对图像进行分割
% 输入参数:
% input_img: 待分割图像
% 输出参数:
% edge_img: 分割后的边缘图像

% 转换图像为灰度图像
if size(input_img,3)==3
    gray_img = rgb2gray(input_img);
else
    gray_img=input_img;
end
% 使用Canny算法进行边缘检测
sigma = 1.0; % 高斯滤波的标准差
threshold = [0.1, 0.4]; % 阈值参数
edge_img = edge(gray_img, 'canny', threshold, sigma);

% 转换图像类型
edge_img = im2uint8(edge_img);
end
