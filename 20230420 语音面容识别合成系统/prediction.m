% 设置文件夹路径和类别标签
folderPath = 'C:\Users\64148\Desktop\兼职工作文件夹\20230410（490）\traindata';  % 设置语音文件夹的路径
categories = {'猪咳嗽_trimmed', '猪叫声_trimmed', '猪打呼噜声_trimmed', '羊叫声_trimmed', '鸭叫声修改后_trimmed', '鸭叫声_trimmed', '水牛叫声_trimmed','猫叫声_trimmed','鸡叫声_trimmed','狗咳嗽声_trimmed','狗叫声_trimmed'};  % 设置类别标签
allLabels = categorical(categories);

% 读取语音文件并进行小波分解和短时傅里叶变换
allData = cell(0);
for i = 1:length(categories)
    category = categories{i};
    files = dir(fullfile(folderPath, category, '*.wav')); % 读取指定类别下的所有.wav文件
    for j = 1:length(files)
        filePath = fullfile(files(j).folder, files(j).name);
        [audio,Fs] = audioread(filePath);
        audio = audio(:,1);
        SampFreq = 8000;
        audio = resample(audio,SampFreq, Fs);
        Fs = 8000;
        [waveletCoeffs, ~] = wavedec(audio, 5, 'db4'); % 进行小波分解
        spectrogram = abs(stft(waveletCoeffs)); % 进行短时傅里叶变换
        image = mat2gray(spectrogram);% 将图像数据归一化到[0, 1]范围
        allData{end+1} = image;
%         allLabels{end+1} = category;
    end
end

% 创建卷积神经网络
layers = [
    imageInputLayer([size(spectrogram,1), size(spectrogram,2), 1]) % 输入层，根据短时傅里叶变换得到的图像大小设置
    convolution2dLayer(3,16,'Padding','same') % 卷积层
    reluLayer() % ReLU激活函数
    maxPooling2dLayer(2,'Stride',2) % 最大池化层
    convolution2dLayer(3,32,'Padding','same') % 卷积层
    reluLayer() % ReLU激活函数
    maxPooling2dLayer(2,'Stride',2) % 最大池化层
    fullyConnectedLayer(11) % 全连接层，输出类别数量
    softmaxLayer() % Softmax激活函数
    classificationLayer() % 分类层
];

% 设置训练选项
options = trainingOptions('sgdm', 'MaxEpochs', 200, 'MiniBatchSize', 64);
assert(numel(allData) == size(allLabels', 1), '输入数据和标签的数量不一致');
numData = numel(allData);
data = zeros(size(allData{1},1), size(allData{1},2), size(allData{1},3), numData);
for i = 1:numData
    data(:,:,:,i) = allData{i};
end
% 训练卷积神经网络
trainedNet = trainNetwork(data, allLabels, layers, options); % 使用 trainNetwork 函数进行模型训练

% 保存训练模型
save('trainedNet.mat', 'trainedNet')

% 批量识别部分
testpath = 'C:\Users\64148\Desktop\兼职工作文件夹\20230410（490）\two_catigories';
files = dir(fullfile(testpath, '*.wav')); % 读取指定类别下的所有.wav文件
for j = 1:length(files)
    filePath = fullfile(files(j).folder, files(j).name);
    [y,Fs] = audioread(filePath);
    y = y(:,1);
    SampFreq = 8000;
    y = resample(y,SampFreq, Fs);
    Fs = 8000;
    [waveletCoeffs, ~] = wavedec(y, 5, 'db4'); % 进行小波分解
    spectrogram = abs(stft(waveletCoeffs)); % 进行短时傅里叶变换
    image = mat2gray(spectrogram);% 将图像数据归一化到[0, 1]范围
    predictedLabels = classify(trainedNet, image);
    if predictedLabels == '猪咳嗽_trimmed'
        disp(files(j).name)
    end
end

