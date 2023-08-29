function myGUI
    % 创建一个figure窗口
    f = figure('Name', '基于ANN的车牌号码识别系统','Position', [200, 200, 850, 500]);

    % 创建文本框
    ResultText = uicontrol('Style', 'text', 'String', '车牌识别结果：', 'Position', [200, 140, 400, 40], 'FontSize', 20);


    % 创建按钮
    uicontrol('Style', 'pushbutton', 'String', '打开车牌图片文件', 'Position', [20, 160, 150, 30], 'Callback', @openImage);
    uicontrol('Style', 'pushbutton', 'String', '车牌定位', 'Position', [20, 120, 150, 30], 'Callback', @findCarPlate);
    uicontrol('Style', 'pushbutton', 'String', '车牌字符分割', 'Position', [20, 80, 150, 30], 'Callback', @segCarPlate);
    uicontrol('Style', 'pushbutton', 'String', '使用ANN模型识别车牌', 'Position', [20, 40, 150, 30], 'Callback', @recognizeCarPlate);

    % 创建图形显示区域
    originalAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [50, 240, 350, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '车牌原图:', 'Position', [170, 470, 100, 20]);
    PlateAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [460, 240, 350, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '车牌定位图片:', 'Position', [580, 470, 100, 20]);
    seg1Axes = axes('Parent', f, 'Units', 'pixels', 'Position', [200, 20, 80, 80]);
    seg2Axes = axes('Parent', f, 'Units', 'pixels', 'Position', [290, 20, 80, 80]);
    seg3Axes = axes('Parent', f, 'Units', 'pixels', 'Position', [380, 20, 80, 80]);
    seg4Axes = axes('Parent', f, 'Units', 'pixels', 'Position', [470, 20, 80, 80]);
    seg5Axes = axes('Parent', f, 'Units', 'pixels', 'Position', [560, 20, 80, 80]);
    seg6Axes = axes('Parent', f, 'Units', 'pixels', 'Position', [650, 20, 80, 80]);
    seg7Axes = axes('Parent', f, 'Units', 'pixels', 'Position', [740, 20, 80, 80]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '字符分割结果:', 'Position', [200, 100, 100, 20]);

    % 全局变量
    originalImage = [];
    Plate = [];
    segmentedPlateImage = cell(1, 7);
%   char_recognition_model = load('char_recognition_model.mat');
    labelAll =[];
    function openImage(hObject, eventdata)
        [filename, pathname] = uigetfile({'*.bmp;*.jpg;*.png', 'Image files (*.bmp, *.jpg, *.png)'}, '选择图片文件');
        if isequal(filename, 0) || isequal(pathname, 0)
            return;
        end
        originalImage = imread(fullfile(pathname, filename));
        axes(originalAxes);
        imshow(originalImage);
    end

    function findCarPlate(hObject, eventdata)
        [Plate, ~, Loc] = Pre_Process(originalImage, [], 0); % 定位车牌
        axes(PlateAxes);
        imshow(Plate);
    end

    function segCarPlate(hObject, eventdata)       
        %% 分割字符
        fgray=rgb2gray(Plate);
        level2=graythresh(fgray);
        bw3=im2bw(fgray,level2);
        % figure;imshow(bw3);title('定位剪切后的二值图像');
        se2=strel('line',2,90);
        se3=strel('cube',4);
        se4=strel('disk',1);
        bw3o=bwareaopen(bw3,30);
        % figure;imshow(bw3o);title('删除小于20面积后的图像');
        bw3oe=imerode(bw3o,se4);
        % figure;imshow(bw3oe);title('二值图像腐蚀后')
        bw3oc =imclose(bw3oe,se2);
        % figure;imshow(bw3oc);title('二值图像闭运算后');
        bw4=imclearborder(bw3oc);
%         figure;imshow(bw4);
        bw4d=imdilate(bw4,se3);
        bw4d=imdilate(bw4d,se3);
        % figure;imshow(bw4d);title('膨胀后的图像');
        bw5=bwareaopen(bw4d,400);
        % figure;imshow(bw5);title('删除小于400后的图像');  
        s2=regionprops(bw5,'BoundingBox','Centroid');
        
        for i=1:length(s2)
            xy=s2(i).BoundingBox;
            bw6=Plate(floor(xy(2)):floor(xy(2)+xy(4)),floor(xy(1)):floor(xy(1)+xy(3)),:);
            
            segmentedPlateImage{i} = imresize(bw6,[32 32]);
        end
        axes(seg1Axes);
        imshow(segmentedPlateImage{1})
        axes(seg2Axes);
        imshow(segmentedPlateImage{2})
        axes(seg3Axes);
        imshow(segmentedPlateImage{3})
        axes(seg4Axes);
        imshow(segmentedPlateImage{4})
        axes(seg5Axes);
        imshow(segmentedPlateImage{5})
        axes(seg6Axes);
        imshow(segmentedPlateImage{6})
        axes(seg7Axes);
        imshow(segmentedPlateImage{7})
        
    end

    function recognizeCarPlate(hObject, eventdata)
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
        str = '车牌的识别结果是：';
        % 开始训练模型
        char_recognition_model = trainNetwork(trainImages,layers,options);
        for i = 1:7
           label = classify(char_recognition_model,segmentedPlateImage{i}); 
           string(label)
           str = strcat(str,string(label));
        end
        set(ResultText, 'String', sprintf(str));
    end
end