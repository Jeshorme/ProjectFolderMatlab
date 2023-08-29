trainImages = imageDatastore('Database','IncludeSubfolders',true,'LabelSource','foldernames');
trainImages.ReadFcn = @(filename) imresize(imread(filename), [128, 128]);
% 定义CNN网络模型
layers = [
imageInputLayer([128 128 3])
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
fullyConnectedLayer(2)
softmaxLayer
classificationLayer];

% 定义训练参数
options = trainingOptions('adam', ...
'InitialLearnRate',0.001, ...
'MaxEpochs',50, ...
'MiniBatchSize',128, ...
'Shuffle','every-epoch', ...
'Plots','training-progress');
str = '车牌的识别结果是：';
% 开始训练模型
fire_recognition_model = trainNetwork(trainImages,layers,options);
save('fire_recognition_model.mat','fire_recognition_model');