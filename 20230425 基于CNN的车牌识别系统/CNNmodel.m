% 准备训练数据
trainImages = imageDatastore('自建车牌数据库','IncludeSubfolders',true,'LabelSource','foldernames');
% 定义CNN网络模型
layers = [
    imageInputLayer([32 32 3])
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)
    convolution2dLayer(3, 64, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)
    convolution2dLayer(3, 128, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(7)
    softmaxLayer
    classificationLayer];

% 定义训练参数
options = trainingOptions('adam', ...
    'InitialLearnRate',0.001, ...
    'MaxEpochs',5, ...
    'MiniBatchSize',128, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress');

% 开始训练模型
char_recognition_model = trainNetwork(trainImages,layers,options);

% 保存训练好的模型
save('char_recognition_model.mat', 'char_recognition_model');
