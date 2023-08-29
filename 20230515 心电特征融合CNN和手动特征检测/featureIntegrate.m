% 添加当前工作目录下的子文件夹"utils"到搜索路径
addpath('utils');

% 添加绝对路径到搜索路径
addpath('guangyu-bin-211');

% 设置原始文件夹路径和目标文件夹路径
source_folder = 'ECG_Database';
target_folder = 'ECG_Features';
% 加在预训练CNN模型
net = load('CNNmodel.mat');
% fcOutputs = activations(net, face, 'fc', 'OutputAs', 'rows');
% 获取原始文件夹中的所有子文件夹
sub_folders = dir(source_folder);
sub_folders = sub_folders([sub_folders(:).isdir]);
sub_folders = sub_folders(~ismember({sub_folders(:).name},{'.','..'}));

SampFreq = 10000;%心电的采样频率为10000
% 创建数据预存位置来保存融合特征，由于融合特征是31+128维
Xdata = zeros(133,159);
Ydata = zeros(133,1);
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
        new_file_path = fullfile(target_folder, sub_folders(i).name, [file_name, '_STFT.png']);
        data_ecg = mat_data.data_ecg;
        data_ecg = data_ecg(1:20000);%取前2秒进行处理
        
        df = 5000;% 进行降采样,df为降采样后的频率
        data_ecg = resample(data_ecg,SampFreq, df);
        % 将ECG信号转换为STFT图像
        winLength = 512; % 窗口长度（帧长）
        overlap = 128; % 帧重叠长度
        nfft = 2^nextpow2(winLength); % FFT长度
        window = hamming(winLength, 'periodic'); % 窗口函数
        noverlap = winLength - overlap; % 不重叠窗口长度
        [S, F, T] = spectrogram(data_ecg, window, noverlap, nfft, df, 'yaxis');
        stft=20*log10(abs(S));
        % 将STFT图像保存为图像文件
        imagesc(stft);  % 显示STFT图像
        n = jet;
        n(1,:) = [ 1 1 1 ];
        colormap(n);
        set(gca,'xtick',[],'ytick',[]);
        set(gca,'Position',[0 0 1 1]);
        opath = fullfile(target_folder, sub_folders(i).name);
        frame = getframe(gcf);  % 获取图形窗口的帧数据
        imgData = frame2im(frame);  % 将帧数据转换为图像数据
        imgEcg = imresize(imgData,[224 224]);
        %得到CNN特征
        CNN_Outputs = activations(net.net, imgEcg, 'fc128', 'OutputAs', 'rows');
        CNN_Outputs = double(CNN_Outputs);
        %得到手动特征（AFEv2,se,radius2,meanRR2,m,tPR, tQRS,tQT,Pamp,Qamp,Samp,Tamp，sqiratio,status,...
              %tQRS2,mtQRS1,mtQRS2, mtPR,mPamp ,mQamp, mRamp ,mSamp, mTamp,ST,qrmrp,tso,bVF,...
              %npvc...
              %ks_p12）
        features = ecg_feature_extract1(data_ecg,df);
        data = [CNN_Outputs features];
        % 将融合后的结果存入
        if i==1
            Xdata(j,:)=data;%存入融合后特征
            Ydata(j)=0; % 标签0表示异常
            num_abfile=numel(mat_files);
            
        else
            
            Xdata(j+num_abfile,:)=data;%存入融合后特征
            Ydata(j+num_abfile)=1; % 标签1表示正常
            
        end
%         mkdir(opath);
%         saveas(gcf, new_file_path);  % 保存图像
        close gcf;  % 关闭图像窗口
%         if i==2&j==2
%             break
%         end
    end
end
save('Xdata.mat','Xdata')
save('Ydata.mat','Ydata')
