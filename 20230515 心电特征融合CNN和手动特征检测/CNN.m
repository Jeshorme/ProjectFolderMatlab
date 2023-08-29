% 导入训练集和测试集
% 创建ImageDatastore对象
image_datastore = imageDatastore('ECG_Features', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
image_datastore.ReadFcn = @(filename) imresize(imread(filename), [224, 224]);
% 定义训练集和测试集的比例
train_ratio = 0.8; % 训练集占总数据集的比例

% 将数据集分割为训练集和测试集
[trainImages, testImages] = splitEachLabel(image_datastore, train_ratio, 'randomized');


% 定义卷积神经网络架构
layers = [    imageInputLayer([224 224 3])
    
    convolution2dLayer([3 3],64,'Padding','same')
    convolution2dLayer([3 3],64,'Padding','same')
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer([3 3],128,'Padding','same')
    convolution2dLayer([3 3],128,'Padding','same')
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer([3 3],256,'Padding','same')
    convolution2dLayer([3 3],256,'Padding','same')
    maxPooling2dLayer(2,'Stride',2)
    
    fullyConnectedLayer(512)
    fullyConnectedLayer(128,'Name','fc128')
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

% 定义训练选项
options = trainingOptions('adam', ...
    'InitialLearnRate',0.0001, ...
    'MaxEpochs',20, ...
    'MiniBatchSize',16, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress');

% 训练卷积神经网络
net = trainNetwork(trainImages,layers,options);
save('CNNmodel','net')
% 测试卷积神经网络
predictedLabels = classify(net,testImages);
% 计算分类准确率
accuracy = sum(predictedLabels == testImages.Labels) / numel(predictedLabels);
fprintf('分类准确率为 %.2f%%\n',accuracy*100);




