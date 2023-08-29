function newim = adjgamma(im, g)
% ��������ͼ���Gamma��������ͼ������
% ������
%   im������ͼ��
%   g��Gamma��������ѡ��Ĭ��Ϊ1��
% ����ֵ��
%   newim���������ͼ��

if nargin < 2
    g = 1;  % ���δ�ṩGamma��������Ĭ��Ϊ1
end

if g <= 0
    error('Gamma�����������0');  % ���Gamma�����Ƿ����0�����С�ڵ���0���׳�����
end

if ndims(im) == 3
    I = rgb2gray(im);  % ���ͼ����RGB��ʽ����ת��Ϊ�Ҷ�ͼ��
else
    I = im;  % ����ͼ���Ѿ��ǻҶ�ͼ��
end

if isa(I, 'uint8')
    newim = double(I);  % ���ͼ����uint8���ͣ�ת��Ϊdouble����
else
    newim = I;  % ����ͼ���Ѿ���double����
end

newim = newim - min(min(newim));  % ��ͼ��Ҷ�ֵ��ȥ��Сֵ��ʹ����Сֵ��Ϊ0
newim = newim ./ max(max(newim));  % ��ͼ��Ҷ�ֵ�������ֵ��ʹ�����ֵ��Ϊ1
newim = newim .^ (1/g);  % ��ͼ�����GammaУ����ͨ����ÿ�����ص�ֵ������1/g��������������

% ���ص������ͼ��
