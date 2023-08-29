function myGUI

    % 创建一个figure窗口
    f = figure('Name', '交通标志识别代码系统','Position', [200, 200, 1300, 600]);

    % 创建文本框
    ResultText = uicontrol('Style', 'text', 'String', '识别结果', 'Position', [0, 260, 300, 40],'fontsize',10);

    % 创建按钮
    uicontrol('Style', 'pushbutton', 'String', '打开待识别图片', 'Position', [150, 210, 150, 30], 'Callback', @openImage);
    uicontrol('Style', 'pushbutton', 'String', '定位标志', 'Position', [150, 170, 150, 30], 'Callback', @segIm);
    uicontrol('Style', 'pushbutton', 'String', '滤波结果', 'Position', [150, 130, 150, 30], 'Callback', @filterIm);
    uicontrol('Style', 'pushbutton', 'String', '二值化', 'Position', [150, 90, 150, 30], 'Callback', @towvalueIm);
    uicontrol('Style', 'pushbutton', 'String', '边缘检测结果', 'Position', [150, 50, 150, 30], 'Callback', @edgeIm);
    uicontrol('Style', 'pushbutton', 'String', '图像增强', 'Position', [20, 10, 100, 30], 'Callback', @enhance_image);
    uicontrol('Style', 'pushbutton', 'String', '膨胀和腐蚀', 'Position', [150, 10, 150, 30], 'Callback', @morphological_operations);
    uicontrol('Style', 'pushbutton', 'String', '识别标志', 'Position', [20, 130, 100, 110], 'Callback', @judgeFire);
    uicontrol('Style', 'pushbutton', 'String', '进行播报', 'Position', [20, 50, 100, 70], 'Callback', @sounding);
    
    % 创建图形显示区域
    originalAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [50, 320, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '原图:', 'Position', [120, 550, 100, 20]);
    
    segAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [370, 320, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '定位结果:', 'Position', [440, 550, 100, 20]);
    
    filterAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [690, 320, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '滤波结果:', 'Position', [770, 550, 100, 20]);
    
    towvalueAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [370, 50, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '二值化结果:', 'Position', [440, 280, 100, 20]);
    
    edgeAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [690, 50, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '边缘检测结果:', 'Position', [770, 280, 100, 20]);
    
    erodeAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [1010, 50, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '膨胀和腐蚀结果:', 'Position', [1100, 280, 100, 20]);
    
    enhanceAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [1010, 320, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '图像增强结果:', 'Position', [1100, 550, 100, 20]);
    
    % 全局变量
    originalImage = [];
    grayImage = [];
    filterImage = [];
    towvalueImage = [];
    edgeImage= [];
    imSeg = [];
    model=load('model.mat');
    detector=load('trafficsigndetector.mat');
    

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
    
   function enhance_image(hObject, eventdata)
        % ENHANCE_IMAGE: 使用CLAHE算法对图像进行增强
        % 输入参数:
        % input_img: 待增强图像
        % 输出参数:
        % enhanced_img: 增强后的图像
        input_img=imSeg;
        % 定义CLAHE算法的参数
        clip_limit = 0.01; % 对比度限制
        tile_size = [15, 15]; % 划分块的大小

        % 转换图像为灰度图像
        if size(input_img,3)==3
            gray_img = rgb2gray(input_img);
        else
            gray_img=input_img;
        end
        % 应用CLAHE算法进行增强
        enhanced_img = adapthisteq(gray_img, 'ClipLimit', clip_limit, 'NumTiles', tile_size);

        % 转换图像类型
        enhanced_img = im2uint8(enhanced_img);
        axes(enhanceAxes);
        imshow(enhanced_img)
    end
    
    function segIm(hObject, eventdata)
        image = imresize(originalImage,[224,224]);
        [bboxes, scores] = detect(detector.detector, image);
        I = insertObjectAnnotation(image, 'rectangle', bboxes, scores);
        axes(originalAxes);
        imshow(I);
        imSeg = imcrop(image,bboxes(1,:));
        
        axes(segAxes);
        imshow(imSeg);
    end
    
    function morphological_operations(hObject, eventdata)
        % MORPHOLOGICAL_OPERATIONS: 对二值图像进行膨胀和腐蚀处理
        % 输入参数:
        % input_img: 待处理的二值图像
        % 输出参数:
        % processed_img: 处理后的二值图像

        % 定义膨胀和腐蚀的结构元素
        se = strel('disk', 1); % 定义一个半径为3的圆形结构元素

        % 对二值图像进行腐蚀操作
        eroded_img = imerode(towvalueImage, se);
        % 转换图像类型
        eroded_img = im2uint8(eroded_img);
        axes(erodeAxes);
        imshow(eroded_img);
    
    end

    function filterIm(hObject, eventdata)
        %图像高斯滤波
        grayImage = im2gray(imSeg);
        filterImage = imgaussfilt(grayImage, 0.001);
        axes(filterAxes);
        imshow(filterImage);
    end

    function towvalueIm(hObject, eventdata)
        %图像二值化
        towvalueImage = imbinarize(filterImage);
        axes(towvalueAxes);
        imshow(towvalueImage);
    end

    function edgeIm(hObject, eventdata)
        %边缘检测
        edgeImage = edge(filterImage,'canny');
        axes(edgeAxes);
        imshow(edgeImage);
    end

    global label
    function judgeFire(hObject, eventdata)
        
        image = imresize(originalImage,[128,128]);
        label = classify(model.model,image); 
        set(ResultText, 'String', string(label));       
    end

    global label
    function sounding(hObject, eventdata)
        label_audio = strcat(string(label),'.wav');
        audioPath = fullfile('Soundfiles',label_audio)
        [audio_data, fs] = audioread(audioPath);
        soundsc(audio_data, fs);
        str = strcat('前方出现标志为',string(label),'，播报中……')
        set(ResultText,'String',str);
    end
end