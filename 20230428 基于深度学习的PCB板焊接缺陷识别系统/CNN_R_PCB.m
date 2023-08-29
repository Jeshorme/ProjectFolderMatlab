% close all;
% clear all;
% 这个是CNN，

% 导入训练集
trainImages = imageDatastore('PCB_flaws','IncludeSubfolders',true,'LabelSource','foldernames');
trainImages.ReadFcn = @(filename)imresize(imread(filename), [32, 32]);


% 定义卷积神经网络架构
layers = [    imageInputLayer([32 32 3])
    
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
    'MaxEpochs',10, ...
    'MiniBatchSize',128, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress');

% 训练卷积神经网络
net = trainNetwork(trainImages,layers,options);
save('model','net')

% % 加载ResNet-18网络
% net = resnet18;
% 
% % 调整网络层
% numClasses = 5;
% lgraph = layerGraph(net);
% newLayers = [    
%     fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)    
%     softmaxLayer('Name','softmax')    
%     classificationLayer('Name','classoutput')];
% lgraph = removeLayers(lgraph, {'fc1000','prob','ClassificationLayer_predictions'});
% lgraph = addLayers(lgraph, newLayers);
% lgraph = connectLayers(lgraph,'pool5','fc');
% 
% % 定义训练参数
% miniBatchSize = 64;
% numEpochs = 6;
% learnRate = 0.001;
% options = trainingOptions('sgdm', ...
%     'MiniBatchSize',miniBatchSize, ...
%     'MaxEpochs',numEpochs, ...
%     'InitialLearnRate',learnRate, ...
%     'Shuffle','every-epoch', ...
%     'Verbose',true, ...
%     'Plots','training-progress');
% 
% %% 步骤3：训练和测试模型
% 
% % 训练模型
% net = trainNetwork(trainImages, lgraph, options);
% save('model_55555','net')

predictedLabels = classify(net,trainImages);

% 计算分类准确率
accuracy = sum(predictedLabels == trainImages.Labels) / numel(predictedLabels);
fprintf('分类准确率为 %.2f%%\n',accuracy*100);


