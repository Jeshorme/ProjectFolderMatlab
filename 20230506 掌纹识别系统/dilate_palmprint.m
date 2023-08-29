function dilate_palmprint(image)
% DILATE_PALMPRINT: 对掌纹图像进行膨胀处理并显示结果
% 输入参数:
% image: 掌纹图像

% 转换图像为二值图像
binary_image = imbinarize(image);

% 定义膨胀操作的结构元素
se = strel('disk', 2); % 膨胀半径为5个像素的圆形结构元素

% 对图像进行膨胀处理
dilated_image = imdilate(binary_image, se);

% 显示原始图像和膨胀处理后的图像
figure;
subplot(1, 2, 1);
imshow(binary_image);
title('原始图像');
subplot(1, 2, 2);
imshow(dilated_image);
title('膨胀处理后的图像');

end
