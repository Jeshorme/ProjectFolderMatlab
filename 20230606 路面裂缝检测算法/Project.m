function [projectr, projectc] = Project(bw)
% 投影函数，计算二值图像的行投影和列投影

% 计算行投影
projectr = sum(bw, 2);

% 计算列投影
projectc = sum(bw, 1);
