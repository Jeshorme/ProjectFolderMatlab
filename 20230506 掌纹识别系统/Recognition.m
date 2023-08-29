% 步骤1：数据准备
main_folder = '掌纹数据/train'; % 主文件夹路径，包含不同类别的子文件夹
sub_folders = dir(main_folder);
num_classes = numel(sub_folders) - 2; % 减去.和..两个特殊目录

% 图像大小假设为100x100像素
image_height = 123;
image_width = 123;

% 创建空矩阵来存储图像数据和标签
X = []; % 存储图像数据
labels = []; % 存储标签

% 逐个读取子文件夹中的图像并进行数据增强和转换
for i = 3:numel(sub_folders) % 跳过.和..两个特殊目录
    class_folder = fullfile(main_folder, sub_folders(i).name);
    image_files = dir(fullfile(class_folder, '*.jpg')); % 假设图像格式为JPG
    num_images = numel(image_files);
    
    % 逐个读取图像并进行数据增强和转换
    for j = 1:num_images
        image_path = fullfile(class_folder, image_files(j).name);
        image = imread(image_path);
        image = imresize(image, [image_height, image_width]); % 调整大小为指定大小
%         image = rgb2gray(image); % 转换为灰度图像
        
        % 进行数据增强
        augmented_images = zeros(image_height, image_width, 8); % 8个增强后的图像
        
        % 图像旋转
        augmented_images(:,:,1) = imrotate(image, 15);
        augmented_images(:,:,2) = imrotate(image, -15);
        
        % 图像平移
        augmented_images(:,:,3) = imtranslate(image, [5 5]);
        augmented_images(:,:,4) = imtranslate(image, [-5 -5]);
        
        % 图像缩放
        augmented_images(:,:,5) = imresize(image, 0.9);
        augmented_images(:,:,6) = imresize(image, 1.1);
        
        % 图像翻转
        augmented_images(:,:,7) = flipud(image);
        augmented_images(:,:,8) = fliplr(image);
        
        % 将增强后的图像转换为向量并存储
        for k = 1:8
            X = [X; augmented_images(:,:,k)];
            labels = [labels; i-2]; % 标签为子文件夹的索引减去2
        end
    end
end


% 步骤2：数据预处理
X = double(X);
X = zscore(X);

% 步骤3：PCA降维
[coeff, score, latent] = pca(X);

% 步骤4：特征选择
K = 50; % 选择前50个主成分作为特征向量
selected_features = coeff(:, 1:K);

% % 步骤5：训练分类器
% knn_model = fitcknn(score(:, 1:K), labels, 'NumNeighbors', 4); % 使用KNN分类器训练，这里选择K=3
% 
% % 步骤6：测试
% test_image = imread('010_1_r.jpg'); % 读取测试图像
% test_image = imresize(test_image, [image_height, image_width]); % 调整大小为训练图像的大小
% if size(test_image,3)==3
%     test_image = rgb2gray(test_image); % 转换为灰度图像
% end
% 
% 
% test_features = (double(test_image(:)) - mean(X)) / std(X); % 对测试图像进行标准化处理
% test_score = test_features' * selected_features; % 通过投影得到测试图像的特征向量
% prediction = predict(knn_model, test_score); % 使用

% 步骤5：训练分类器
svm_model =  fitcecoc(score(:, 1:K), labels); % 使用SVM分类器训练

% 步骤6：测试
test_image = imread('007_5.bmp'); % 读取测试图像
test_image = imresize(test_image, [image_height, image_width]); % 调整大小为训练图像的大小
% test_image = rgb2gray(test_image); % 转换为灰度图像
test_features = (double(test_image(:)) - mean(X)) / std(X); % 对测试图像进行标准化处理
test_score = test_features' * selected_features; % 通过投影得到测试图像的特征向量
prediction = predict(svm_model, test_score); % 使用分类器进行预测
disp(['预测结果：' num2str(prediction)]);

