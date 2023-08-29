function s_out = hist_con(s_in, flag)
% �������s_inΪͼ�����ݣ�flagΪ�Ƿ���ʾ����ı�־λ
% ���δ�ṩflag������Ĭ��Ϊ0������ʾ���

if nargin < 2
    flag = 0;
end

% �ж�����ͼ���ά�ȣ����Ϊ3ά����ת��Ϊ�Ҷ�ͼ��
if ndims(s_in) == 3
    I = rgb2gray(s_in);
else
    I = s_in;
end

% �ԻҶ�ͼ�����ֱ��ͼ���⻯
s_out = histeq(I);

% ���flagΪ�棬����ʾԭͼ��ԭͼֱ��ͼ�����⻯����;��⻯���ֱ��ͼ
if flag
    figure;
    subplot(2, 2, 1); imshow(I); title('ԭͼ');
    subplot(2, 2, 2); imhist(I); title('ԭͼֱ��ͼ');
    subplot(2, 2, 3); imshow(s_out); title('���⻯���');
    subplot(2, 2, 4); imhist(s_out); title('���⻯���ֱ��ͼ');
end
