%% 步骤1：准备数据集

% 定义数据集路径
dataDir = 'C:\Users\64148\Desktop\兼职工作文件夹\20230407（1200）\Resnet-18图片识别系统实现\CIFAR-10-matlab\train';
% 将图像数据集分成训练集、验证集和测试集
imds = imageDatastore(dataDir,'IncludeSubfolders',true,'LabelSource','foldernames');
[imdsTrain, imdsValidation] = splitEachLabel(imds, 0.8, 0.2);

% 对图像进行预处理，例如调整图像大小、归一化和数据增强
inputSize = [224, 224, 3];
augmenter = imageDataAugmenter('RandXReflection',true,'RandYReflection',true,'RandRotation',[-15,15]);
imdsTrain = augmentedImageDatastore(inputSize, imdsTrain, 'DataAugmentation',augmenter);
imdsValidation = augmentedImageDatastore(inputSize, imdsValidation);

%% 步骤2：加载和调整ResNet-18网络

% 加载ResNet-18网络
net = resnet18;

% 调整网络层
numClasses = 10;
lgraph = layerGraph(net);
newLayers = [    
    fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)    
    softmaxLayer('Name','softmax')    
    classificationLayer('Name','classoutput')];
lgraph = removeLayers(lgraph, {'fc1000','prob','ClassificationLayer_predictions'});
lgraph = addLayers(lgraph, newLayers);
lgraph = connectLayers(lgraph,'pool5','fc');

% 定义训练参数
miniBatchSize = 128;
numEpochs = 6;
learnRate = 0.001;
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',numEpochs, ...
    'InitialLearnRate',learnRate, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',floor(numel(imdsTrain.Files)/miniBatchSize), ...
    'Verbose',true, ...
    'Plots','training-progress');

%% 步骤3：训练和测试模型

% 训练模型
% trainedNet = trainNetwork(imdsTrain, lgraph, options);
% save('model_1','trainedNet')
% 测试模型
load('model.mat','trainedNet');
net=trainedNet;
dataDirtest = 'C:\Users\64148\Desktop\兼职工作文件夹\20230407（1200）\Resnet-18图片识别系统实现\CIFAR-10-matlab\test';
imdsTest1 = imageDatastore(dataDirtest,'IncludeSubfolders',true,'LabelSource','foldernames');
inputSize = [224, 224, 3];
imdsTest = augmentedImageDatastore(inputSize, imdsTest1);
predictedLabels = classify(net, imdsTest);
accuracy = mean(predictedLabels == imdsTest1.Labels);
fprintf('Test Accuracy: %.2f%%\n', accuracy * 100);