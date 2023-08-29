% 这个是提取三种特征的源代码，你看着

% 读取音频文件
filename = 'C:\Users\64148\Desktop\兼职工作文件夹\20230426（500）猪叫声语音识别系统\Dataset\1689-3.wav'; % 在这里选择需要提取的声音就好了
[y, Fs] = audioread(filename);
y = y(:,1);
%一般来说，成年猪的最高频率通常在2,000 Hz到8,000 Hz之间。
y = double(y);

SampFreq = 8000;
y = resample(y,SampFreq, Fs);
Fs = 8000;
y = y(1:length(y));
% 小波变换特征提取

wname = 'db4'; % 小波基函数名称
level = 5; % 分解级数
[c, l] = wavedec(y, level, wname);
A = appcoef(c, l, wname, level); % 逼近系数（低频部分）
D = detcoef(c, l, level); % 细节系数（高频部分）
wavecoef = [A;D];

% MFCC特征提取
% mfccs = mfcc(y', Fs);
m = MFCC(y,Fs);

% STFT特征提取
winLength = round(0.025*Fs); % 窗口长度（帧长）
overlap = round(0.01*Fs); % 帧重叠长度
nfft = 2^nextpow2(winLength); % FFT长度
window = hamming(winLength, 'periodic'); % 窗口函数
noverlap = winLength - overlap; % 不重叠窗口长度
[S, F, T] = spectrogram(y, window, noverlap, nfft, Fs, 'yaxis');
stft=20*log10(abs(S));

% 绘制图像
figure;
subplot(4,1,1);
plot(y);
title('原始音频');

subplot(4,1,2);
imagesc(A);hold on;plot(D);hold off;
title('小波变换特征');
colorbar;


subplot(4,1,3);
imagesc(m);
title('MFCC特征');
colorbar;

% 显示STFT特征
subplot(4,1,4);
imagesc(T, F, 20*log10(abs(S)));
axis xy;
title('STFT特征');
xlabel('时间（秒）');
ylabel('频率（Hz）');
colorbar;
