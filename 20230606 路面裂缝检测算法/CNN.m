% close all;
% clear all;
% 导入训练集和测试集

trainImages = imageDatastore('images','IncludeSubfolders',true,'LabelSource','foldernames');
testImages = imageDatastore('images','IncludeSubfolders',true,'LabelSource','foldernames');

% 定义卷积神经网络架构
layers = [    imageInputLayer([300 400 1])
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,64,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,128,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(5)
    softmaxLayer
    classificationLayer];

% 定义训练选项
options = trainingOptions('adam', ...
    'InitialLearnRate',0.001, ...
    'MaxEpochs',4, ...
    'MiniBatchSize',128, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress');

% 训练卷积神经网络
net = trainNetwork(trainImages,layers,options);
save('model-database_judge','net')

% 测试卷积神经网络
predictedLabels = classify(net,testImages);

% 计算分类准确率
accuracy = sum(predictedLabels == testImages.Labels) / numel(predictedLabels);
fprintf('分类准确率为 %.2f%%\n',accuracy*100);






