%对原始数据进行预处理
data = imread('010_1_r.jpg');
subplot(1,2,1)
imshow(data)
title('原始图像')
%图像灰度化
data =data;
data = im2double(data);
%原始图像展示
subplot(1,2,2)
imshow(data)
title('原始图像灰度图')

% %=========================================================================
% %进行svd分解
% [V,D] = eig(data'*data);
% [S,D_index] = sort(diag(sqrt(D)),'descend');
% S = diag(S);
% V=V(:, D_index);
% U = data * V * S^-1;
% %获得对应的usv
% 
% cul = 0;
% S_sum = sum(sum(S));
% for i = 1:length(S)
%     cul = cul + S(i,i)/S_sum;
%     if cul > 0.9
%         break
%     end
% end
% disp(['提取累积贡献率大于90%的奇异值的个数为   ' num2str(i)])
% 
% %展示结果
% V = V';
% %生成新的数据
% majorData = U(:,1:i) * S(1:i,1:i) * V(1:i,:);
% subplot(2,2,3)
% imshow(majorData)
% title('svd提取主要特征之后的图像')

%=========================================================================
%进行PCA分解
d_mean = mean(data);
d_mean(length(data(:,1)),length(d_mean)) = 0;
for j = 1:length(d_mean)
    d_mean(:,j) = d_mean(1,j);  
end
data_mean = data-d_mean;
temp = cov(data_mean);
[V,D] = eig(temp);
[S,D_index] = sort(diag(sqrt(D)),'descend');
S = diag(S);
V=V(:, D_index);


cul = 0;
S_sum = sum(sum(S));
V = V(:,1:3);
%展示结果
finData =data_mean * V;
%生成新的数据
majorData = finData*V'+ d_mean;
subplot(1,2,2)
imshow(majorData)
title('PCA提取主要特征之后的图像')
