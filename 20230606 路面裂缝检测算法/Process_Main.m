function Result = Process_Main(I)
% 主处理函数，对输入图像进行一系列处理，并返回结果

% 判断输入图像的维度，若为彩色图像则转换为灰度图像
if ndims(I) == 3
    I1 = rgb2gray(I);
else
    I1 = I;
end

% 直方图均衡化
I2 = hist_con(I1);

% 中值滤波
I3 = med_process(I2);

% 对比度增强
I4 = adjgamma(I3, 2);

% 迭代阈值处理
[bw, th] = IterProcess(I4);

% 取反，得到裂缝图像
bw = ~bw;

% 使用尺寸滤波器对裂缝图像进行处理
bwn1 = bw_filter(bw, 15);

% 对处理后的裂缝图像进行标记和筛选
bwn2 = Identify_Object(bwn1);

% 计算裂缝图像的行投影和列投影
[projectr, projectc] = Project(bwn2);

% 获取裂缝图像的尺寸
[r, c] = size(bwn2);

% 对裂缝图像进行裂缝判定处理
bwn3 = Judge_Crack(bwn2, I4);

% 对裂缝图像进行裂缝连接处理
bwn4 = Bridge_Crack(bwn3);

% 判断裂缝的方向
[flag, rect] = Judge_Direction(bwn4);

% 根据裂缝方向确定结果字符串和裂缝宽度的最大和最小值
if flag == 1
    str = '横向裂缝';
    wdmax = max(projectc);
    wdmin = min(projectc);
else
    str = '纵向裂缝';
    wdmax = max(projectr);
    wdmin = min(projectr);
end

% 构建结果结构体
Result.Image = I1;
Result.hist = I2;
Result.Medfilt = I3;
Result.Enance = I4;
Result.Bw = bw;
Result.BwFilter = bwn1;
Result.CrackRec = bwn2;
Result.Projectr = projectr;
Result.Projectc = projectc;
Result.CrackJudge = bwn3;
Result.CrackBridge = bwn4;
Result.str = str;
Result.rect = rect;
Result.BwEnd = bwn4;
Result.BwArea = bwarea(bwn4);%计算裂缝面积
Result.BwLength = max(rect(3:4));
Result.BwWidthMax = wdmax;
Result.BwWidthMin = wdmin;
Result.BwTh = th;
