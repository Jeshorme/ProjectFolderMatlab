function s_out = med_process(s_in, flag)
% ��ֵ�˲�������
if nargin < 2
    flag = 0;
end

% �ж�����ͼ���ά��
if ndims(s_in) == 3
    % �������ͨ��ͼ������ת��Ϊ�Ҷ�ͼ��
    I = rgb2gray(s_in);
else
    % ����ǻҶ�ͼ����ֱ��ʹ��
    I = s_in;
end

% ������ͼ�������ֵ�˲�����
s_out = medfilt2(I);

% ���ݱ�־λ���п��ӻ�չʾ
if flag
    figure;
    subplot(2, 2, 1); imshow(I); title('ԭͼ');
    subplot(2, 2, 2); imhist(I); title('ԭͼֱ��ͼ');
    subplot(2, 2, 3); imshow(s_out); title('��ֵ�˲�');
    subplot(2, 2, 4); imhist(s_out); title('��ֵ�˲�ֱ��ͼ');
end
