% 加载行人检测器
detector = vision.PeopleDetector('ClassificationModel', 'UprightPeople_96x48');
% 配置行人检测的其他参数（可选）
detector.MinSize = [100 150]; % 最小行人边界框尺寸
detector.MaxSize = [400 400]; % 最大行人边界框尺寸
detector.ScaleFactor = 1.09; % 检测器缩放因子
detector.MergeDetections = true; % 是否合并相邻的重叠检测框

% 加载视频
videoFile = '行人检测.mp4';
videoReader = vision.VideoFileReader(videoFile);

% 初始化视频播放器
videoPlayer = vision.VideoPlayer('Name', 'Pedestrian Detection');

% 循环处理每一帧视频
while ~isDone(videoReader)
    % 读取当前帧
    frame = step(videoReader);
    
    % 图像灰度化
    grayFrame = rgb2gray(frame);
    
    
    
    % ============================================行人检测===========================
    % 使用行人检测器检测行人
    [bboxes, scores] = step(detector, grayFrame);   
    % ===================================轨道检测====================================
    % Gaussian滤波法进行图像去噪
    filteredFrame = imgaussfilt(grayFrame, 0.0001);

    % 二值化
    threshold = graythresh(filteredFrame);
    binaryFrame = imbinarize(filteredFrame, threshold);
%     % 颜色过滤
%     % 提取公路区域的颜色范围
%     lowerColor = 0.2;  % 公路区域的颜色下界
%     upperColor = 0.3;  % 公路区域的颜色上界
%     binaryImage = (binaryFrame(:,:,1) >= lowerColor(1) & binaryFrame(:,:,1) <= upperColor(1));


    % prewitt边缘检测算子进行边缘检测
    edgeFrame = edge(binaryFrame, 'prewitt');
    % 形态学膨胀操作
    se = strel('line', 10, 2);
    edgeFrame = imdilate(edgeFrame, se);
    
%     figure(1)
%     imshow(edgeFrame)
    % 轨道检测
    % 使用Hough变换检测直线
    [H,theta,rho] = hough(edgeFrame);
    P = houghpeaks(H,10,'threshold',ceil(0.3*max(H(:))));
    lines = houghlines(edgeFrame,theta,rho,P,'FillGap',7,'MinLength',600);

    % 在原图上标注轨道线
    laneLines = zeros(size(edgeFrame));
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        laneLines = insertShape(laneLines, 'Line', xy, 'LineWidth', 10, 'Color', 'blue');
    end
    
    
    绘制检测框
    zero = [0 0 0 0];
    for i = 1:size(bboxes,1)
        if bboxes(i,1)<600
            bboxes(i,:)=zero;
        end
    end
    str = 'Warning';
    detectedFrame = insertObjectAnnotation(frame, 'rectangle', bboxes, str);
    
    %
    laneLines = double(laneLines);
    detectedFrame = double(detectedFrame);
    if isequal(size(laneLines), size(detectedFrame))
        laneMarkedFrame = imadd(detectedFrame, laneLines);
        figure(2)
        imshow(laneMarkedFrame)
    else
        figure(2)
        imshow(detectedFrame)
    end
    
%     %显示检测结果
%     step(videoPlayer, laneMarkedFrame);

end

% 释放资源
release(videoReader);
release(videoPlayer);
