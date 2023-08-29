% 设置原始文件夹路径和目标文件夹路径
source_folder = 'ECG_datas';
target_folder = 'ECG_Database';

% 获取原始文件夹中的所有子文件夹
sub_folders = dir(source_folder);
sub_folders = sub_folders([sub_folders(:).isdir]);
sub_folders = sub_folders(~ismember({sub_folders(:).name},{'.','..'}));

% 遍历每个子文件夹
for i = 1:numel(sub_folders)
    % 获取当前子文件夹的路径
    current_folder = fullfile(source_folder, sub_folders(i).name);

    % 获取当前子文件夹中所有.mat文件的路径
    mat_files = dir(fullfile(current_folder, '*.mat'));

    % 遍历每个.mat文件
    for j = 1:numel(mat_files)
        % 加载.mat文件中的数据
        mat_file_path = fullfile(current_folder, mat_files(j).name);
        mat_data = load(mat_file_path);

        % 保存data_ecg数据到新的文件夹中
        [~, file_name, ~] = fileparts(mat_file_path);
        new_file_path = fullfile(target_folder, sub_folders(i).name, [file_name, '_ecg.mat']);
        data_ecg = mat_data.data_ecg;
        opath = fullfile(target_folder, sub_folders(i).name);
        mkdir(opath);
        save(new_file_path, 'data_ecg');
    end
end
