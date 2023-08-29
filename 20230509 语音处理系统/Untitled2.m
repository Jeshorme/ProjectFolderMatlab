% 指定滤波器参数
fs=40000
order = 4; % 滤波器阶数
low_freq = 1000; % 低通滤波器截止频率
high_freq = 5000; % 高通滤波器截止频率
band_freq1 = [2000, 3000]; % 带通滤波器通带频率
band_freq2 = [4000, 5000]; % 带阻滤波器阻带频率

% 设计滤波器
[b_low, a_low] = butter(order, low_freq/(fs/2), 'low');
[b_high, a_high] = butter(order, high_freq/(fs/2), 'high');
[b_bandpass, a_bandpass] = butter(order, band_freq1/(fs/2), 'bandpass');
[b_bandstop, a_bandstop] = butter(order, band_freq2/(fs/2), 'stop');

% 绘制低通滤波器幅频特性
[h_low, w_low] = freqz(b_low, a_low);
f_low = w_low/(2*pi)*fs;
mag_low = abs(h_low);
figure;
plot(f_low, mag_low);
xlabel('频率（Hz）');
ylabel('幅度');
title('低通滤波器幅频特性');

% 绘制高通滤波器幅频特性
[h_high, w_high] = freqz(b_high, a_high);
f_high = w_high/(2*pi)*fs;
mag_high = abs(h_high);
figure;
plot(f_high, mag_high);
xlabel('频率（Hz）');
ylabel('幅度');
title('高通滤波器幅频特性');

% 绘制带通滤波器幅频特性
[h_bandpass, w_bandpass] = freqz(b_bandpass, a_bandpass);
f_bandpass = w_bandpass/(2*pi)*fs;
mag_bandpass = abs(h_bandpass);
figure;
plot(f_bandpass, mag_bandpass);
xlabel('频率（Hz）');
ylabel('幅度');
title('带通滤波器幅频特性');

% 绘制带阻滤波器幅频特性
[h_bandstop, w_bandstop] = freqz(b_bandstop, a_bandstop);
f_bandstop = w_bandstop/(2*pi)*fs;
mag_bandstop = abs(h_bandstop);
figure;
plot(f_bandstop, mag_bandstop);
xlabel('频率（Hz）');
ylabel('幅度');
title('带阻滤波器幅频特性');



method = filterMethods{get(filterDropdown, 'Value')};
switch method
    case '均值滤波'
        filteredImage = imgaussfilt(noiseImage);
        filteredImage = rgb2gray(filteredImage);
    case '中值滤波'
        noiseImage = im2gray(noiseImage)
        filteredImage = medfilt2(noiseImage);
    case '高斯滤波'
        noiseImage = im2gray(noiseImage)
        filteredImage = imgaussfilt(noiseImage, 0.001);
end




高通滤波器

function y = highpass_blackman_fir_filter(x, fs, fc, L)
% x: 待滤波的信号
% fs: 采样频率
% fc: 截止频率
% L: 滤波器长度

w = blackman(L); % 生成布莱克曼窗
b = fir1(L-1, fc/(fs/2), 'high', w); % 生成滤波器系数
y = filter(b, 1, x); % 对信号进行滤波
end
低通滤波器

function y = lowpass_blackman_fir_filter(x, fs, fc, L)
% x: 待滤波的信号
% fs: 采样频率
% fc: 截止频率
% L: 滤波器长度

w = blackman(L); % 生成布莱克曼窗
b = fir1(L-1, fc/(fs/2), 'low', w); % 生成滤波器系数
y = filter(b, 1, x); % 对信号进行滤波
end
带通滤波器

function y = bandpass_blackman_fir_filter(x, fs, fc1, fc2, L)
% x: 待滤波的信号
% fs: 采样频率
% fc1: 通带下限频率
% fc2: 通带上限频率
% L: 滤波器长度

w = blackman(L); % 生成布莱克曼窗
b = fir1(L-1, [fc1/(fs/2), fc2/(fs/2)], 'bandpass', w); % 生成滤波器系数
y = filter(b, 1, x); % 对信号进行滤波
end
带阻滤波器

function y = bandstop_blackman_fir_filter(x, fs, fc1, fc2, L)
% x: 待滤波的信号
% fs: 采样频率
% fc1: 阻带下限频率
% fc2: 阻带上限频率
% L: 滤波器长度

w = blackman(L); % 生成布莱克曼窗
b = fir1(L-1, [fc1/(fs/2), fc2/(fs/2)], 'stop', w); % 生成滤波器系数
y = filter(b, 1, x); % 对信号进行滤波
end
