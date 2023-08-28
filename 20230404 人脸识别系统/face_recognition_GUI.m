function face_recognition_GUI
% 创建主界面窗口
hFig = figure('Name','人脸识别系统','Units','pixels','Position',[300 300 600 500],'MenuBar','none','ToolBar','none','NumberTitle','off','Resize','off');
% 添加图像显示区域
hAxes = axes('Parent',hFig,'Units','pixels','Position',[50 100 300 300]);
% 添加实时摄像头图像显示区域
hCameraAxes = axes('Parent',hFig,'Units','pixels','Position',[400 100 150 150]);
% 添加捕获图像按钮
uicontrol(hFig,'Style','pushbutton','String','捕获图像','Units','pixels','Position',[400 50 100 30],'Callback',@captureImage);
% 添加开始识别按钮
uicontrol(hFig,'Style','pushbutton','String','开始识别','Units','pixels','Position',[500 50 100 30],'Callback',@startRecognition);
% 初始化全局变量
global net;
global faceDetector;
global camera;

% 导入已经训练好的卷积神经网络模型
net = load('model.mat');

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
    function startRecognition(~,~)
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
            label = classify(net.net,face);
            % 在图像中显示人脸边界框和预测结果
            img = insertObjectAnnotation(img,'rectangle',bbox,label,'FontSize',50,'TextColor','red');
            % 显示结果图像
            imshow(img,'Parent',hAxes);
        else
            % 如果未检测到人脸，则显示提示信息
            msgbox('未检测到人脸，请重新捕获图像','提示','modal');
        end
    end
end
