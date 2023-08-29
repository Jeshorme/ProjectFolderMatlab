%{
小波能量解释：
小波变换将信号分解为不同频率和时间的分量，可以帮助我们了解信号能量在不同频率范围和时间段内的分布情况。
通过观察小波变换的逼近系数（低频部分）和细节系数（高频部分），我们可以了解信号在不同尺度和频带上的能量分布情况。
基于能量差异，考虑用于判别分析。
判别分析的依据：
通过对所有数据提取特征并求出均值模板，然后将待测数据与均值模板求欧氏距离，判断最小距离为其类别
%}
% 这个是利用小波变换来进行if识别的，你看一下

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
pigJ = zeros(262,length(audioFiles));
for i = 1:length(audioFiles)
    % 读取音频文件
    [y, Fs] = audioread(audioFiles{i});
    y = double(y);
    y = y(Fs:length(y));
    SampFreq = 8000;
    y = resample(y,SampFreq, Fs);
    Fs = 8000;
    wname = 'db4'; % 小波基函数名称
    level = 5; % 分解级数
    [c, l] = wavedec(y, level, wname);
    A = appcoef(c, l, wname, level); % 逼近系数（低频部分）
    D = detcoef(c, l, level); % 细节系数（高频部分）
    wavecoef = [A;D]; % 同时考虑高低频
    figure;
    imagesc(wavecoef)
    n = jet;
    n(1,:) = [ 1 1 1 ];
    colormap(n);
    set(gca,'xtick',[],'ytick',[]);
    set(gca,'Position',[0 0 1 1]);
    str = "wave";
    name = strcat(str,string(i),'.png');
    savePath = 'wave特征保存\猪叫声';
    mkdir(savePath);
    name = fullfile(savePath,name)
    saveas(gcf, name); % 为了方便后面神经网络识别；我们在这个过程中；就把特征图谱保存下来。以上理解了回复我
    
    pigJ(:,i) = wavecoef;
end
pigJ_model = mean(pigJ,2);

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
pigK = zeros(262,length(audioFiles));
for i = 1:length(audioFiles)
    % 读取音频文件
    [y, Fs] = audioread(audioFiles{i});
    y = double(y);
    y = y(Fs:length(y));
    SampFreq = 8000;
    y = resample(y,SampFreq, Fs);
    Fs = 8000;
    wname = 'db4'; % 小波基函数名称
    level = 5; % 分解级数
    [c, l] = wavedec(y, level, wname);
    A = appcoef(c, l, wname, level); % 逼近系数（低频部分）
    D = detcoef(c, l, level); % 细节系数（高频部分）
    wavecoef = [A;D]; % 同时考虑高低频
    figure;
    imagesc(wavecoef)
    n = jet;
    n(1,:) = [ 1 1 1 ];
    colormap(n);
    set(gca,'xtick',[],'ytick',[]);
    set(gca,'Position',[0 0 1 1]);
    str = "wave";
    name = strcat(str,string(i),'.png');
    savePath = 'wave特征保存\猪咳嗽';
    mkdir(savePath);
    name = fullfile(savePath,name)
    saveas(gcf, name);
    pigK(:,i) = wavecoef;
end
pigK_model = mean(pigK,2);

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
pigD = zeros(262,length(audioFiles));
for i = 1:length(audioFiles)
    % 读取音频文件
    [y, Fs] = audioread(audioFiles{i});
    y = double(y);
    y = y(Fs:length(y));
    SampFreq = 8000;
    y = resample(y,SampFreq, Fs);
    Fs = 8000;
    wname = 'db4'; % 小波基函数名称
    level = 5; % 分解级数
    [c, l] = wavedec(y, level, wname);
    A = appcoef(c, l, wname, level); % 逼近系数（低频部分）
    D = detcoef(c, l, level); % 细节系数（高频部分）
    wavecoef = [A;D]; % 同时考虑高低频
    figure;
    imagesc(wavecoef)
    n = jet;
    n(1,:) = [ 1 1 1 ];
    colormap(n);
    set(gca,'xtick',[],'ytick',[]);
    set(gca,'Position',[0 0 1 1]);
    str = "wave";
    name = strcat(str,string(i),'.png');
    savePath = 'wave特征保存\猪打呼';
    mkdir(savePath);
    name = fullfile(savePath,name)
    saveas(gcf, name);
    pigD(:,i) = wavecoef;
end
pigD_model = mean(pigJ,2);


%=================================识别过程=====================================
%{
将待识别信号读入并下采样，然后进行识别
%}

[y, Fs] = audioread('1659-3_cropped.wav');%读入待识别信号

% 做预处理
y = double(y);
y = y(Fs:length(y));
SampFreq = 8000;
y = resample(y,SampFreq, Fs);
Fs = 8000;
wname = 'db4';
level = 5;
[c, l] = wavedec(y, level, wname);
A = appcoef(c, l, wname, level);
D = detcoef(c, l, level);
wavecoef = [A;D];
%求欧氏距离
dist1 = pdist2(wavecoef', pigJ_model', 'euclidean');
dist2 = pdist2(wavecoef', pigK_model', 'euclidean');
dist3 = pdist2(wavecoef', pigD_model', 'euclidean');
distMatrix = [dist1 dist2 dist3];
% 使用max函数求得最大值和位置
[min_value, min_index] = min(distMatrix);
predictionLabel=labelCell{min_index};

%=================================对每个类别检测并求准确率=====================================
folderPath = '猪叫声裁剪后\猪叫声';
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
    wname = 'db4';
    level = 5;
    [c, l] = wavedec(y, level, wname);
    A = appcoef(c, l, wname, level);
    D = detcoef(c, l, level);
    wavecoef = [A;D];
    %求欧氏距离;K=1近邻
    dist1 = pdist2(wavecoef', pigJ_model', 'euclidean');
    dist2 = pdist2(wavecoef', pigK_model', 'euclidean');
    dist3 = pdist2(wavecoef', pigD_model', 'euclidean');
    distMatrix = [dist1 dist2 dist3];
    % 使用max函数求得最大值和位置
    [min_value, min_index] = min(distMatrix);
    predictionLabel=labelCell{min_index};
    % 判断是否正确；  ===========最终判断在这里；代码很简单，你肯定能看明白的=============都是一些二反复调用；
    if predictionLabel == '猪叫声'
        rightCounter(i)=1;
    end
    

end
Accurcy = (sum(rightCounter)/30) * 100;
str = "%";
consequence = strcat(string(Accurcy),str)