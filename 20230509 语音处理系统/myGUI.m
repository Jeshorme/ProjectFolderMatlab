function myGUI
    % 创建一个figure窗口
    f = figure('Position', [020, 200, 720, 650],'Name', '语音信号处理系统');
    % 创建下拉菜单
    filterMethods = {'FIR滤波-布莱克曼', 'IIR滤波-巴特沃夫'};
    filterDropdown = uicontrol('Style', 'popupmenu', 'String', strjoin(filterMethods, '|'), 'Position', [440 250 100 20]);
    % 创建文本框
    ResultText = uicontrol('Style', 'text', 'String', '执行提示', 'Position', [300, 20, 350, 50],'fontsize',20);
    handles.low_label = uicontrol(f, 'Style', 'text', 'Position', [40 270 120 20], 'String', '低通截止\带通带阻下限');
    handles.low_freq = uicontrol(f, 'Style', 'edit', 'Position', [50 250 100 20], 'String', '0', 'Callback', @(hObject,eventdata) applyParameter(hObject, eventdata));
    handles.high_label = uicontrol(f, 'Style', 'text', 'Position', [170 270 120 20], 'String', '高通截止\带通带阻上限');
    handles.high_freq = uicontrol(f, 'Style', 'edit', 'Position', [180 250 100 20], 'String', '0', 'Callback', @(hObject,eventdata) applyParameter(hObject, eventdata));
    
    handles.low_label = uicontrol(f, 'Style', 'text', 'Position', [310 270 100 20], 'String', '输入STFT窗长');
    handles.winlength = uicontrol(f, 'Style', 'edit', 'Position', [310 250 100 20], 'String', '0', 'Callback', @(hObject,eventdata) applyParameter(hObject, eventdata));
    handles.high_label = uicontrol(f, 'Style', 'text', 'Position', [310 210 100 20], 'String', '输入STFT中nfft');
    handles.nfft = uicontrol(f, 'Style', 'edit', 'Position', [310 190 100 20], 'String', '0', 'Callback', @(hObject,eventdata) applyParameter(hObject, eventdata));
    
    handles.low_label = uicontrol(f, 'Style', 'text', 'Position', [570 270 100 20], 'String', '小波分解层数');
    handles.level = uicontrol(f, 'Style', 'edit', 'Position', [570 250 100 20], 'String', '0', 'Callback', @(hObject,eventdata) applyParameter(hObject, eventdata));
    
    handles.freq_l = uicontrol(f, 'Style', 'text', 'Position', [180, 130, 100, 30], 'String', '输入噪声频率');
    handles.freq = uicontrol(f, 'Style', 'edit', 'Position', [180, 110, 100, 30], 'String', '0', 'Callback', @(hObject,eventdata) applyParameter(hObject, eventdata));
    
    handles.f_l = uicontrol(f, 'Style', 'text', 'Position', [180, 70, 100, 30], 'String', '输入滤波器阶数');
    handles.f_step = uicontrol(f, 'Style', 'edit', 'Position', [180, 50, 100, 30], 'String', '0', 'Callback', @(hObject,eventdata) applyParameter(hObject, eventdata));
    
%     handles.input_label = uicontrol(f, 'Style', 'text', 'Position', [50 270 100 20], 'String', '输入下限\Hz');
%     handles.input_edit = uicontrol(f, 'Style', 'edit', 'Position', [50 250 100 20], 'String', '0', 'Callback', @(obj,event) applyParameter(obj, event));
%  

%     low_label = uicontrol(f, 'Style', 'text', 'Position', [50 270 100 20], 'String', '输入下限\Hz');
%     handles.low_freq = uicontrol(f, 'Style', 'edit', 'Position', [50 250 100 20], 'String', '0', 'Callback', @(hObject,eventdata) applyParameter(hObject, eventdata));
%     

%     high_label = uicontrol(f, 'Style', 'text', 'Position', [180 270 100 20], 'String', '输入上限\Hz');
%     handles.high_freq = uicontrol(f, 'Style', 'edit', 'Position', [180 250 100 20], 'String', '0', 'Callback', @(hObject,eventdata) applyParameter(hObject, eventdata));
%     


%     low_label = uicontrol(f, 'Style', 'text', 'Position', [50 270 100 20], 'String', '下限\Hz');
%     low_freq = uicontrol(f, 'Style', 'edit', 'Position', [50 250 100 20], 'String', '0', 'Callback', @(obj,event) applyParameter(obj, event));
%     

