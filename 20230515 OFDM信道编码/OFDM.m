M = 16; % Modulation order for 16QAM
nfft  = 64;
cplen = [4 8 10 7 2 2 4 11 16 3];
nSym  = 10;
nullIdx  = [1:6 33 64-4:64]';
numDataCarrs = nfft-length(nullIdx);
inSig = randi([0 M-1],numDataCarrs,nSym);
qamSym = qammod(inSig,M,'UnitAveragePower',true);
outSig = ofdmmod(qamSym,nfft,cplen,nullIdx);
scatterplot(outSig)


M = 32; % Modulation order for 32QAM
nfft  = 64;
cplen = [4 8 10 7 2 2 4 11 16 3];
nSym  = 10;
nullIdx  = [1:6 33 64-4:64]';
numDataCarrs = nfft-length(nullIdx);
inSig = randi([0 M-1],numDataCarrs,nSym);
qamSym = qammod(inSig,M,'UnitAveragePower',true);
outSig = ofdmmod(qamSym,nfft,cplen,nullIdx);
scatterplot(outSig)

M = 64; % Modulation order for 64QAM
nfft  = 64;
cplen = [4 8 10 7 2 2 4 11 16 3];
nSym  = 10;
nullIdx  = [1:6 33 64-4:64]';
numDataCarrs = nfft-length(nullIdx);
inSig = randi([0 M-1],numDataCarrs,nSym);
qamSym = qammod(inSig,M,'UnitAveragePower',true);
outSig = ofdmmod(qamSym,nfft,cplen,nullIdx);
scatterplot(outSig)





