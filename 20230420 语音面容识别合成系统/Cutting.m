% 设置输入文件夹和输出文件夹的路径
clc;
clear all;
inputFolder = 'C:\Users\64148\Desktop\兼职工作文件夹\20230420（700）\自组10个人语音包作为数据集'; % 替换为实际的输入文件夹路径
outputFolder = 'C:\Users\64148\Desktop\兼职工作文件夹\20230420（700）\自组10个人语音包作为数据集（cutting）'; % 替换为实际的输出文件夹路径

% 获取输入文件夹下的所有子文件夹
subFolders = dir(inputFolder);
subFolders = subFolders(3:end); % 去除'.'和'..'这两个特殊文件夹

% 遍历每个子文件夹
for i = 1:numel(subFolders)
    subFolderPath = fullfile(inputFolder, subFolders(i).name); % 子文件夹的完整路径

    % 获取子文件夹下的所有.mp3文件
    mp3Files = dir(fullfile(subFolderPath, '*.wav'));

    % 遍历每个.mp3文件
    for j = 1:numel(mp3Files)
        mp3FilePath = fullfile(subFolderPath, mp3Files(j).name); % .mp3文件的完整路径

        % 读取.mp3文件中的语音数据和采样率
        [audioData, sampleRate] = audioread(mp3FilePath);
        SampFreq = 8000;
        audio = resample(audioData,SampFreq, sampleRate);
        sampleRate = 8000;
        % 裁剪语音数据至3秒
        duration = 3; % 要裁剪的时长，单位为秒
        numSamples = round(duration * sampleRate); % 要裁剪的采样点数
        audioData = audioData(1:numSamples, :); % 裁剪语音数据

        % 生成新的文件名
        newFileName = [mp3Files(j).name(1:end-4), '_cropped.wav']; % 在原文件名后加上'_cropped'作为新的文件名

        % 构建新文件的保存路径
        outputSubFolderPath = fullfile(outputFolder, subFolders(i).name); % 新文件夹的完整路径
        if ~exist(outputSubFolderPath, 'dir')
            mkdir(outputSubFolderPath); % 若输出文件夹不存在，则创建之
        end
        newFilePath = fullfile(outputSubFolderPath, newFileName); % 新文件的完整保存路径

        % 将裁剪后的语音数据保存为新的.mp3文件
        audiowrite(newFilePath, audioData, sampleRate);
    end
end

disp('语音裁剪完成。');
