function data = preprocessData(data, inputSize)
% 读取图像数据和边界框
I = data{1};
bbox = data{2};

% 缩放图像，保持纵横比不变
I = imresize(I, [NaN, inputSize(1)]);

% 计算缩放比例并更新边界框
scaleFactor = size(I, 1) / size(data{1}, 1);
bbox = bbox * scaleFactor;

% 裁剪图像
I = imcrop(I, bbox);

% 将数据和边界框作为元胞数组返回
data = {I, bbox};
end
