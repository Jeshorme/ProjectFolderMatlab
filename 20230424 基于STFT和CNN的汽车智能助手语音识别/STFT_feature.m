% 设置原始文件夹和目标文件夹的路径
sourceFolder = 'Soundfiles';
targetFolder = 'STFT_feature';

% 获取原始文件夹中的子文件夹列表
subFolders = dir(sourceFolder);
subFolders = subFolders([subFolders.isdir]);  % 仅保留文件夹项
subFolders = subFolders(~ismember({subFolders.name}, {'.', '..'}));  % 去除 '.' 和 '..'

% 遍历每个子文件夹
for i = 1:length(subFolders)
    currentFolder = fullfile(sourceFolder, subFolders(i).name);
    
    % 获取当前子文件夹中的所有音频文件
    audioFiles = dir(fullfile(currentFolder, '*.wav'));  % 假设音频文件扩展名为.wav
    
    % 创建子文件夹的目标路径
    targetSubFolder = fullfile(targetFolder, subFolders(i).name);
    if ~isfolder(targetSubFolder)
        mkdir(targetSubFolder);
    end
    
    % 遍历当前子文件夹中的音频文件
    for j = 1:length(audioFiles)
        currentFile = fullfile(currentFolder, audioFiles(j).name);
        
        % 读取音频文件
        [audioData, sampleRate] = audioread(currentFile);
        SampFreq = 8000;
        audioData = resample(audioData,SampFreq, sampleRate);
        sampleRate = 8000;
        
        % 将音频信号转换为STFT图像  
        
        winLength = round(0.025*sampleRate); % 窗口长度（帧长）
        overlap = round(0.01*sampleRate); % 帧重叠长度
        nfft = 2^nextpow2(winLength); % FFT长度
        window = hamming(winLength, 'periodic'); % 窗口函数
        noverlap = winLength - overlap; % 不重叠窗口长度
        [S, F, T] = spectrogram(audioData, window, noverlap, nfft, sampleRate, 'yaxis');
        stft=20*log10(abs(S));
        
        % 将STFT图像保存为图像文件
        [~, fileName, ~] = fileparts(audioFiles(j).name);
        targetFile = fullfile(targetSubFolder, [fileName '.png']);
        imagesc(stft);  % 显示STFT图像
        n = jet;
        n(1,:) = [ 1 1 1 ];
        colormap(n);
        set(gca,'xtick',[],'ytick',[]);
        set(gca,'Position',[0 0 1 1]);
%         colormap jet;  % 颜色映射
        saveas(gcf, targetFile);  % 保存图像
        close gcf;  % 关闭图像窗口
    end
end

disp('提取和保存STFT图像完成。');
