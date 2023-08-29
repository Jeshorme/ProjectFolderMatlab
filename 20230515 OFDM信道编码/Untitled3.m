      clc
clear all
close all
m=4;
M =2^m; %M进制
SNRin=-10:1:20;
linSNRin=10.^(SNRin/10);
x = randi(M,5000,1)-1;%信源
y=modulate(modem.qammod(M),x);   %调制  modem.qammod(M)确定调制方式
rt=zeros(1,31);
e1=mean(abs(y).^2);
e2=e1/m;
N0=e2./linSNRin;
for i=1:length(SNRin)
    z=zeros(1,100);
    z1=0;
    for n=1:100       %蒙特卡罗仿真
    noisy=sqrt(N0(i)/2)*(randn(1,5000)+j*randn(1,5000));
    ynoisy=y+noisy';
    z2=demodulate(modem.qamdemod(M),ynoisy);
    [num,z(n)]= biterr(x,z2);
    z1=z(n)+z1;
    end
    rt(i)=z1/100;
end
semilogy(SNRin,rt,'linewidth',2);%也可以用plot(semilogy画图时纵坐标取对数了)
axis([-10 13 0.000001 1]);
title('误比特率曲线');
%xlabel('信噪比');
ylabel('误比特率');
grid on;
hold on;
m=6;
M =2^m; %M进制
SNRin=-10:1:20;
linSNRin=10.^(SNRin/10);
x = randi(M,5000,1)-1;%信源
y=modulate(modem.qammod(M),x);   %调制  modem.qammod(M)确定调制方式
rt=zeros(1,31);
e1=mean(abs(y).^2);
e2=e1/m;
N0=e2./linSNRin;
for i=1:length(SNRin)
    z=zeros(1,100);
    z1=0;
    for n=1:100       %蒙特卡罗仿真
    noisy=sqrt(N0(i)/2)*(randn(1,5000)+j*randn(1,5000));
    ynoisy=y+noisy';
    %ynoisy = awgn(y,SNRin(i)); 
    z2=demodulate(modem.qamdemod(M),ynoisy);
    [num,z(n)]= biterr(x,z2);
    z1=z(n)+z1;
    end
    rt(i)=z1/100;
end
semilogy(SNRin,rt,'r *-','linewidth',2);%也可以用plot(semilogy画图时纵坐标取对数了)
axis([-10 13 0.000001 1]);
title('误比特率曲线');
%xlabel('信噪比');
ylabel('误比特率');
grid on;
m=8;
M =2^m; %M进制
SNRin=-10:1:20;
linSNRin=10.^(SNRin/10);
x = randi(M,5000,1)-1;%信源
y=modulate(modem.qammod(M),x);   %调制  modem.qammod(M)确定调制方式
rt=zeros(1,31);
e1=mean(abs(y).^2);
e2=e1/m;
N0=e2./linSNRin;
for i=1:length(SNRin)
    z=zeros(1,100);
    z1=0;
    for n=1:100       %蒙特卡罗仿真
    noisy=sqrt(N0(i)/2)*(randn(1,5000)+j*randn(1,5000));
    ynoisy=y+noisy';
    %ynoisy = awgn(y,SNRin(i)); 
    z2=demodulate(modem.qamdemod(M),ynoisy);
    [num,z(n)]= biterr(x,z2);
    z1=z(n)+z1;
    end
    rt(i)=z1/100;
end
semilogy(SNRin,rt,'g +-','linewidth',2);%也可以用plot(semilogy画图时纵坐标取对数了)
axis([-10 13 0.000001 1]);
title('误比特率曲线');
xlabel('Eb/N0(dB)');
ylabel('误比特率');
grid on;
legend('16QAM','64QAM','256QAM',3);