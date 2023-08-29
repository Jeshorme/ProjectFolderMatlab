function myGUI
    % 创建一个figure窗口
    f = figure('Name', '基于PCA的掌纹预处理系统','Position', [200, 200, 1000, 600]);

    % 创建文本框
    ResultText = uicontrol('Style', 'text', 'String', '掌纹识别结果：', 'Position', [0, 260, 200, 20]);

    % 创建按钮
    uicontrol('Style', 'pushbutton', 'String', '打开待识别图片', 'Position', [150, 210, 150, 30], 'Callback', @openImage);
    uicontrol('Style', 'pushbutton', 'String', '图像增强', 'Position', [150, 170, 150, 30], 'Callback', @enhance_image);
    uicontrol('Style', 'pushbutton', 'String', '图像分割', 'Position', [150, 130, 150, 30], 'Callback', @segment_image);
    uicontrol('Style', 'pushbutton', 'String', '二值化', 'Position', [150, 90, 150, 30], 'Callback', @towvalueIm);
    uicontrol('Style', 'pushbutton', 'String', '膨胀和腐蚀', 'Position', [150, 50, 150, 30], 'Callback', @morphological_operations);
    uicontrol('Style', 'pushbutton', 'String', 'PCA', 'Position', [150, 10, 150, 30], 'Callback', @PCA);
    uicontrol('Style', 'pushbutton', 'String', '退出界面', 'Position', [20, 10, 100, 30], 'Callback', @CLOSE);
    
    uicontrol('Style', 'pushbutton', 'String', '判断掌纹', 'Position', [20, 50, 100, 190], 'Callback', @judge);

    % 创建图形显示区域
    originalAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [50, 320, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '原图:', 'Position', [120, 550, 100, 20]);
    
    enhanceAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [370, 320, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '图像增强结果:', 'Position', [440, 550, 100, 20]);
    
    segAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [690, 320, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '图像分割结果:', 'Position', [770, 550, 100, 20]);
    
    towvalueAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [370, 50, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '二值化结果:', 'Position', [440, 280, 100, 20]);
    
    erodeAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [690, 50, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '膨胀和腐蚀结果:', 'Position', [770, 280, 100, 20]);
    
    % 全局变量
    originalImage = [];
    enhanced_img = [];
    edge_img = [];
    binarizeImage = [];
    morphologicalImage= [];
    palmprint_recognitionModel=load('palmprint_recognitionModel.mat');
    
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

    function enhance_image(hObject, eventdata)
        % ENHANCE_IMAGE: 使用CLAHE算法对图像进行增强
        % 输入参数:
        % input_img: 待增强图像
        % 输出参数:
        % enhanced_img: 增强后的图像
        input_img=originalImage;
        % 定义CLAHE算法的参数
        clip_limit = 0.01; % 对比度限制
        tile_size = [6, 6]; % 划分块的大小

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

    function segment_image(hObject, eventdata)
        % SEGMENT_IMAGE: 使用Canny算法对图像进行分割
        % 输入参数:
        % input_img: 待分割图像
        % 输出参数:
        % edge_img: 分割后的边缘图像
        input_img=enhanced_img;
        % 转换图像为灰度图像
        if size(input_img,3)==3
            gray_img = rgb2gray(input_img);
        else
            gray_img=input_img;
        end
        % 使用Canny算法进行边缘检测
        sigma = 0.9; % 高斯滤波的标准差
        threshold = [0.05, 0.2]; % 阈值参数
        edge_img = edge(gray_img, 'canny', threshold, sigma);

        % 转换图像类型
        edge_img = im2uint8(edge_img);
        axes(segAxes);
        imshow(edge_img)
    end
    
    
    function towvalueIm(hObject, eventdata)
        %二值化
        binarizeImage = imbinarize(enhanced_img)
        axes(towvalueAxes);
        imshow(binarizeImage);
    end
    
    global eroded_img
    function morphological_operations(hObject, eventdata)
        % MORPHOLOGICAL_OPERATIONS: 对二值图像进行膨胀和腐蚀处理
        % 输入参数:
        % input_img: 待处理的二值图像
        % 输出参数:
        % processed_img: 处理后的二值图像

        % 定义膨胀和腐蚀的结构元素
        se = strel('disk', 1); % 定义一个半径为3的圆形结构元素
        % 对二值图像进行腐蚀操作
        eroded_img = imerode(binarizeImage, se);
        % 转换图像类型
        eroded_img = im2uint8(eroded_img);
        axes(erodeAxes);
        imshow(eroded_img);
        
    
    end
    function PCA(hObject, eventdata)
        
        
        %进行PCA分解
        eroded_img = double(eroded_img);
        d_mean = mean(eroded_img);
        d_mean(length(eroded_img(:,1)),length(d_mean)) = 0;
        for j = 1:length(d_mean)
            d_mean(:,j) = d_mean(1,j);  
        end
        data_mean = eroded_img-d_mean;
        temp = cov(data_mean);
        [V,D] = eig(temp);
        [S,D_index] = sort(diag(sqrt(D)),'descend');
        S = diag(S);
        V=V(:, D_index);


        cul = 0;
        S_sum = sum(sum(S));
        V = V(:,1:50);
        %展示结果
        finData =data_mean * V;
        %生成新的数据
        majorData = finData*V'+ d_mean;
        figure('Name','PCA处理结果');
        imshow(majorData)
    end
  

    function judge(hObject, eventdata)
        
        image = imresize(originalImage,[128,128]);
        label = classify(palmprint_recognitionModel.palmprint_recognitionModel,image); 
        str = '当前手掌的识别结果为：       '
        str = strcat(str,string(label));
        set(ResultText, 'String', str);
    end

    function CLOSE(hObject, eventdata)
        
        close all;
    end
end