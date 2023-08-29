clc;clear all;close all;
% OFDM系统参数
carrierFrequency = 2e9;  % 载波频率为2 GHz
numSubcarriers = 512;    % 子载波数量为256
symbolPeriod = 1e-6;    % 符号周期为1 μs

% 创建OFDM调制器
ofdmModulator = comm.OFDMModulator('FFTLength', numSubcarriers, 'CyclicPrefixLength', numSubcarriers/4);

% 创建OFDM解调器
ofdmDemodulator = comm.OFDMDemodulator('FFTLength', numSubcarriers, 'CyclicPrefixLength', numSubcarriers/4);


nsymbol=501;%表示一共有多少个符号，这里定义100000个符号
M=16;%M表示QAM调制的阶数,表示16QAM，16QAM采用格雷映射(所有星座点图均采用格雷映射)
N=64;
B=32;
D=4;
graycode0=[0 1 3 2];
graycode=[0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10];%格雷映射编码规则

graycode1=[0 1 3 2 6 7 5 4 8 9 11 10 14 15 13 12 24 25 27 26 30 31 29 28 16 17 19 18 22 23 21 20 48 49 51 50 54 55 53 52 56 57 59 58 62 63 61 60 40 41 43 42 46 47 45 44 32 33 35 34 38 39 37 36];%格雷映射十进制的表示
graycode2=[0 1 3 2 6 7 5 4 8 9 11 10 14 15 13 12 24 25 27 26 30 31 29 28 16 17 19 18 22 23 21 20];
EsN0=5:20;%信噪比范围
snr1=10.^(EsN0/10);%将db转换为线性值
msg=randi([0,M-1],1,nsymbol);%0到15之间随机产生一个数,数的个数为：1乘nsymbol，得到原始数据
msg1=graycode(msg+1);%对数据进行格雷映射
msgmod=qammod(msg1,M);%调用matlab中的qammod函数，16QAM调制方式的调用(输入0到15的数，M表示QAM调制的阶数)得到调制后符号
msgmod = ofdmModulator(msgmod')';
scatterplot(msgmod);%调用matlab中的scatterplot函数,画星座点图
spow=norm(msgmod).^2/nsymbol;%取a+bj的模.^2得到功率除整个符号得到每个符号的平均功率

%32QAM
bsg=randi([0,B-1],1,nsymbol);
bsg1=graycode1(bsg+1);
bsgmod=qammod(bsg1,B);
bsgmod = ofdmModulator(bsgmod')';%OFDM调制
scatterplot(bsgmod);%调用matlab中的scatterplot函数,画星座点图
spow2=norm(bsgmod).^2/nsymbol;


%64QAM
nsg=randi([0,N-1],1,nsymbol);
nsg1=graycode1(nsg+1);
nsgmod=qammod(nsg1,N);
nsgmod = ofdmModulator(nsgmod')';%%OFDM调制
scatterplot(nsgmod);%调用matlab中的scatterplot函数,画星座点图
spow1=norm(nsgmod).^2/nsymbol;

%QPSK
dsg=randi([0,D-1],1,nsymbol);
dsg1=graycode0(dsg+1);
dsgmod=pskmod(dsg1,D);
dsgmod = ofdmModulator(dsgmod')';%OFDM调制
scatterplot(dsgmod);%调用matlab中的scatterplot函数,画星座点图
spow3=norm(dsgmod).^2/nsymbol;

for i=1:length(EsN0)
    sigma=sqrt(spow/(2*snr1(i)));%16QAM根据符号功率求出噪声的功率
    sigma1=sqrt(spow1/(2*snr1(i)));%64QAM根据符号功率求出噪声的功率
    sigma2=sqrt(spow2/(2*snr1(i)));%32QAM根据符号功率求出噪声的功率
    sigma3=sqrt(spow3/(2*snr1(i)));%QPSK根据符号功率求出噪声的功率
    
    rx=msgmod+sigma*(randn(1,length(msgmod))+1i*randn(1,length(msgmod)));%16QAM混入高斯加性白噪声
    rx1=nsgmod+sigma*(randn(1,length(nsgmod))+1i*randn(1,length(nsgmod)));%64QAM混入高斯加性白噪声
    rx2=bsgmod+sigma*(randn(1,length(bsgmod))+1i*randn(1,length(bsgmod)));%32QAM混入高斯加性白噪声
    rx3=dsgmod+sigma*(randn(1,length(dsgmod))+1i*randn(1,length(bsgmod)));%QPSK混入高斯加性白噪声
    
    y=qamdemod(ofdmDemodulator(rx')',M);%16QAM的解调
   y1=qamdemod(ofdmDemodulator(rx1')',N);%64QAM的解调
   y2=qamdemod(ofdmDemodulator(rx2')',B);%32QAM的解调
   y3=pskdemod(ofdmDemodulator(rx3')',D);%QPSK的解调
   
   decmsg=graycode(y+1);%16QAM接收端格雷逆映射，返回译码出来的信息，十进制
   decnsg=graycode1(y1+1);%64QAM接收端格雷逆映射
   decbsg=graycode2(y2+1);%32QAM接收端格雷逆映射
   decdsg=graycode0(y3+1);%QPSK接收端格雷逆映射
   
   [err1,ber(i)]=biterr(msg,decmsg,log2(M));%一个符号四个比特，比较发送端信号msg和解调信号decmsg转换为二进制，ber(i)错误的比特率
   [err2,ser(i)]=symerr(msg,decmsg);%16QAM求实际误码率
   
   [err1,ber64(i)]=biterr(nsg,decnsg,log2(N));
   [err2,ser64(i)]=symerr(nsg,decnsg);%64QAM求实际误码率
   
   [err1,ber32(i)]=biterr(bsg,decbsg,log2(B));
   [err2,ser32(i)]=symerr(bsg,decbsg);%32QAM求实际误码率
   
   [err1,berQPSK(i)]=biterr(dsg,decdsg,log2(D));
   [err2,serQPSK(i)]=symerr(dsg,decdsg);%32QAM求实际误码率
   
end
%16QAM
scatterplot(rx);%调用matlab中的scatterplot函数,画rx星座点图
p = 2*(1-1/sqrt(M))*qfunc(sqrt(3*snr1/(M-1)));
ser_theory=1-(1-p).^2;%16QAM理论误码率
ber_theory=1/log2(M)*ser_theory;

%64QAM
scatterplot(rx1);
p1=2*(1-1/sqrt(N))*qfunc(sqrt(3*snr1/(N-1)));
ser1_theory=1-(1-p1).^2;%64QAM理论误码率
ber1_theory=1/log2(N)*ser1_theory;%得到误比特率

%32QAM
scatterplot(rx2);
p2=2*(1-1/sqrt(B))*qfunc(sqrt(3*snr1/(B-1)));
ser2_theory=1-(1-p2).^2;%32QAM理论误码率
ber2_theory=1/log2(B)*ser2_theory;%得到误比特率

%QPSK
scatterplot(rx3);
p3=2*(1-1/sqrt(D))*qfunc(sqrt(3*snr1/(D-1)));
ser3_theory=1-(1-p3).^2;%32QAM理论误码率
ber3_theory=1/log2(D)*ser3_theory;%得到误比特率

% %绘图
% figure()
% semilogy(EsN0,ber,"o", EsN0, ser, "*",EsN0, ser_theory, "-", EsN0, ber_theory, "-");
% title("16-QAM载波调制信号在AWGN信道下的误比特率性能")
% xlabel("EsN0");
% ylabel("误比特率和误符号率");
% legend("误比特率", "误符号率","理论误符号率","理论误比特率");

%绘图
figure()
semilogy(EsN0,ber,"o", EsN0, ber32, "*", EsN0, ber64, "x", EsN0,berQPSK,"+");
title("四种调制方式的对比")
xlabel("EsN0");
ylabel("误比特率和误符号率");
legend("16QAM仿真误码率", "32QAM仿真误码率","64QAM仿真误码率","QPSK仿真误码率");

% %阶数不同,16和64QAM调制信号在AWGN信道的性能比较
% figure()
% semilogy(EsN0,ser_theory,'o',EsN0,ser1_theory,'o',EsN0,ser2_theory,'o');%ber ser比特仿真值 ser1理论误码率 ber1理论误比特率
% title('16和64QAM调制信号在AWGN信道的性能比较');grid;
% xlabel('Es/N0(dB)');%性躁比
% ylabel('误码率');%误码率
% legend('16QAM误码率','64QAM误码率','32QAM误码率');
% 
% figure()
% semilogy(EsN0,ser_theory,'o',EsN0,ser1_theory,'o',EsN0,ser2_theory,'o');%ber ser比特仿真值 ser1理论误码率 ber1理论误比特率
% title('16、32和64QAM调制信号在AWGN信道的性能比较');grid;
% xlabel('Es/N0(dB)');%性躁比
% ylabel('误码率');%误码率
% legend('16QAM理论误码率','64QAM理论误码率','32QAM理论误码率');
