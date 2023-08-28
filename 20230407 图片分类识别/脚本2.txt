function resnet_gui()

% 创建主界面
fig = uifigure('Name','图片分类器','Position',[100 100 800 600]);

% 创建显示图片的Axes
hAxes = axes('Parent',fig,'Units','pixels','Position',[100 100 600 600]);

% 创建选择文件的按钮
file_button = uibutton(fig, 'push', 'Text', '选择文件', 'Position', [100 50 100 30], 'ButtonPushedFcn', @(btn,event) select_image());

% 创建识别按钮
recognize_button = uibutton(fig, 'push', 'Text', '识别', 'Position', [600 50 100 30], 'ButtonPushedFcn', @(btn,event) recognize_image());

% 定义全局变量
global im;
global net;
load('model.mat','trainedNet');
net=trainedNet;

% 选择图片函数
function select_image()
    % 清空前一次显示的图片
    cla(hAxes);
    % 打开文件选择对话框
    [filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png','图片文件 (*.jpg,*.jpeg,*.png)'},'选择一张图片');
    if isequal(filename,0)
        disp('未选择任何文件');
    else
        % 读取并显示图片
        im = imread(fullfile(pathname, filename));
        im = imresize(im, [224 224]); % 调整图片大小
        imshow(im,'Parent',hAxes); % 显示图片
    end
end

% 图片识别函数
function recognize_image()
    % 如果没有选择图片，则提示用户选择图片
    if ~exist('im', 'var')
        uialert(fig,'请先选择一张图片！','提示');
        return;
    end
    % 清空前一次识别结果
    delete(findall(fig,'Type','UILabel'));
    % 对图片进行预处理
    im = imresize(im, [224 224]);
%     imshow(im)
%     im = im2single(im);
    % 对图片进行分类
    label = classify(net,im);
    % 显示分类结果
    result = sprintf('识别结果：%s', char(label));
    uilabel(fig, 'Text', result, 'Position', [320 40 200 30],'FontSize', 20);
end
end
