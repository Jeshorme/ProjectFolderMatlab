trainImages = imageDatastore('C:\Users\64148\Desktop\兼职工作文件夹\20230506（1800）\掌纹数据\training','IncludeSubfolders',true,'LabelSource','foldernames');
trainImages.ReadFcn = @(filename) imresize(imread(filename), [128, 128]);
% 定义CNN网络模型
layers = [
imageInputLayer([128 128 1])
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
fullyConnectedLayer(89)
softmaxLayer
classificationLayer];

% 定义训练参数
options = trainingOptions('adam', ...
'InitialLearnRate',0.001, ...
'MaxEpochs',50, ...
'MiniBatchSize',128, ...
'Shuffle','every-epoch', ...
'Plots','training-progress');
% 开始训练模型
palmprint_recognitionModel = trainNetwork(trainImages,layers,options);
save('palmprint_recognitionModel.mat','palmprint_recognitionModel');