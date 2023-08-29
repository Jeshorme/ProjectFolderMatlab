function visualize_pca_features(image_data)
% VISUALIZE_PCA_FEATURES: 对掌纹图像进行PCA处理并可视化
% 输入参数:
% image_data: 掌纹图像数据，大小为MxNxC，其中M和N为图像尺寸，C为图像数量


% 对图像数据进行PCA处理
image_matrix = double(image_data);
[coeff, ~, ~] = pca(image_matrix');

% 提取前两个主成分作为新特征
new_features = coeff(:, 1:2);

% 投影图像数据到新特征空间
projected_data = new_features' * image_matrix;

% 可视化投影后的图像数据
figure;
scatter(projected_data(1, :), projected_data(2, :));
xlabel('Principal Component 1');
ylabel('Principal Component 2');
title('PCA Features Visualization');
grid on;

% 标记每个点的图像编号
for i = 1:num_images
    text(projected_data(1, i), projected_data(2, i), num2str(i), 'Color', 'red');
end

end
