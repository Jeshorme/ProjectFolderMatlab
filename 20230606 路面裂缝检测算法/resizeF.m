% 指定待处理的文件夹路径
folderPath = 'images';

% 获取文件夹下所有子文件夹
subFolders = dir(folderPath);
subFolders = subFolders([subFolders.isdir]);
subFolders = subFolders(~ismember({subFolders.name}, {'.', '..'}));

% 遍历子文件夹
for i = 1:numel(subFolders)
    % 获取当前子文件夹的路径
    subFolderPath = fullfile(folderPath, subFolders(i).name);
    
    % 获取当前子文件夹内所有图片文件
    imageFiles = dir(fullfile(subFolderPath, '*.jpg')); % 这里假设你的图片格式为 JPG，如果是其他格式请相应更改
    
    % 遍历图片文件
    for j = 1:numel(imageFiles)
        % 读取图片
        imagePath = fullfile(subFolderPath, imageFiles(j).name);
        image = imread(imagePath);
        
        % 调整图片大小为 400*300
        resizedImage = imresize(image, [300, 400]);
        
        resizedImage = im2gray(resizedImage);

        % 保存调整后的图片
        imwrite(resizedImage, imagePath);
    end
end
disp('已完成')
