function [audio_data,fs]=soundRecorder
    % 创建一个figure窗口
    f = figure('Position', [020, 200, 200, 300],'Name', '录音器');
    % 创建文本框
    ResultText = uicontrol('Style', 'text', 'String', '执行提示', 'Position', [0, 0, 200, 20],'fontsize',10);
    % 创建文件名
    handles.file_label = uicontrol(f, 'Style', 'text', 'Position', [50 270 100 20], 'String', '输入音频文件名');
    handles.fileName = uicontrol(f, 'Style', 'edit', 'Position', [0 250 200 20], 'String', '0', 'Callback', @(hObject,eventdata) applyParameter(hObject, eventdata));
   
    % 创建按钮
    uicontrol('Style', 'pushbutton', 'String', '开始录音', 'Position', [50, 170, 100, 30], 'Callback', @start_recording);
    uicontrol('Style', 'pushbutton', 'String', '停止录音', 'Position', [50, 130, 100, 30], 'Callback', @stop_recording);
    uicontrol('Style', 'pushbutton', 'String', '播放音频', 'Position', [50, 90, 100, 30], 'Callback', @sound);
    uicontrol('Style', 'pushbutton', 'String', '保存音频', 'Position', [50, 50, 100, 30], 'Callback', @savesound);
    
    
    guidata(f, handles);% 保存handles结构体到GUI窗口中
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
    
    function sound(src, event)       
        % 播放录制的音频
        set(ResultText, 'String', '正在播放');
        soundsc(audio_data, fs);
    end
    
    function savesound(src, event)       
        % 将音频数据保存为一个新文件
        audiowrite(fileName, audio_data, fs);
    end

end