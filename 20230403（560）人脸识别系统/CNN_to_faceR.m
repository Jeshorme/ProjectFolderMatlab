% close all;
% clear all;
% 导入训练集和测试集
trainImages = imageDatastore('orl_faces','IncludeSubfolders',true,'LabelSource','foldernames');
testImages = imageDatastore('orl_faces','IncludeSubfolders',true,'LabelSource','foldernames');

% 定义卷积神经网络架构
layers = [    imageInputLayer([112 92 1])
    
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
    
    fullyConnectedLayer(40)
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
save('model','net')
% load('C:\Users\64148\Desktop\兼职工作文件夹\20230403\手撕版/model','net')
% 测试卷积神经网络
predictedLabels = classify(net,testImages);

% 计算分类准确率
accuracy = sum(predictedLabels == testImages.Labels) / numel(predictedLabels);
fprintf('分类准确率为 %.2f%%\n',accuracy*100);

% 预测人脸所属的类别
faceDetector = vision.CascadeObjectDetector;
face = imread('1.bmp');
bbox = faceDetector(face);
face = imresize(face,[112 92]);
label = classify(net,face);
img = insertObjectAnnotation(face,'rectangle',bbox,label);
imshow(img);


% % 在图像中显示人脸边界框和预测结果
% img = insertObjectAnnotation(img,'rectangle',bbox,label);
% 
% % 使用训练好的卷积神经网络进行人脸识别
% faceDetector = vision.CascadeObjectDetector;
% camera = webcam;
% while true
%     img = snapshot(camera);
%     bbox = faceDetector(img);
%     if ~isempty(bbox)
%         % 裁剪出人脸图像
%         face = imcrop(img,bbox(1,:));
%         % 将人脸图像调整为卷积神经网络所需的尺寸
%         face = imresize(face,[112 92]);
%         % 预测人脸所属的类别
%         label = classify(net,face);
%         % 在图像中显示人脸边界框和预测结果
%         img = insertObjectAnnotation(img,'rectangle',bbox,label);
%     end
%     % 在窗口中显示图像
%     imshow(img);
% end



