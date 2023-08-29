im=imread('7526.jpg');

%% 分割字符
fgray=rgb2gray(im);
level2=graythresh(fgray);
bw3=im2bw(fgray,level2);
% figure;imshow(bw3);title('定位剪切后的二值图像');
se2=strel('line',2,90);
se3=strel('cube',4);
se4=strel('disk',1);
bw3o=bwareaopen(bw3,30);
% figure;imshow(bw3o);title('删除小于20面积后的图像');
bw3oe=imerode(bw3o,se4);
% figure;imshow(bw3oe);title('二值图像腐蚀后')
bw3oc =imclose(bw3oe,se2);
% figure;imshow(bw3oc);title('二值图像闭运算后');
bw4=imclearborder(bw3oc);
figure;imshow(bw4);
bw4d=imdilate(bw4,se3);
bw4d=imdilate(bw4d,se3);
% figure;imshow(bw4d);title('膨胀后的图像');
bw5=bwareaopen(bw4d,400);
% figure;imshow(bw5);title('删除小于400后的图像');  
s2=regionprops(bw5,'BoundingBox','Centroid');
for i=1:length(s2)
    xy=s2(i).BoundingBox;
    bw6=im(floor(xy(2)):floor(xy(2)+xy(4)),floor(xy(1)):floor(xy(1)+xy(3)),:);
    bw6 = imresize(bw6,[32 32]);
%     subplot(1,7,i);imshow(bw6);title(num2str(i));
    name = strcat('云',num2str(i),'.jpg');
    path = fullfile('自建车牌数据库',name)
    imwrite(bw6,path)
end


