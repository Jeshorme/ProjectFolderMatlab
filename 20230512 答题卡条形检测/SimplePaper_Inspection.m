function [pass,sum_scores,I4,tips] = SimplePaper_Inspection( filename)
%输入参数：
%filenames——包含需要判定的答题卡文件名
%Custom_pass_scores——用户指定的分数线
Custom_pass_scores = 60; 
if isempty(filename)
    msgbox('请选择合法的答题卡图像！');
end
%读取图像
I = imread(filename);
%预处理
I1 = Image_Normalize(I, 0);
%平滑处理，模板尺寸[3 3]，sigma角0.5，平滑方式：高斯滤波
hsize = [3 3];
sigma = 0.5;
I2 = Image_Smooth(I1, hsize, sigma, 0);
%灰度化
I3 = Gray_Convert(I2, 0);
%二值化
bw2 = Image_Binary(I3, 0);
%hough变换
[~, ~, xy_long] = Hough_Process(bw2, I1, 0);
%变换斜率
angle = Compute_Angle(xy_long);
%图像旋转
[I4, bw3] = Image_Rotate(I1, bw2, angle*1.8, 0);
%形态学滤波
[bw4, Loc1] = Morph_Process(bw3, 0);
%hough检测区域分界线
[Len, XYn, xy_long] = Hough_Process(bw4, I4, 0);
%区域分割
[bw5, bw6] = Region_Segmation(XYn, bw4, I4, 0);
%区域标记
[stats1, stats2, Line] = Location_Label(bw5, bw6, I4, XYn, Loc1, 0);
%区域分析
[Dom, Aom, Answer, Bn] = Analysis(stats1, stats2, Line, I4);
%成绩判定
[pass,sum_scores,tips] = contrastAnswers( Bn,Answer ,Custom_pass_scores);

end