%     low_label = uicontrol(f, 'Style', 'text', 'Position', [50 270 100 20], 'String', '上限\Hz');
%     low_freq = uicontrol(f, 'Style', 'edit', 'Position', [50 250 100 20], 'String', '0', 'Callback', @(obj,event) applyParameter(obj, event));

    guidata(f, handles);% 保存handles结构体到GUI窗口中
    % 创建按钮
    uicontrol('Style', 'pushbutton', 'String', '打开音频文件', 'Position', [50, 210, 100, 30], 'Callback', @open);
    uicontrol('Style', 'pushbutton', 'String', '开始录音', 'Position', [50, 170, 100, 30], 'Callback', @start_recording);
    uicontrol('Style', 'pushbutton', 'String', '停止录音', 'Position', [50, 130, 100, 30], 'Callback', @stop_recording);
    uicontrol('Style', 'pushbutton', 'String', '播放音频', 'Position', [50, 90, 100, 30], 'Callback', @sound);
    uicontrol('Style', 'pushbutton', 'String', '停止播放音频', 'Position', [50, 50, 100, 30], 'Callback', @stop_audio);
   
    
    
%     uicontrol('Style', 'pushbutton', 'String', '展示时域波形', 'Position', [180, 210, 100, 30], 'Callback', @timeIm);
%     uicontrol('Style', 'pushbutton', 'String', '展示频域波形', 'Position', [180, 170, 100, 30], 'Callback', @freIm);
    uicontrol('Style', 'pushbutton', 'String', '单频噪声', 'Position', [180, 210, 100, 30], 'Callback', @singleNoise);
    uicontrol('Style', 'pushbutton', 'String', '白噪声', 'Position', [180, 170, 100, 30], 'Callback', @whiteNoise);
    
%     uicontrol('Style', 'pushbutton', 'String', '加噪后时域', 'Position', [310, 210, 100, 30], 'Callback', @addNoiseT);
%     uicontrol('Style', 'pushbutton', 'String', '加噪后频域', 'Position', [310, 170, 100, 30], 'Callback', @addNoiseF);
    
    uicontrol('Style', 'pushbutton', 'String', '高通滤波', 'Position', [440, 210, 100, 30], 'Callback', @highPass);
    uicontrol('Style', 'pushbutton', 'String', '低通滤波', 'Position', [440, 170, 100, 30], 'Callback', @lowPass);
    uicontrol('Style', 'pushbutton', 'String', '带通滤波', 'Position', [440, 130, 100, 30], 'Callback', @bandPass);
    uicontrol('Style', 'pushbutton', 'String', '带阻滤波', 'Position', [440, 90, 100, 30], 'Callback', @bandStop);
    
%     uicontrol('Style', 'pushbutton', 'String', '去噪后时域', 'Position', [570, 210, 100, 30], 'Callback', @deNoiseT);
%     uicontrol('Style', 'pushbutton', 'String', '去噪后频域', 'Position', [570, 170, 100, 30], 'Callback', @deNoiseF);
    uicontrol('Style', 'pushbutton', 'String', '短时傅里叶分析', 'Position', [570, 210, 100, 30], 'Callback', @STFT);
    uicontrol('Style', 'pushbutton', 'String', '小波分析', 'Position', [570, 170, 100, 30], 'Callback', @wave);
    uicontrol('Style', 'pushbutton', 'String', '关闭系统', 'Position', [570, 90, 100, 70], 'Callback', @closefig);

    % 创建图形显示区域
    originalAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [50, 350, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '时域图', 'Position', [130, 600, 100, 30],'fontsize',15);
    
    enhanceAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [420, 350, 250, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '频域图', 'Position', [500, 600, 100, 30],'fontsize',15);
    
%     addtAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [690, 320, 250, 250]);
%     uicontrol('Parent', f, 'Style', 'text', 'String', '加噪后时域图:', 'Position', [770, 550, 100, 20]);
%     
%     dentAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [1010, 320, 250, 250]);
%     uicontrol('Parent', f, 'Style', 'text', 'String', '去噪时域结果', 'Position', [1090, 550, 100, 20]);
%     
%     filterAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [1010, 200, 250, 100]);
%     uicontrol('Parent', f, 'Style', 'text', 'String', '滤波器幅频响应', 'Position', [1090, 280, 100, 20]);
%     
%     denfAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [1010, 50, 250, 120]);
%     uicontrol('Parent', f, 'Style', 'text', 'String', '去噪频域结果', 'Position', [1090, 150, 100, 20]);
%     
%     addfAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [690, 50, 250, 250]);
%     uicontrol('Parent', f, 'Style', 'text', 'String', '加噪后频域图', 'Position', [770, 280, 100, 20]);
%     
%     stftAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [1330, 320, 250, 250]);
%     uicontrol('Parent', f, 'Style', 'text', 'String', '短时傅里叶分析结果', 'Position', [1410, 550, 100, 20]);
%     
%     waveAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [1330, 50, 250, 250]);
%     uicontrol('Parent', f, 'Style', 'text', 'String', '小波分析结果', 'Position', [1410, 280, 100, 20]);
%     
    
    
    % 全局变量
    audio_data = [];
    fs=[];
    enhanced_img = [];
    edge_img = [];
    binarizeImage = [];
    morphologicalImage= [];
    
