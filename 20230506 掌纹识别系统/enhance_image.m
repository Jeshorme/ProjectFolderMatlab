function enhanced_img = enhance_image(input_img)
% ENHANCE_IMAGE: 使用CLAHE算法对图像进行增强
% 输入参数:
% input_img: 待增强图像
% 输出参数:
% enhanced_img: 增强后的图像

% 定义CLAHE算法的参数
clip_limit = 0.01; % 对比度限制
tile_size = [8, 8]; % 划分块的大小

% 转换图像为灰度图像
if size(input_img,3)==3
    gray_img = rgb2gray(input_img);
else
    gray_img=input_img;
end
% 应用CLAHE算法进行增强
enhanced_img = adapthisteq(gray_img, 'ClipLimit', clip_limit, 'NumTiles', tile_size);

% 转换图像类型
enhanced_img = im2uint8(enhanced_img);
imshow(enhanced_img)
end
