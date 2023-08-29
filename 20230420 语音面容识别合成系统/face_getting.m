camera = webcam;
faceDetector = vision.CascadeObjectDetector;
num_images = 20;
save_dir = 'C:\Users\64148\Desktop\兼职工作文件夹\20230420（700）\orl_faces\s11';
mkdir(save_dir);
for i = 1:num_images
    img = snapshot(camera);
    bbox = step(faceDetector, img);
    if ~isempty(bbox)
        % 裁剪出人脸图像
        face = imcrop(img,bbox(1,:));
        face = rgb2gray(face);
        % 将人脸图像调整为卷积神经网络所需的尺寸
        face = imresize(face,[112 92]);
        imshow(face);
        file_path = fullfile(save_dir,sprintf('image%d.jpg', i));
        imwrite(face,file_path);
    else
        fprintf('未检测到人脸.\n');
    end
end
% 断开连接并释放摄像头
clear camera;