%   char_recognition_model = load('char_recognition_model.mat');
    labelAll =[];
    function open(hObject, eventdata)
        [filename, pathname] = uigetfile({'*.wav;*.mp3;*.ogg;*.flac', 'Audio files (*.wav;*.mp3;*.ogg;*.flac)'}, '选择音频文件');
        if isequal(filename, 0) || isequal(pathname, 0)
            return;
        end
        [audio_data, fs] = audioread(fullfile(pathname, filename));
        set(ResultText, 'String', '音频已打开请继续操作');
    end

    % 初始化录音对象
    fs = 44100;
    bits = 16;
    channels = 1;
    recorder = audiorecorder(fs, bits, channels);
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
%         % 将音频数据保存为一个新文件
%         file_name = 'new_audio_file.wav';
%         audiowrite(file_name, audio_data, sample_rate);
        
    end
    
    function sound(src, event)       
        % 播放录制的音频
        set(ResultText, 'String', '正在播放');
        % 显示时域
        axes(originalAxes);
        t = 0:1/fs:length(audio_data)/fs-(1/fs);
        plot(t,audio_data);
        xlabel('时间 (s)');ylabel('幅度');
        % 显示频域
        fft_sound = fft(audio_data);
        axes(enhanceAxes);
        L=length(audio_data);
        f = fs*(0:(L/2))/L;
        plot(abs(fft_sound));
        xlabel('频率 (Hz)');ylabel('幅度（dB）');
        soundsc(audio_data, fs);
    end

    % 定义停止播放函数
    function stop_audio(src, event)
        % 停止播放音频
        clear sound;
    end

%     function timeIm(hObject, eventdata)       
%         % 播放录制的音频
%         axes(originalAxes);
%         t = 0:1/fs:length(audio_data)/fs-1/fs;
%         plot(t,audio_data);
%     end
    
%     function freIm(hObject, eventdata)   
%         % 播放录制的音频
%         fft_sound = fft(audio_data);
%         axes(enhanceAxes);
%         L=length(audio_data);
%         f = fs*(0:(L/2))/L;
%         plot(abs(fft_sound));
% %         xlabel('频率 (Hz)');ylabel('幅度');
%     end

    noise = [];
    global freq
    function singleNoise(hObject, eventdata)       
        % 设置参数
%         freq = 500; % 单频噪声频率
        amp = 0.005; % 噪声信号幅度
        duration = length(audio_data)/fs; % 噪声持续时间

        % 生成单频噪声
        t = (0:1/fs:duration-1/fs)';
        noise = amp*sin(2*pi*freq*t);
        set(ResultText, 'String', '已获取单频噪声');
        %加噪
        addNdata = audio_data+noise;
        axes(originalAxes)
        plot(addNdata)
        xlabel('时间 (s)');ylabel('幅度');
        %加噪频域
        fredata = fft(addNdata);
        axes(enhanceAxes)
        plot(abs(fredata))
        xlabel('频率 (Hz)');ylabel('幅度（dB）');
        
    end


    function whiteNoise(hObject, eventdata)       
        % 设置参数
