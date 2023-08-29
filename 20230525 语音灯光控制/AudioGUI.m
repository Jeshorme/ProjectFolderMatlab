function AudioGUI
    % 创建figure窗口
    fig = figure('Name', '展示界面', 'Position', [100, 100, 800, 400]);
    
    % 创建波形显示轴
%     colorAxes = axes('Parent', fig, 'Position', [0, 0, 1, 1]);
    waveformAxes = axes('Parent', fig, 'Position', [0.1, 0.55, 0.8, 0.4]);
    xlabel('Index');
    ylabel('Amplitude');
    title('Waveform');
    
    
    % 创建播放位置标签
    positionLabel = uicontrol('Parent', fig, 'Style', 'text', 'String', '运行提示', 'Position', [275, 100, 300, 20],'fontsize',10);
    
    % 创建录制按钮
    recordButton = uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', '识别语音', 'Position', [300, 20, 100, 40], 'Callback', @recognition);
    
    % 创建播放按钮
    playButton = uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', '给出反馈', 'Position', [450, 20, 100, 40], 'Callback', @sounding);
    
    % 创建打开语音按钮
    rewindButton = uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', '打开语音文件', 'Position', [150, 150, 60, 40], 'Callback', @open);
    
    % 创建播放按钮
    fastForwardButton = uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', '播放语音', 'Position', [600, 150, 60, 40], 'Callback', @record);
    
    % 创建关闭系统按钮
    fastForwardButton = uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', '关闭系统', 'Position', [740, 360, 60, 40], 'Callback', @closebutton);
    
    % 初始化录音对象
    recorder = audiorecorder(8000, 16, 1);
    audio_data = [];
    currentPosition = 1;
    net = load('model.mat');
    global fs
    function open(hObject, eventdata)
        [filename, pathname] = uigetfile({'*.wav;*.mp3;*.ogg;*.flac', 'Audio files (*.wav;*.mp3;*.ogg;*.flac)'}, '选择音频文件');
        if isequal(filename, 0) || isequal(pathname, 0)
            return;
        end
        
        [audio_data, fs] = audioread(fullfile(pathname, filename));
        sound = audio_data;
        sound_fs = fs;
        set(positionLabel, 'String', '音频已打开请继续操作');
    end
    
    %======================================================================================================================================================
        % 全局变量
    audio_data = [];  
    % 初始化录音对象
    fs = 44100;
    bits = 16;
    channels = 1;
    recorder = audiorecorder(fs, bits, channels);
    
    global fileName
    function applyParameter(hObject, eventdata)
        % 读取输入的参数值
        handles = guidata(hObject);
        fileName = get(handles.fileName, 'String');
        fileName = strcat(fileName,'.wav');
        fileName = fullfile('Soundfiles_feedback',fileName)
        % 在命令窗口中显示参数值
        set(ResultText, 'String', fileName);
    end
    % 开始录音的回调函数
    function start_recording(src, event)
        % 禁用开始录音按钮，启用停止录音按钮
        start_btn.Enable = 'off';
        stop_btn.Enable = 'on';
        
        % 开始录音
        set(ResultText, 'String', '开始录音...');
        record(recorder);
    end
    
    % 停止录音的回调函数
    function stop_recording(src, event)
        % 禁用停止录音按钮，启用开始录音按钮
        start_btn.Enable = 'on';
        stop_btn.Enable = 'off';
        
        % 停止录音
        stop(recorder);
        set(ResultText, 'String', '录音结束！');
        
        % 获取录制的音频数据
        audio_data = getaudiodata(recorder);

        
    end
    
%     function sound(src, event)       
%         % 播放录制的音频
%         set(ResultText, 'String', '正在播放');
%         soundsc(audio_data, fs);
%     end
    %======================================================================================================================================================
    global sound sound_fs
    % 录制按钮回调
    function record(hObject, eventdata)
        % 绘制波形
        plot(waveformAxes, audio_data);
        set(positionLabel, 'String', '正在播放音频');
        
        soundsc(sound, sound_fs);
    end

    % 快退按钮回调
    function recognition(hObject, eventdata)
        sampleRate=fs;
        SampFreq = 8000;
        audio_data = resample(audio_data,SampFreq, sampleRate);
        sampleRate = 8000;
        
%         % 将音频信号转换为STFT图像
%         winLength = round(0.025*sampleRate); % 窗口长度（帧长）
%         overlap = round(0.01*sampleRate); % 帧重叠长度
%         nfft = 2^nextpow2(winLength); % FFT长度
%         window = hamming(winLength, 'periodic'); % 窗口函数
%         noverlap = winLength - overlap; % 不重叠窗口长度
%         [S, F, T] = spectrogram(audioData, window, noverlap, nfft, sampleRate, 'yaxis');
%         stft=20*log10(abs(S));
        
        mfcc = MFCC(audio_data,sampleRate);
        figure('Name', '当前语音的MFCC结果');
        imagesc(mfcc);  % 显示STFT图像
        n = jet;
        n(1,:) = [ 1 1 1 ];
        colormap(n);
        set(gca,'xtick',[],'ytick',[]);
        set(gca,'Position',[0 0 1 1]);
        frame = getframe(gcf);  % 获取图形窗口的帧数据
        imgData = frame2im(frame);  % 将帧数据转换为图像数据
        imshow(imgData);title('当前语音的STFT结果');
        im2r = imresize(imgData,[128 128]);
        predictedLabels = classify(net.net,im2r);
        set(positionLabel, 'String', string(predictedLabels));
        label_audio = strcat(string(predictedLabels),'.png');
        imPath = fullfile('Images',label_audio)
        axes(waveformAxes)
        imshow(imPath);
    end


    global predictedLabels
    function sounding(hObject, eventdata)
        label_audio = strcat(string(predictedLabels),'.wav');
        audioPath = fullfile('Soundfiles_feedback',label_audio)
        [audio_data, Fs] = audioread(audioPath);
        soundsc(audio_data, Fs);
        str = strcat('当前语音信号指令为：',string(predictedLabels),'，播报中……')
        set(positionLabel,'String',str);
    end

    % 播放定时器回调
    function closebutton(hObject, eventdata)
        close all
    end

end