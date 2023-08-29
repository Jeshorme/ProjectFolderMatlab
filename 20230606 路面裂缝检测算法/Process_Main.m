function Result = Process_Main(I)
% ����������������ͼ�����һϵ�д��������ؽ��

% �ж�����ͼ���ά�ȣ���Ϊ��ɫͼ����ת��Ϊ�Ҷ�ͼ��
if ndims(I) == 3
    I1 = rgb2gray(I);
else
    I1 = I;
end

% ֱ��ͼ���⻯
I2 = hist_con(I1);

% ��ֵ�˲�
I3 = med_process(I2);

% �Աȶ���ǿ
I4 = adjgamma(I3, 2);

% ������ֵ����
[bw, th] = IterProcess(I4);

% ȡ�����õ��ѷ�ͼ��
bw = ~bw;

% ʹ�óߴ��˲������ѷ�ͼ����д���
bwn1 = bw_filter(bw, 15);

% �Դ������ѷ�ͼ����б�Ǻ�ɸѡ
bwn2 = Identify_Object(bwn1);

% �����ѷ�ͼ�����ͶӰ����ͶӰ
[projectr, projectc] = Project(bwn2);

% ��ȡ�ѷ�ͼ��ĳߴ�
[r, c] = size(bwn2);

% ���ѷ�ͼ������ѷ��ж�����
bwn3 = Judge_Crack(bwn2, I4);

% ���ѷ�ͼ������ѷ����Ӵ���
bwn4 = Bridge_Crack(bwn3);

% �ж��ѷ�ķ���
[flag, rect] = Judge_Direction(bwn4);

% �����ѷ췽��ȷ������ַ������ѷ��ȵ�������Сֵ
if flag == 1
    str = '�����ѷ�';
    wdmax = max(projectc);
    wdmin = min(projectc);
else
    str = '�����ѷ�';
    wdmax = max(projectr);
    wdmin = min(projectr);
end

% ��������ṹ��
Result.Image = I1;
Result.hist = I2;
Result.Medfilt = I3;
Result.Enance = I4;
Result.Bw = bw;
Result.BwFilter = bwn1;
Result.CrackRec = bwn2;
Result.Projectr = projectr;
Result.Projectc = projectc;
Result.CrackJudge = bwn3;
Result.CrackBridge = bwn4;
Result.str = str;
Result.rect = rect;
Result.BwEnd = bwn4;
Result.BwArea = bwarea(bwn4);%�����ѷ����
Result.BwLength = max(rect(3:4));
Result.BwWidthMax = wdmax;
Result.BwWidthMin = wdmin;
Result.BwTh = th;
