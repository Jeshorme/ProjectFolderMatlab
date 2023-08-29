% 加载行人检测器
detector = vision.PeopleDetector('ClassificationModel', 'UprightPeople_96x48');
% 配置行人检测的其他参数
detector.MinSize = [100 150]; % 最小行人边界框尺寸
detector.MaxSize = [200 200]; % 最大行人边界框尺寸
detector.ScaleFactor = 1.09; % 检测器缩放因子
detector.MergeDetections = true; % 是否合并相邻的重叠检测框

% % 加载视频(轨道提取图例）
% videoFile = 'D:\毕设\行人检测.mp4';
% videoReader = vision.VideoFileReader(videoFile);

[filename1, pathname1]  =  uigetfile({'*.mp4';'*.avi';'*.*'}...
    ,'File Selector');
V = VideoReader([pathname1,filename1]);
Framerate = V.FrameRate;
frame  =  read(V,415);
imshow(frame);

    % 图像灰度化
    grayFrame = rgb2gray(frame);


    % % 使用行人检测器检测行人
    % [bboxes, scores] = step(detector, grayFrame);
    % str = 'Warning';
    % % 绘制检测框
    % detectedFrame = insertObjectAnnotation(frame, 'rectangle', bboxes, str);
    % 


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




    % Roberts边缘检测算子进行边缘检测
    edgeFrame = edge(binaryFrame, 'prewitt');
    % 形态学膨胀操作
    se = strel('line', 10, 2);
    edgeFrame = imdilate(edgeFrame, se);

    figure(1)
    imshow(edgeFrame)
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
      laneLines = double(laneLines);
      imshow(laneLines)



  %加入检测图片
  img = imread('D:\毕设\Moment01201.jpg');
  img1=im2double(img);
  laneLines=imadd(img1,laneLines);
  imshow(laneLines);

  grayimg = rgb2gray(img);
 

    % 使用行人检测器检测行人
    [bboxes, scores] = step(detector, grayimg);
    str = 'Warning';
    % 绘制检测框
    detectedFrame = insertObjectAnnotation(img, 'rectangle', bboxes, str);


   
     detectedFrame1=im2double(detectedFrame);
      imshow(detectedFrame1);

if   isequal(size(laneLines), size(detectedFrame1))
        laneMarkedFrame = imadd(laneLines,detectedFrame1);
        laneMarkedFrame1=imsubtract(laneMarkedFrame,img1);
        figure(2)
        imshow(laneMarkedFrame1);
    else
        figure(2)
        imshow(detectedFrame1);  
    end

   %  %显示检测结果
   % imshow(laneMarkedFrame);



% 释放资源
% release(videoReader);
% release(videoPlayer);
