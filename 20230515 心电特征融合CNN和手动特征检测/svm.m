% % 生成随机数据集
% rng(1); % 设置随机种子，以确保结果可复现
% N = 102; % 样本数量
% X = randn(N, 2, 128); % 特征向量
% Y = ones(N, 1); % 类别标签
% 
% % % 随机选择一半的样本标签为-1
% % half_N = N / 2;
% % Y(half_N+1:end) = -1;
load('Xdata.mat'); % 特征向量
X = Xdata;
load('Ydata.mat'); % 类别标签
Y = Ydata;
N = size(X,1); % 样本数量
% 打乱数据顺序
idx = randperm(N);
X = X(idx, :);
Y = Y(idx);
% 划分数据集为训练集和测试集
train_ratio = 0.8; % 训练集比例
train_size = floor(train_ratio * N);
train_X = X(1:train_size, :);
train_Y = Y(1:train_size);
test_X = X(train_size+1:end, :);
test_Y = Y(train_size+1:end);

% 训练SVM模型
SVMModel = fitcsvm(train_X, train_Y);

% 预测测试集
predicted_labels = predict(SVMModel, test_X);

% 计算分类准确率
accuracy = sum(predicted_labels == test_Y) / numel(test_Y);
disp(['分类准确率：', num2str(accuracy)]);
% 计算混淆矩阵
confusionMat = confusionmat(test_Y, predicted_labels);

% 计算敏感度、特异度和准确率
truePositive = confusionMat(1, 1);
falseNegative = confusionMat(1, 2);
falsePositive = confusionMat(2, 1);
trueNegative = confusionMat(2, 2);

sensitivity = truePositive / (truePositive + falseNegative);
specificity = trueNegative / (trueNegative + falsePositive);
accuracy = (truePositive + trueNegative) / sum(confusionMat(:));

disp(['敏感度（Sensitivity）：', num2str(sensitivity)]);
disp(['特异度（Specificity）：', num2str(specificity)]);
disp(['准确率（Accuracy）：', num2str(accuracy)]);

% 绘制混淆矩阵
figure;
heatmap(confusionMat, 'Colormap', gray, 'ColorbarVisible', 'off', 'XLabel', 'Predicted label', 'YLabel', 'True label', 'Title', 'Confusion Matrix');
