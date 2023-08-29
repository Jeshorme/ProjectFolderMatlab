function myGUI
    % 创建一个figure窗口
    f = figure('Name', '基于ANN的车牌号码识别系统','Position', [200, 200, 1000, 600]);

    % 创建文本框
    ResultText = uicontrol('Style', 'text', 'String', '火灾判断结果：', 'Position', [0, 260, 200, 20]);

    % 创建按钮
    uicontrol('Style', 'pushbutton', 'String', '打开待识别图片', 'Position', [150, 210, 150, 30], 'Callback', @openImage);
    uicontrol('Style', 'pushbutton', 'String', '灰度变换', 'Position', [150, 170, 150, 30], 'Callback', @grayIm);
    uicontrol('Style', 'pushbutton', 'String', '滤波结果', 'Position', [150, 130, 150, 30], 'Callback', @filterIm);
    uicontrol('Style', 'pushbutton', 'String', '二值化', 'Position', [150, 90, 150, 30], 'Callback', @towvalueIm);
    uicontrol('Style', 'pushbutton', 'String', '边缘检测结果', 'Position', [150, 50, 150, 30], 'Callback', @edgeIm);
    uicontrol('Style', 'pushbutton', 'String', '判断火灾', 'Position', [20, 50, 100, 190], 'Callback', @judgeFire);

    % 创建图形显示区域
    originalAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [50, 320, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '原图:', 'Position', [120, 550, 100, 20]);
    
    grayAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [370, 320, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '灰度变换结果:', 'Position', [440, 550, 100, 20]);
    
    filterAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [690, 320, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '滤波结果:', 'Position', [770, 550, 100, 20]);
    
    towvalueAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [370, 50, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '二值化结果:', 'Position', [440, 280, 100, 20]);
    
    edgeAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [690, 50, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '边缘检测结果:', 'Position', [770, 280, 100, 20]);
    
    % 全局变量
    originalImage = [];
    grayImage = [];
    filterImage = [];
    towvalueImage = [];
    edgeImage= [];
    fire_recognition_model=load('fire_recognition_model.mat');
    
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

    function grayIm(hObject, eventdata)
        %图像灰化
        grayImage = im2gray(originalImage);
        axes(grayAxes);
        imshow(grayImage);
    end

    function filterIm(hObject, eventdata)
        %图像高斯滤波
        filterImage = imgaussfilt(grayImage, 0.001);
        axes(filterAxes);
        imshow(filterImage);
    end

    function towvalueIm(hObject, eventdata)
        %图像滤波
        towvalueImage = imbinarize(filterImage);
        axes(towvalueAxes);
        imshow(towvalueImage);
    end

    function edgeIm(hObject, eventdata)
        %图像滤波
        edgeImage = edge(filterImage,'canny');
        axes(edgeAxes);
        imshow(edgeImage);
    end


    function judgeFire(hObject, eventdata)
        
        image = imresize(originalImage,[128,128]);
        label = classify(fire_recognition_model.fire_recognition_model,image); 
        str = '当前场景的情况为：       '
        str = strcat(str,string(label));
        set(ResultText, 'String', str);
    end
end