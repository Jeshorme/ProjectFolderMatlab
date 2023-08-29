% 读取图像
image = imread('001_0016.png');

% 转换为HSV颜色空间
hsv_image = rgb2hsv(image);

% 定义红色和蓝色阈值
red_hue_low = 0.9;
red_hue_high = 1.0;
blue_hue_low = 0.55;
blue_hue_high = 0.65;

% 分离颜色通道
hue = hsv_image(:,:,1);
saturation = hsv_image(:,:,2);
value = hsv_image(:,:,3);

% 创建一个空白的二值图像，用于存储提取出的交通标志
binary_image = false(size(hue));

% 提取红色和蓝色区域
red_region = (hue >= red_hue_low | hue <= red_hue_high) & saturation > 0.4 & value > 0.4;
blue_region = (hue >= blue_hue_low & hue <= blue_hue_high) & saturation > 0.4 & value > 0.4;
binary_image = binary_image | red_region | blue_region;

% 进行形态学操作：开运算，用于去除噪声
se = strel('disk', 3);
binary_image = imopen(binary_image, se);

% 提取连通区域
connected_components = bwconncomp(binary_image);

% 根据面积和几何形状筛选交通标志候选区域
area_min = 100;
area_max = 10000;
regions = regionprops(connected_components, 'BoundingBox', 'Area', 'Eccentricity', 'Extent');
traffic_signs = false(size(hue));
for k = 1:length(regions)
    if regions(k).Area > area_min && regions(k).Area < area_max && regions(k).Eccentricity < 0.7 && regions(k).Extent > 0.6
        bbox = regions(k).BoundingBox;
        traffic_signs(round(bbox(2)):round(bbox(2)+bbox(4)), round(bbox(1)):round(bbox(1)+bbox(3))) = true;
    end
end

% 显示原始图像和提取出的交通标志
figure;
subplot(1, 2, 1);
imshow(image);
title('Original Image');

subplot(1, 2, 2);
imshow(traffic_signs);
title('Detected Traffic Signs');
