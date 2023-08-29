
clc; 
close all; 
clear all; 
I=imread('0341564ec1534f24191ff60a17e8a37.png'); 
[m,n,d]=size(I); 
 
level=15;%设置阈值 
level2=70;%设置阈值 
 
for i=1:m 
    for j=1:n 
        if((I(i,j,1)-I(i,j,2)>level2)&&(I(i,j,1)-I(i,j,3)>level2)) 
            r(i,j,1)=I(i,j,1); 
            r(i,j,2)=I(i,j,2); 
            r(i,j,3)=I(i,j,3); 
       else  
            r(i,j,1)=255; 
            r(i,j,2)=255; 
            r(i,j,3)=255; 
        end 
    end 
end 
 
figure; 
subplot(2,3,1);imshow(I);title('原图像'); 
subplot(2,3,2);imshow(r);title('提取红分量后');%显示提取红分量后的图 
 
 
%提取绿分量，不满足阈值的变为白色 
for i=1:m 
    for j=1:n 
        if((I(i,j,2)-I(i,j,1)>level)&&(I(i,j,2)-I(i,j,3)>level)) 
            g(i,j,1)=I(i,j,1); 
            g(i,j,2)=I(i,j,2); 
            g(i,j,3)=I(i,j,3); 
        else 
            g(i,j,1)=255; 
            g(i,j,2)=255; 
            g(i,j,3)=255; 
        end 
    end 
end 
 
subplot(2,3,3);imshow(g);title('提取绿分量后'); 
 
 
%提取蓝色分量 
for i=1:m 
    for j=1:n 
        if((I(i,j,3)-I(i,j,1)>level)&&(I(i,j,3)-I(i,j,2)>level)) 
                    b(i,j,1)=I(i,j,1); 
                    b(i,j,2)=I(i,j,2); 
                    b(i,j,3)=I(i,j,3); 
        else 
            b(i,j,1)=255; 
            b(i,j,2)=255; 
            b(i,j,3)=255; 
        end 
    end 
end 
 
subplot(2,3,4);imshow(b);title('提取蓝色分量后');

% 设置颜色阈值
redThreshold = 10;   % 红色阈值
greenThreshold = 10; % 绿色阈值
blueThreshold = 10;  % 蓝色阈值

% 获取R、G、B通道
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

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
