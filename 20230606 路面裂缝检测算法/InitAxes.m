function InitAxes(handles)
% 清除命令行窗口的内容
clc;

% 初始化图像显示的四个坐标轴
% 创建axes1
axes(handles.axes1); cla reset;
set(handles.axes1, 'XTick', [], 'YTick', [], ...
    'XTickLabel', '', 'YTickLabel', '', ...
    'Color', [0.7020 0.7804 1.0000], 'Box', 'On');

% 创建axes2
axes(handles.axes2); cla reset;
set(handles.axes2, 'XTick', [], 'YTick', [], ...
    'XTickLabel', '', 'YTickLabel', '', ...
    'Color', [0.7020 0.7804 1.0000], 'Box', 'On');

% 创建axes3
axes(handles.axes3); cla reset;
set(handles.axes3, 'XTick', [], 'YTick', [], ...
    'XTickLabel', '', 'YTickLabel', '', ...
    'Color', [0.7020 0.7804 1.0000], 'Box', 'On');

% 创建axes4
axes(handles.axes4); cla reset;
set(handles.axes4, 'XTick', [], 'YTick', [], ...
    'XTickLabel', '', 'YTickLabel', '', ...
    'Color', [0.7020 0.7804 1.0000], 'Box', 'On');
