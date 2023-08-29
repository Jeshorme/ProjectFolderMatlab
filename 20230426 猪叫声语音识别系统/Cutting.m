% 源文件夹路径
sourceFolderPath = 'C:\Users\64148\Desktop\兼职工作文件夹\20230426(500soundR)\猪声音';

% 目标文件夹路径
targetFolderPath = 'C:\Users\64148\Desktop\兼职工作文件夹\20230426(500soundR)\猪声音\猪咳嗽';

% 获取源文件夹内所有.mp3文件
mp3Files = dir(fullfile(sourceFolderPath, '*.mp3'));

% 遍历每个.mp3文件
for i = 1:length(mp3Files)
    % 构建源文件路径
    sourceFilePath = fullfile(mp3Files(i).folder, mp3Files(i).name);
    
    % 读取音频文件
    [audio, fs] = audioread(sourceFilePath);
    
    % 截取前3秒音频
    audio = audio(1:min(fs*3, length(audio)), :);
    
    % 构建目标文件路径
    [~, filename, ~] = fileparts(mp3Files(i).name);
    targetFilePath = fullfile(targetFolderPath, [filename '_trimmed.wav']); % 将文件扩展名修改为.wav
    
    % 保存截取后的音频文件
    audiowrite(targetFilePath, audio, fs);
    
    disp(['已保存文件: ' targetFilePath]);
end

disp('音频截取并保存完成。');