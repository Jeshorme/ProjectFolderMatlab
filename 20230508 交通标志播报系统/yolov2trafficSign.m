% data = load('vehicleTrainingData.mat');
% trainingData = data.vehicleTrainingData;

load('signLabels.mat');
tableName={'imageFilename','sign'};
filesname=gTruth.DataSource.Source;
flaw = table2cell(gTruth.LabelData);
trainingData =  table(filesname,flaw,'VariableNames',tableName);


rng(0);
shuffledIdx = randperm(height(trainingData));
trainingData = trainingData(shuffledIdx,:);
imds = imageDatastore(trainingData.imageFilename);
blds = boxLabelDatastore(trainingData(:,2:end));

ds = combine(imds, blds);

% 定义输入大小、类别数、锚框数、特征提取网络和特征图层
inputSize = [224 224 3];
numClasses = 1;
numAnchors = 5;
featureExtractionNetwork = resnet18;
featureLayer = 'res5b_relu';

% 估计锚框
[anchorBoxes, meanIoU] = estimateAnchorBoxes(blds, numAnchors)

anchorBoxes= [153   169
    81    82
   218   222
   107   103
   128   148];

% 创建 YOLOv2 网络
lgraph = yolov2Layers(inputSize, numClasses, anchorBoxes, featureExtractionNetwork, featureLayer);
analyzeNetwork(lgraph)

% 训练选项
options = trainingOptions('sgdm',...
          'InitialLearnRate',0.001,...
          'Verbose',true,...
          'MiniBatchSize',16,...
          'MaxEpochs',60,...
          'Shuffle','never',...
          'VerboseFrequency',30,...
          'CheckpointPath',tempdir);

% 训练 YOLOv2 目标检测器
[detector,info] = trainYOLOv2ObjectDetector(ds,lgraph,options);
save('trafficsigndetector.mat','detector');
% 在测试数据上进行目标检测并评估性能
detectionResults = detect(detector, ds);
[ap, recall, precision] = evaluateDetectionPrecision(detectionResults, ds);

% % 绘制精度-召回率曲线
% figure;
% plot(recall, precision);
% xlabel('Recall');
% ylabel('Precision');
% grid on;
% title(sprintf('Average Precision = %.2f', ap));

% 可视化检测结果
I = imread(trainingData.imageFilename{2});
I = imresize(I, inputSize(1:2));
[bboxes, scores] = detect(detector, I);
I = insertObjectAnnotation(I, 'rectangle', bboxes, scores);
figure;
imshow(I);
