% Spencer Chan
% MiniMATLAB 2

clc; clear all; close all;

%% Declaring Variables

M = 4;
k=log2(M);
L = 1;
ber = zeros(1,10);
fs = 1e5;
numsymbols = 10000;
EbNo = 1:10;
SNR = EbNo - 10*log10(k);
nweights = 2;

% Channel
% ch1 = rayleighchan(1/fs,0);
ch1 = rayleighchan(1/fs,130);
% ch1.PathDelays = [0 1e-6];
ch1.ResetBeforeFiltering = 1;
% ch1.NormalizePathGains = 0;

% eqobj = lineareq(nweights,rls(.99));
% eqobj.SigConst = ([1+i -1+i -1-i 1-i]);
% eqobj.RefTap=1;

% Data
data = randi([0 3], numsymbols, 1); 
modData = qammod(data,M,0,'gray');
FiltData = filter(ch1,modData);

%% Theoretical

% for L=1:10
%     tber = berfading(EbNo,'qam',M,L);
%     semilogy(EbNo,tber)
%     hold on
% end

bers = berfading(EbNo,'qam',M,1);
semilogy(EbNo,bers)
% hold on

%% Channel

for i=1:10   
    Noised(:,i) = awgn(FiltData,SNR(i),'measured');
%     EqData(:,i) = equalize(eqobj,Noised(:,i));
    Demod(:,i) = qamdemod(Noised(:,i), M);
    ber(i) = sum(sum(data~=Demod(:,i)))/(numsymbols*2);
end
b = [data Demod];
figure
semilogy(EbNo,ber)
ber
disp('STUPID MATLAB')