clc;
clear all;
% 读取语音文件
[x, Fs] = audioread('C:\Users\64148\Desktop\兼职工作文件夹\20230410（490）\Audios_cut\猫叫声_trimmed.wav');

% 将整数型数据类型转换为双精度型数据类型
x = double(x);
x = x(:,1);
SampFreq = 4000;
x = resample(x,SampFreq, Fs);

% 进行短时傅里叶变换 (STFT)
Fs = 4000; % 满足奈奎斯特采样定律
window_length = round(Fs * 0.03); % 窗口长度为30ms
hop_length = round(Fs * 0.01); % 窗口间隔为10ms
nfft = 2^nextpow2(window_length); % FFT点数取2的下一个幂
[S, f, t] = spectrogram(x, window_length, hop_length, nfft, Fs);

% 进行小波变换 (Wavelet Transform)
wavelet_name = 'db5'; % 小波名称
[C, L] = wavedec(x, 5, wavelet_name); % 进行5级小波分解

% 进行经验模态分解 (EMD)
imf = emd(x); % 进行EMD分解

% 绘制对比图
figure;
subplot(4, 1, 1);
imagesc(t, f, abs(S));
set(gca, 'YDir', 'normal');
xlabel('时间 (s)');
ylabel('频率 (Hz)');
title('短时傅里叶变换 (STFT)');

subplot(4, 1, 2);
plot(1:length(C), C);
xlabel('尺度 (Level)');
ylabel('系数 (Coefficient)');
title('小波变换 (Wavelet Transform)');

subplot(4, 1, 3);
plot(imf');
xlabel('样本点 (Sample Point)');
ylabel('幅度 (Amplitude)');
title('经验模态分解 (EMD)');

subplot(4, 1, 4);
plot(x);
title('原信号');
