initial_data = xlsread('hw2p2_data.csv');

d_x1 = initial_data(:,1);
d_x2 = initial_data(:,2);
d_x3 = initial_data(:,3);
scatter3(d_x1,d_x2,d_x3,'x')
rotate3d on


%PCA过程
[row,cul] = size(initial_data);
covariance = cov(initial_data);%求协方差矩阵
[V,D] = eig(covariance);%求特征值分解
Average = mean(initial_data);%求数据均值
Average_data = repmat(Average,row,1);%构建均值矩阵
%%进行数据中心化（向原点平移），然后与最小重构代价的投影方向向量相乘，得到向最小重构代价方向投影后的数据
Score = (initial_data - Average_data)*V;
PCA_data = Score(:,398:400);
%取出特征值结果，进行降序排列
eigenvalue = zeros(1,400);
for i = 1:400
   eigenvalue(i) = D(401 - i,401 - i); 
end

bar(eigenvalue),title('PCA特征值降序直方图');
scatter3(PCA_data(:,1),PCA_data(:,2),PCA_data(:,3),'x')
rotate3d on