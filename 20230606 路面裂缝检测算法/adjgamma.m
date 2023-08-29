function newim = adjgamma(im, g)
% 根据输入图像和Gamma参数调整图像亮度
% 参数：
%   im：输入图像
%   g：Gamma参数（可选，默认为1）
% 返回值：
%   newim：调整后的图像

if nargin < 2
    g = 1;  % 如果未提供Gamma参数，则默认为1
end

if g <= 0
    error('Gamma参数必须大于0');  % 检查Gamma参数是否大于0，如果小于等于0则抛出错误
end

if ndims(im) == 3
    I = rgb2gray(im);  % 如果图像是RGB格式，则转换为灰度图像
else
    I = im;  % 否则，图像已经是灰度图像
end

if isa(I, 'uint8')
    newim = double(I);  % 如果图像是uint8类型，转换为double类型
else
    newim = I;  % 否则，图像已经是double类型
end

newim = newim - min(min(newim));  % 将图像灰度值减去最小值，使得最小值变为0
newim = newim ./ max(max(newim));  % 将图像灰度值除以最大值，使得最大值变为1
newim = newim .^ (1/g);  % 对图像进行Gamma校正，通过将每个像素的值提升到1/g次幂来调整亮度

% 返回调整后的图像
