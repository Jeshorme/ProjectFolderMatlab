% 指定需要处理的文件夹路径
folder_path = 'C:\Users\64148\Desktop\兼职工作文件夹\20230426(500soundR)\猪叫声数据集';

% 获取所有音频文件的路径
file_list = getAllFiles(folder_path);
audio_files = file_list(endsWith(file_list, '.wav'));

% 循环遍历所有音频文件，并进行裁剪
for i = 1:length(audio_files)
    % 读取音频文件
    [y, Fs] = audioread(audio_files{i});
    
    % 裁剪为1.5秒长度
    t_start = 0;
    t_end = 1.5;
    y_cropped = y(round(t_start*Fs)+1 : round(t_end*Fs), :);
    
    % 获取保存路径和文件名
    [~, name, ext] = fileparts(audio_files{i});
    save_path = fullfile(folder_path, [name, '_cropped', ext]);
    
    % 保存裁剪后的音频文件
    audiowrite(save_path, y_cropped, Fs);
end

% 获取指定文件夹及其子文件夹中的所有文件路径function fileList = getAllFiles(dirName)
    dirData = dir(dirName);
    dirIndex = [dirData.isdir];
    fileList = {dirData(~dirIndex).name}';
    if ~isempty(fileList)
        fileList = cellfun(@(x) fullfile(dirName,x),fileList,'UniformOutput',false);
    end
    subDirs = {dirData(dirIndex).name};
    validIndex = ~ismember(subDirs,{'.','..'});
    for iDir = find(validIndex)
        nextDir = fullfile(dirName,subDirs{iDir});
        fileList = [fileList; getAllFiles(nextDir)];
    end
end

