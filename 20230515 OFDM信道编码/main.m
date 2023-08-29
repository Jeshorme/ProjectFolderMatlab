clear all
% OFDM系统参数
carrierFrequency = 2e9;  % 载波频率为2 GHz
numSubcarriers = 256;    % 子载波数量为256
symbolPeriod = 1e-6;    % 符号周期为1 μs

% 创建OFDM调制器
ofdmModulator = comm.OFDMModulator('FFTLength', numSubcarriers, 'CyclicPrefixLength', numSubcarriers/4);

% 创建OFDM解调器
ofdmDemodulator = comm.OFDMDemodulator('FFTLength', numSubcarriers, 'CyclicPrefixLength', numSubcarriers/4);

% 创建误码率计算器
errorRateCalculator = comm.ErrorRate;

% 选择不同的调制方式进行仿真
modulationTypes = {'16QAM', '32QAM', '64QAM', 'QPSK'};
numModulations = length(modulationTypes);

for i = 1:numModulations
    % 设置调制方式
    modulationType = modulationTypes{i};
    switch modulationType
        case '16QAM'
            modulator = comm.RectangularQAMModulator('ModulationOrder', 16);
            demodulator = comm.RectangularQAMDemodulator('ModulationOrder', 16);
        case '32QAM'
            modulator = comm.RectangularQAMModulator('ModulationOrder', 32);
            demodulator = comm.RectangularQAMDemodulator('ModulationOrder', 32);
        case '64QAM'
            modulator = comm.RectangularQAMModulator('ModulationOrder', 64);
            demodulator = comm.RectangularQAMDemodulator('ModulationOrder', 64);
        case 'QPSK'
            modulator = comm.QPSKModulator;
            demodulator = comm.QPSKDemodulator;
        otherwise
            error('不支持的调制方式');
    end

    % 生成OFDM信号
    data = randi([0, 1], 245, 1);  % 随机生成数据
    modulatedData = ofdmModulator(modulator(data));  % OFDM调制

    % 加入信道噪声
    ebn0 =[1:15];
    snr = ebn0+10*log10(2);
    for n = 1:length(snr)
        snr_n=snr(n);
        noisyData = awgn(modulatedData, snr_n);

        % 解调OFDM信号
        demodulatedData = demodulator(ofdmDemodulator(noisyData));  % OFDM解调

        % 计算误码率
        errorStats = errorRateCalculator(data, demodulatedData);
        bitErrorRate(n) = errorStats(1);
    end
    bitErrorRate_All = zeros(numModulations,length(snr));
    bitErrorRate_All(i,:)=bitErrorRate;
    % 绘制误码率性能图
    figure;
    semilogy(ebn0, bitErrorRate, 'o-');
    T1=strcat(modulationType,'误码率性能图');
    title(T1);
    xlabel('Eb/No(dB)');
    ylabel('误比特率');
    grid on;
    
    % 绘制星状图
    figure;
    scatter(real(modulatedData), imag(modulatedData));
    xlabel('实部');
    ylabel('虚部');
    T=strcat(modulationType,'星状图');
    title(T);
end
% 显示结果
disp('不同调制方式下的误码率：');
disp(bitErrorRate);
