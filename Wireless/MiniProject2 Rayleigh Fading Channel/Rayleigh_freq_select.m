% Quasi-static Frequency Selective Channel

clc; clear all; close all;

%% Declaring Variables

M = 4;
k=log2(M);
L = 1;
ber = zeros(1,10);
fs = 1e5;
numsymbols = 100;
EbNo = 0:2:10;
SNR = EbNo - 10*log10(k);
nweights = 2;
tau = [0 1e-5 2e-5];
pdb = [0 -1 -1.2];

% Channel
ch1 = rayleighchan(1/fs,130,tau,pdb);
% ch1.PathDelays = [0 1e-6];
ch1.ResetBeforeFiltering = 1;
ch1.StorePathGains = true;

% Data
data = randi([0 3], numsymbols, 1); 
modData = qammod(data, M); 

% Equalizer
eqobj = lineareq(nweights,lms(.001));
eqobj.SigConst = ([1+i -1+i -1-i 1-i]);
eqobj.RefTap=1;

% Quasi-Static Channel

FilData = filter(ch1,modData);
EqData = equalize(eqobj,FilData);
% plot(EqData)

%%

h = waitbar(0);
for i=1:length(SNR)
    Nsy = awgn(FilData,SNR(i));
    waitbar(i/length(SNR));
    Recdm = qamdemod(Nsy./ch1.PathGains(:,1),M);
    ber(i) = biterr(data,Recdm)/(2*numsymbols);
%     ber(i) = sum(sum(data~=Recdm))/(numsymbols*2);
end
close(h);
b = [data Recdm];
a = sum(data~=Recdm);
ber = ber(1:6)
semilogy(EbNo,ber)