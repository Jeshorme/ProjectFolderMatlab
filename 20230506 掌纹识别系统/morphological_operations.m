function processed_img = morphological_operations(input_img)
% MORPHOLOGICAL_OPERATIONS: 对二值图像进行膨胀和腐蚀处理
% 输入参数:
% input_img: 待处理的二值图像
% 输出参数:
% processed_img: 处理后的二值图像

% 定义膨胀和腐蚀的结构元素
se = strel('disk', 2); % 定义一个半径为3的圆形结构元素

% 对二值图像进行膨胀和腐蚀操作
dilated_img = imdilate(input_img, se);
eroded_img = imerode(input_img, se);

% 转换图像类型
dilated_img = im2uint8(dilated_img);
eroded_img = im2uint8(eroded_img);

% 将膨胀和腐蚀处理的结果进行合并
processed_img = dilated_img & eroded_img;
imshow(processed_img);
end
