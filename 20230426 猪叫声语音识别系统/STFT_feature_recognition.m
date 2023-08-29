% 这里是STFT

labelCell = cell(1,3);
labelCell{1} = '猪叫声';
labelCell{2} = '猪咳嗽';
labelCell{3} = '猪打呼';
% ====================================训练过程：即求取均值模板==========================================
folderPath = '猪叫声裁剪后\猪叫声';
audioFiles = {};
% 获取文件夹下的所有文件
files = dir(fullfile(folderPath, '*.wav'));
% 遍历文件列表
for i = 1:length(files)
    audioFiles{end+1} = fullfile(folderPath, files(i).name);
end
% 读取音频文件
pigJ = zeros(129,48,length(audioFiles)); % 最终求解得到的STFT矩阵的大小
for i = 1:length(audioFiles)
    % 读取音频文件
    [y, Fs] = audioread(audioFiles{i});
    y = double(y);
    y = y(Fs:length(y));
    SampFreq = 8000;
    y = resample(y,SampFreq, Fs);
    Fs = 8000;
    
    % STFT======================从这里看出来；程序很简答，这个你自己能看懂=====
    winLength = round(0.025*Fs); % 窗口长度（帧长）
    overlap = round(0.01*Fs); % 帧重叠长度
    nfft = 2^nextpow2(winLength); % FFT长度
    window = hamming(winLength, 'periodic'); % 窗口函数
    noverlap = winLength - overlap; % 不重叠窗口长度
    [S, F, T] = spectrogram(y, window, noverlap, nfft, Fs, 'yaxis');
    stft=20*log10(abs(S));
    figure;
    imagesc(T, F, stft)
    n = jet;
    n(1,:) = [ 1 1 1 ];
    colormap(n);
    set(gca,'xtick',[],'ytick',[]);
    set(gca,'Position',[0 0 1 1]);
    str = "STFT";
    name = strcat(str,string(i),'.png');
    savePath = 'STFT特征保存\猪叫声';
    mkdir(savePath);
    name = fullfile(savePath,name)
    saveas(gcf, name);   
    pigJ(:,:,i) = stft;
end
pigJ_model = mean(pigJ,3);

% 循环遍历所有音频文件，并进行裁剪
folderPath = '猪叫声裁剪后\猪咳嗽';
audioFiles = {};
% 获取文件夹下的所有文件
files = dir(fullfile(folderPath, '*.wav'));
% 遍历文件列表
for i = 1:length(files)
    audioFiles{end+1} = fullfile(folderPath, files(i).name);
end
% 读取音频文件
pigK = zeros(129,48,length(audioFiles));
for i = 1:length(audioFiles)
    % 读取音频文件
    [y, Fs] = audioread(audioFiles{i});
    y = double(y);
    y = y(Fs:length(y));
    SampFreq = 8000;
    y = resample(y,SampFreq, Fs);
    Fs = 8000;
    
   % STFT
    winLength = round(0.025*Fs); % 窗口长度（帧长）
    overlap = round(0.01*Fs); % 帧重叠长度
    nfft = 2^nextpow2(winLength); % FFT长度
    window = hamming(winLength, 'periodic'); % 窗口函数
    noverlap = winLength - overlap; % 不重叠窗口长度
    [S, F, T] = spectrogram(y, window, noverlap, nfft, Fs, 'yaxis');
    stft=20*log10(abs(S));
    figure;
    imagesc(T, F, stft)
    % 取出边框
    n = jet;
    n(1,:) = [ 1 1 1 ];
    colormap(n);
    set(gca,'xtick',[],'ytick',[]);
    set(gca,'Position',[0 0 1 1]);
    
    str = "STFT";
    name = strcat(str,string(i),'.png');
    savePath = 'STFT特征保存\猪咳嗽';
    mkdir(savePath);
    name = fullfile(savePath,name)
    saveas(gcf, name);
    pigK(:,:,i) = stft;
end
pigK_model = mean(pigK,3);

% 循环遍历所有音频文件，并进行裁剪
folderPath = '猪叫声裁剪后\猪打呼';
audioFiles = {};
% 获取文件夹下的所有文件
files = dir(fullfile(folderPath, '*.wav'));
% 遍历文件列表
for i = 1:length(files)
    audioFiles{end+1} = fullfile(folderPath, files(i).name);
end
% 读取音频文件
pigD = zeros(129,48,length(audioFiles));
for i = 1:length(audioFiles)
    % 读取音频文件
    [y, Fs] = audioread(audioFiles{i});
    y = double(y);
    y = y(Fs:length(y));
    SampFreq = 8000;
    y = resample(y,SampFreq, Fs);
    Fs = 8000;
    
    % STFT
    winLength = round(0.025*Fs); % 窗口长度（帧长）
    overlap = round(0.01*Fs); % 帧重叠长度
    nfft = 2^nextpow2(winLength); % FFT长度
    window = hamming(winLength, 'periodic'); % 窗口函数
    noverlap = winLength - overlap; % 不重叠窗口长度
    [S, F, T] = spectrogram(y, window, noverlap, nfft, Fs, 'yaxis');
    stft=20*log10(abs(S));
    
    
    figure;
    imagesc(T, F, stft)
    n = jet;
    n(1,:) = [ 1 1 1 ];
    colormap(n);
    set(gca,'xtick',[],'ytick',[]);
    set(gca,'Position',[0 0 1 1]);
    str = "STFT";
    name = strcat(str,string(i),'.png');
    savePath = 'STFT特征保存\猪打呼';
    mkdir(savePath);
    name = fullfile(savePath,name)
    saveas(gcf, name);
    pigD(:,:,i) = stft;
end
pigD_model = mean(pigJ,3);


%=================================对类别检测并求准确率=====================================
folderPath = '猪叫声裁剪后\猪咳嗽';
audioFiles = {};

% 获取文件夹下的所有文件
files = dir(fullfile(folderPath, '*.wav'));

% 遍历文件列表
for i = 1:length(files)
    audioFiles{end+1} = fullfile(folderPath, files(i).name);
end

% 读取音频文件
rightCounter = zeros(1,length(audioFiles));
for i = 1:length(audioFiles)
    [y, Fs] = audioread(audioFiles{i});
    % 做预处理
    y = double(y);
    y = y(Fs:length(y));
    SampFreq = 8000;
    y = resample(y,SampFreq, Fs);
    Fs = 8000;
    
   % STFT
    winLength = round(0.025*Fs); % 窗口长度（帧长）
    overlap = round(0.01*Fs); % 帧重叠长度
    nfft = 2^nextpow2(winLength); % FFT长度
    window = hamming(winLength, 'periodic'); % 窗口函数
    noverlap = winLength - overlap; % 不重叠窗口长度
    [S, F, T] = spectrogram(y, window, noverlap, nfft, Fs, 'yaxis');
    stft=20*log10(abs(S));
    %求欧氏距离
    dist1 = sum((stft-pigJ_model).^2,'all');
    dist2 = sum((stft-pigK_model).^2,'all');
    dist3 = sum((stft-pigD_model).^2,'all');
    distMatrix = [dist1 dist2 dist3];
    % 使用max函数求得最大值和位置
    [min_value, min_index] = min(distMatrix);
    predictionLabel=labelCell{min_index}
    % 判断是否正确
    if predictionLabel == '猪咳嗽'
        rightCounter(i)=1;
    end
end
Accurcy = (sum(rightCounter)/length(audioFiles)) * 100;
str = "%";
consequence = strcat(string(Accurcy),str)