%         freq = 500; % 单频噪声频率
        amp = 0.005; % 噪声信号幅度
        duration = length(audio_data)/fs; % 噪声持续时间

        % 生成白噪声
        t = (0:1/fs:duration-1/fs)';
        noise = amp*randn(length(t), 1);
        disp(length(noise))
        disp(length(audio_data))
        set(ResultText, 'String', '已获取白噪声');
        
        %加噪
        addNdata = audio_data+noise;
        axes(originalAxes)
        plot(addNdata)
        xlabel('时间 (s)');ylabel('幅度');
        %加噪频域
        %加噪
        addNdata = audio_data+noise;
        fredata = fft(addNdata);
        axes(enhanceAxes)
        plot(abs(fredata))
        xlabel('频率 (Hz)');ylabel('幅度（dB）');
    end
    
    global addNdata
    function addNoiseT(hObject, eventdata)       
        %加噪
        addNdata = audio_data+noise;
        axes(addtAxes)
        plot(addNdata)
    end
    
    function addNoiseF(hObject, eventdata)       
        %加噪频域
        %加噪
        addNdata = audio_data+noise;
        fredata = fft(addNdata);
        axes(addfAxes)
        plot(abs(fredata))
    end
    
    global low_freq high_freq
    function applyParameter(hObject, eventdata)
        % 读取输入的参数值
        handles = guidata(hObject);
        low_freq = str2double(get(handles.low_freq, 'String'));
        high_freq = str2double(get(handles.high_freq, 'String'));
        winLength = str2double(get(handles.winlength, 'String'));
        nfft = str2double(get(handles.nfft, 'String'));
        level = str2double(get(handles.level, 'String'));
        freq = str2double(get(handles.freq, 'String'));
        order = str2double(get(handles.f_step, 'String'));
        % 为滤波器设置默认值
        if order == 0
            order = 6; %滤波器阶数
        end
        str = strcat('当前下限和上限：',string(low_freq),'和',string(high_freq));
        % 在命令窗口中显示参数值
        set(ResultText, 'String', str);
    end
    
    
    
    %'FIR滤波-布莱克曼', 'IIR滤波-巴特沃夫'
    global a b order
    function highPass(hObject, eventdata)
        method = filterMethods{get(filterDropdown, 'Value')};
        switch method
            case 'FIR滤波-布莱克曼'
                %L是滤波器长度，其常用方法是根据滤波器的截止频率来确定。一般来说，滤波器的长度L与截止频率有关，可以使用下述公式进行估计
                L = 51; % 滤波器长度
                w = blackman(L); % 生成布莱克曼窗
                b = fir1(L-1, high_freq/(fs/2), 'high', w); % 生成滤波器系数
                [H, f_filter] = freqz(b, 1, 1024, fs); % 计算滤波器的频率响应
                % 绘制滤波器的幅度响应
                figure;
                plot(f_filter, abs(H));
                title('高通滤波器幅频特性(FIR滤波-布莱克曼)');
                xlabel('频率 (Hz)');
                ylabel('幅度');
                DNaudio_data = filter(b, 1, audio_data); % 对信号进行滤波
                axes(originalAxes)
                plot(DNaudio_data)
                xlabel('时间 (s)');ylabel('幅度');
                set(ResultText, 'String', '已得到去噪时域结果');
                DNfft = fft(DNaudio_data);
                axes(enhanceAxes)
                plot(abs(DNfft))
                xlabel('频率 (Hz)');ylabel('幅度（dB）');
                set(ResultText, 'String', '已得到去噪时域和频域结果');
            case 'IIR滤波-巴特沃夫'
                [b, a] = butter(order, high_freq/(fs/2), 'high');
                [h_low, w_low] = freqz(b, a);
                f_low = w_low/(2*pi)*fs;
                mag_low = abs(h_low);
        %         axes(filterAxes)
                figure;
                plot(f_low, mag_low);
                xlabel('频率 (s)');ylabel('幅度');
                title('高通滤波器幅频特性(IIR滤波-巴特沃夫)');
                set(ResultText, 'String', '已得到高通滤波器');
                DNaudio_data = filtfilt(b, a, audio_data);
                axes(originalAxes)
                plot(DNaudio_data)
                xlabel('时间 (s)');ylabel('幅度');
                set(ResultText, 'String', '已得到去噪时域结果');
                DNfft = fft(DNaudio_data);
                axes(enhanceAxes)
                plot(abs(DNfft))
                xlabel('频率 (Hz)');ylabel('幅度（dB）');
                set(ResultText, 'String', '已得到去噪时域和频域结果');
        end
        
    end

    function lowPass(hObject, eventdata)    
        method = filterMethods{get(filterDropdown, 'Value')};
        switch method
            case 'FIR滤波-布莱克曼'
                %L是滤波器长度，其常用方法是根据滤波器的截止频率来确定。
                % 设计和应用布莱克曼窗的低通滤波器
                L = 51; % 滤波器长度
                w = blackman(L); % 生成布莱克曼窗
                b = fir1(L-1, low_freq/(fs/2), 'low', w); % 生成滤波器系数
                DNaudio_data = filter(b, 1, audio_data); % 对信号进行滤波
                [H, f_filter] = freqz(b, 1, 1024, fs); % 计算滤波器的频率响应
                % 绘制滤波器的幅度响应
                figure;
                plot(f_filter, abs(H));
                title('低通滤波器幅频特性(FIR滤波-布莱克曼)');
                xlabel('频率 (Hz)');
                ylabel('幅度');
                DNaudio_data = filter(b, 1, audio_data); % 对信号进行滤波
                axes(originalAxes)
                plot(DNaudio_data)
                xlabel('时间 (s)');ylabel('幅度');
                set(ResultText, 'String', '已得到去噪时域结果');
                DNfft = fft(DNaudio_data);
                axes(enhanceAxes)
                plot(abs(DNfft))
                xlabel('频率 (Hz)');ylabel('幅度（dB）');
                set(ResultText, 'String', '已得到去噪时域和频域结果');
            case 'IIR滤波-巴特沃夫'
                [b, a] = butter(order, low_freq/(fs/2), 'low');
                [h_low, w_low] = freqz(b, a);
                f_low = w_low/(2*pi)*fs;
                mag_low = abs(h_low);
        %         axes(filterAxes)
                figure;
                plot(f_low, mag_low);
                xlabel('频率 (s)');ylabel('幅度');
                title('低通滤波器幅频特性(IIR滤波-巴特沃夫)');
                set(ResultText, 'String', '已得到低通滤波器');
                DNaudio_data = filtfilt(b, a, audio_data);
                axes(originalAxes)
                plot(DNaudio_data)
                xlabel('时间 (s)');ylabel('幅度');
                set(ResultText, 'String', '已得到去噪时域结果');
                DNfft = fft(DNaudio_data);
                axes(enhanceAxes)
                plot(abs(DNfft))
                xlabel('频率 (Hz)');ylabel('幅度（dB）');
                set(ResultText, 'String', '已得到去噪时域和频域结果');
        end
        
    end
    
    
    function bandPass(hObject, eventdata)   
        method = filterMethods{get(filterDropdown, 'Value')};
        switch method
            case 'FIR滤波-布莱克曼'
                %L是滤波器长度，其常用方法是根据滤波器的截止频率来确定。
                % 设计和应用布莱克曼窗的带通滤波器
                L = 51; % 滤波器长度
                w = blackman(L); % 生成布莱克曼窗
                b = fir1(L-1, [low_freq high_freq]/(fs/2), 'bandpass', w); % 生成滤波器系数
                [H, f_filter] = freqz(b, 1, 1024, fs); % 计算滤波器的频率响应
                % 绘制滤波器的幅度响应
                figure;
                plot(f_filter, abs(H));
                title('带通滤波器幅频特性(FIR滤波-布莱克曼)');
                xlabel('频率 (Hz)');
                ylabel('幅度');
                DNaudio_data = filter(b, 1, audio_data); % 对信号进行滤波
                axes(originalAxes)
                plot(DNaudio_data)
                xlabel('时间 (s)');ylabel('幅度');
                set(ResultText, 'String', '已得到去噪时域结果');
                DNfft = fft(DNaudio_data);
                axes(enhanceAxes)
                plot(abs(DNfft))
                xlabel('频率 (Hz)');ylabel('幅度（dB）');
                set(ResultText, 'String', '已得到去噪时域和频域结果');
            case 'IIR滤波-巴特沃夫'
                band_freq1 = [low_freq,high_freq];
                [b, a] = butter(order, band_freq1/(fs/2), 'bandpass');
                [h_low, w_low] = freqz(b, a);
                f_low = w_low/(2*pi)*fs;
                mag_low = abs(h_low);
        %         axes(filterAxes)
                figure;
                plot(f_low, mag_low);
                xlabel('频率 (s)');ylabel('幅度');
                title('带通滤波器幅频特性(IIR滤波-巴特沃夫)');
                set(ResultText, 'String', '已得到带通滤波器');
                DNaudio_data = filtfilt(b, a, audio_data);
                axes(originalAxes)
                plot(DNaudio_data)
                xlabel('时间 (s)');ylabel('幅度');
                set(ResultText, 'String', '已得到去噪时域结果');
                DNfft = fft(DNaudio_data);
                axes(enhanceAxes)
                plot(abs(DNfft))
                xlabel('频率 (Hz)');ylabel('幅度（dB）');
                set(ResultText, 'String', '已得到去噪时域和频域结果');
        end
        
    end
    
    function bandStop(hObject, eventdata)   
        method = filterMethods{get(filterDropdown, 'Value')};
        switch method
            case 'FIR滤波-布莱克曼'
                %L是滤波器长度，其常用方法是根据滤波器的截止频率来确定。
                % 设计和应用布莱克曼窗的带通滤波器
                L = 51; % 滤波器长度
                w = blackman(L); % 生成布莱克曼窗
                b = fir1(L-1, [low_freq high_freq]/(fs/2), 'stop', w); % 生成滤波器系数
                [H, f_filter] = freqz(b, 1, 1024, fs); % 计算滤波器的频率响应
                % 绘制滤波器的幅度响应
                figure;
                plot(f_filter, abs(H));
                title('带阻滤波器幅频特性(FIR滤波-布莱克曼)');
                xlabel('频率 (Hz)');
                ylabel('幅度');
                DNaudio_data = filter(b, 1, audio_data); % 对信号进行滤波
                axes(originalAxes)
                plot(DNaudio_data)
                xlabel('时间 (s)');ylabel('幅度');
                set(ResultText, 'String', '已得到去噪时域结果');
                DNfft = fft(DNaudio_data);
                axes(enhanceAxes)
                plot(abs(DNfft))
                xlabel('频率 (Hz)');ylabel('幅度（dB）');
                set(ResultText, 'String', '已得到去噪时域和频域结果');
            case 'IIR滤波-巴特沃夫'
                band_freq2 = [low_freq,high_freq];
                [b, a] = butter(order, band_freq2/(fs/2), 'stop');
                [h_low, w_low] = freqz(b, a);
                f_low = w_low/(2*pi)*fs;
                mag_low = abs(h_low);
        %         axes(filterAxes)
                figure;
                plot(f_low, mag_low);
                xlabel('频率 (s)');ylabel('幅度');
                title('带阻滤波器幅频特性(IIR滤波-巴特沃夫)');
                set(ResultText, 'String', '已得到带阻滤波器');
                DNaudio_data = filtfilt(b, a, audio_data);
                axes(originalAxes)
                plot(DNaudio_data)
                xlabel('时间 (s)');ylabel('幅度');
                set(ResultText, 'String', '已得到去噪时域结果');
                DNfft = fft(DNaudio_data);
                axes(enhanceAxes)
                plot(abs(DNfft))
                xlabel('频率 (Hz)');ylabel('幅度（dB）');
                set(ResultText, 'String', '已得到去噪时域和频域结果');
        end
        
    end
    
    global DNaudio_data
    function deNoiseT(hObject, eventdata)   
        DNaudio_data = filtfilt(b, a, audio_data);
        axes(dentAxes)
        plot(DNaudio_data)
        set(ResultText, 'String', '已得到去噪时域结果');
        
    end

    function deNoiseF(hObject, eventdata)   
        DNfft = fft(DNaudio_data);
        axes(denfAxes)
        plot(abs(DNfft))
        set(ResultText, 'String', '已得到去噪频域结果');
    end
    
    global y winLength nfft level
    function STFT(hObject, eventdata)   
        % STFT特征提取
        y = double(DNaudio_data);
        if length(y)>2*fs
            y = y(1:2*fs);
        end
        Fs = 8000;
        y = resample(y,fs, Fs);
        if winLength == 0 
            winLength = round(0.025*Fs); % 窗口长度（帧长）
        end
        overlap = round(0.01*Fs); % 帧重叠长度
        if nfft == 0
            nfft = 2^nextpow2(winLength); % FFT长度
        end
        window = hamming(winLength, 'periodic'); % 窗口函数
        noverlap = winLength - overlap; % 不重叠窗口长度
        [S, F, T] = spectrogram(y, window, noverlap, nfft, fs, 'yaxis');
%         axes(stftAxes)
        figure;
        imagesc(T, F, 20*log10(abs(S)));
        title('STFT分析结果');
        xlabel('时间帧');ylabel('频率（Hz）');
    end

    function wave(hObject, eventdata)   
        % 小波变换特征提取
        wname = 'db4'; % 小波基函数名称
        if level==0
            level=5;
        end
        [c, l] = wavedec(DNaudio_data, level, wname);
        A = appcoef(c, l, wname, level); % 逼近系数（低频部分）
        D = detcoef(c, l, level); % 细节系数（高频部分）
        wavecoef = [A; D]; 
%         axes(waveAxes)
        figure;
        plot(c);title('小波分析结果');
        xlabel('采样点');ylabel('幅度');
    end

    function closefig(hObject, eventdata)   
       close all;
    end

end