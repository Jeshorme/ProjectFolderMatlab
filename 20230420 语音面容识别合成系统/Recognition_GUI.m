function face_recognition_GUI
% 创建主界面窗口
hFig = figure('Name','人脸识别系统','Units','pixels','Position',[300 300 600 500],'MenuBar','none','ToolBar','none','NumberTitle','off','Resize','off');
% 添加图像显示区域
hAxes = axes('Parent',hFig,'Units','pixels','Position',[50 100 300 300]);
% 添加实时摄像头图像显示区域
hCameraAxes = axes('Parent',hFig,'Units','pixels','Position',[400 100 150 150]);
% 添加捕获图像按钮
uicontrol(hFig,'Style','pushbutton','String','捕获图像','Units','pixels','Position',[400 50 100 30],'Callback',@captureImage);
% 添加语音采集按钮
uicontrol(hFig,'Style','pushbutton','String','语音采集','Units','pixels','Position',[300 50 100 30],'Callback',@voicegetting);
% 添加语音识别按钮
uicontrol(hFig,'Style','pushbutton','String','语音识别是否开门','Units','pixels','Position',[200 50 100 30],'Callback',@voiceRecognition);
% 添加开始识别按钮
uicontrol(hFig,'Style','pushbutton','String','人脸识别','Units','pixels','Position',[500 50 100 30],'Callback',@faceRecognition);
% 初始化全局变量
% global net;
global faceDetector;
global camera;
global speech;
global fs;
global facelabel;
% % 导入已经训练好的卷积神经网络模型
% net = load('model.mat');

% 创建人脸检测器
faceDetector = vision.CascadeObjectDetector;

% 创建摄像头
camera = webcam;


% 回调函数，用于捕获图像
    function captureImage(~,~)
        % 读取摄像头图像
        img = snapshot(camera);
        % 显示摄像头图像
        imshow(img,'Parent',hCameraAxes);
        % 保存图像到本地
        imwrite(img,'captured_image.jpg');
    end

% 回调函数，用于开始人脸识别
    function faceRecognition(~,~)
        net = load('model.mat');
        % 读取本地已保存的图像
        img = imread('captured_image.jpg');
        % 在图像上进行人脸检测
        bbox = faceDetector(img);
        if ~isempty(bbox)
            % 裁剪出人脸图像
            face = imcrop(img,bbox(1,:));
            face = rgb2gray(face);
            % 将人脸图像调整为卷积神经网络所需的尺寸
            face = imresize(face,[112 92]);
            % 预测人脸所属的类别
            facelabel = classify(net.net,face);
            % 在图像中显示人脸边界框和预测结果
            img = insertObjectAnnotation(img,'rectangle',bbox,facelabel,'FontSize',50,'TextColor','red');
            % 显示结果图像
            imshow(img,'Parent',hAxes);
        else
            % 如果未检测到人脸，则显示提示信息
            msgbox('未检测到人脸，请重新捕获图像','提示','modal');
        end
    end

    
    
    function voicegetting(~,~)
        % 初始化麦克风
        fs = 16000; % 采样率
        mic = audiorecorder(fs, 16, 1); % 创建一个音频录制器对象

        % 开始录制语音信号
        disp('开始录制语音信号...');
        recordblocking(mic, 5); % 录制5秒钟的语音

        % 获取录制的语音信号
        speech = getaudiodata(mic);

        % 播放录制的语音信号
        h = msgbox('播放录制的语音信号...','提示','modal');
        sound(speech, fs);
        pause(5)
        close(h)
    end
    function voiceRecognition(~,~)
        % 设置文件夹路径和类别标签
        folderPath = 'C:\Users\64148\Desktop\兼职工作文件夹\20230420（700）\自组10个人语音包作为数据集（cutting）';  % 设置语音文件夹的路径
        categories = {'s1', 's2', 's3', 's4', 's5', 's6', 's7','s8','s9','s10','s11'};  % 设置类别标签
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
        options = trainingOptions('sgdm', 'MaxEpochs', 50, 'MiniBatchSize', 64);
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

        % 识别某一个文件夹下所有声音，并找出目标声音
%         testpath = 'C:\Users\64148\Desktop\兼职工作文件夹\20230410（490）\Audios_cut\水牛叫声_trimmed.wav';
%         [audio,Fs] = audioread(testpath);
        audio = speech;
        Fs = fs;
        audio = audio(1:3*fs,1);
        SampFreq = 8000;
        audio = resample(audio,SampFreq, Fs);
        Fs = 8000;
        [waveletCoeffs, ~] = wavedec(audio, 5, 'db4'); % 进行小波分解
        spectrogram = abs(stft(waveletCoeffs)); % 进行短时傅里叶变换
        image = mat2gray(spectrogram);% 将图像数据归一化到[0, 1]范围

        voicepredictedLabels = classify(trainedNet, image)
        if voicepredictedLabels == facelabel
            msg = ['欢迎您:  ',char(voicepredictedLabels),' 同学!   正在为您开门中，请稍后……']
            msgbox(msg,'准备开门','modal')
        else
            
            msgbox('声音人脸不匹配，请重试……','提示','modal')
        end

    end
     end

