% 初始化麦克风
fs = 8000; % 采样率
mic = audiorecorder(fs, 16, 1); % 创建一个音频录制器对象

% 开始录制语音信号
disp('开始录制语音信号...');
recordblocking(mic, 5); % 录制5秒钟的语音

% 获取录制的语音信号
speech = getaudiodata(mic);

% 播放录制的语音信号
disp('播放录制的语音信号...');
sound(speech, fs);
dir = 'C:\Users\64148\Desktop\兼职工作文件夹\20230420（700）\自组10个人语音包作为数据集\s11\';
mkdir(dir);
path = 'C:\Users\64148\Desktop\兼职工作文件夹\20230420（700）\自组10个人语音包作为数据集\s11\myvoice1.wav';
audiowrite(path, speech, fs);
% 可以在这里对语音信号进行进一步的处理和分析
% ...
