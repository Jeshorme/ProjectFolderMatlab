trainImages = imageDatastore('Database','IncludeSubfolders',true,'LabelSource','foldernames');
trainImages.ReadFcn = @(filename) imresize(imread(filename), [128, 128]);

im_wight=128;
im_height=128;
im_chanel = 3;
numclass=43;
kernelsize=3;
numfilter1=32;
numfilter2=64;
numfilter3=128;
poolingsize=2;
stride=2;
% 定义CNN网络模型
layers = [
imageInputLayer([im_wight im_height im_chanel])

convolution2dLayer(kernelsize, numfilter1, 'Padding', 'same')
batchNormalizationLayer
reluLayer
maxPooling2dLayer(poolingsize, 'Stride', stride)

convolution2dLayer(kernelsize, numfilter2, 'Padding', 'same')
batchNormalizationLayer
reluLayer
maxPooling2dLayer(poolingsize, 'Stride', stride)

convolution2dLayer(kernelsize, numfilter3, 'Padding', 'same')
batchNormalizationLayer
reluLayer
maxPooling2dLayer(poolingsize, 'Stride', stride)

convolution2dLayer(kernelsize, numfilter3, 'Padding', 'same')
batchNormalizationLayer
reluLayer
maxPooling2dLayer(poolingsize, 'Stride', stride)

convolution2dLayer(kernelsize, numfilter3, 'Padding', 'same')
batchNormalizationLayer
reluLayer
maxPooling2dLayer(poolingsize, 'Stride', stride)

convolution2dLayer(kernelsize, numfilter3, 'Padding', 'same')
batchNormalizationLayer
reluLayer

fullyConnectedLayer(numclass)
softmaxLayer
classificationLayer];

learningrate=0.001;
epoch=3;
batchsize=128;
% 定义训练参数
options = trainingOptions('adam', ...
'InitialLearnRate',learningrate, ...
'MaxEpochs',epoch, ...
'MiniBatchSize',batchsize, ...
'Shuffle','every-epoch', ...
'Plots','training-progress');
% 开始训练模型
model = trainNetwork(trainImages,layers,options);
save('model.mat','model');
image = imread('C:\Users\64148\Desktop\兼职工作文件夹\交通标志\数据集\000_1_0001.png');
image = imresize(image,[128 128]);
label = classify(model,image)