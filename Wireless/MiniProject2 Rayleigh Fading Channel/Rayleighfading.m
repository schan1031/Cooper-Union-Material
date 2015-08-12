%Spencer Chan
%ECE408 Mini MATLAB Rayleigh Fading

clc; clear all; close all;

%% Declaring Variables
M = 4;
k=log2(M);
L = 1;
ber = zeros(1,10);
fs = 1e6;
numsymbols = 10000;
EbNo = 1:10;
SNR = EbNo + 10*log10(k);
tau = [0 1e-4];
pdb = [0 -5];
nweights = 8;
trainlength = numsymbols/100;

% Channels
ch1 = rayleighchan(1/fs,130);
ch1.StorePathGains = 1;
ch2 = rayleighchan(1/fs,0,tau,pdb);
ch2.StorePathGains = 1;

% Equalizer
eqobj = lineareq(nweights,lms(.01));
eqobj.SigConst = (qammod([0 1 2 3],4));
eqobj.RefTap=1;

% Generate Data
data = randi([0 3],numsymbols,1);
x = qammod(data,M);
fil = filter(ch1,x);

%% Hypothetical

bers = berfading(EbNo,'qam',M,1);

%% Frequency Flat Rayleigh Channel

for i=1:length(SNR)
    Nsy = awgn(fil,SNR(i),'measured');
    Recdm = qamdemod(Nsy./ch1.PathGains,M);
    ber(i) = biterr(data,Recdm)/(2*numsymbols);
end
% z = step(hDemod,y);
a = data~=Recdm;
b = [data Recdm];
sum(a)
ber
semilogy(EbNo,ber,'-xr',EbNo,bers)


hold on
%% Quasi-Static Frequency Selective Channel

z = waitbar(0);
for i = 1:length(SNR)
    for ii = 1:10
        xx = qammod(data,M);
        modData = filter(ch2,x);
        Nsy = awgn(modData,SNR(i),'measured');
        
        % No Equalizer
        Recdm2 = qamdemod(Nsy,M);
        ber3(ii) = biterr(data,Recdm2)/(2*numsymbols);
    
        % Equalized
        EqData2 = equalize(eqobj,Nsy,x(1:trainlength));
        waitbar(i/length(SNR))
        Recdm = qamdemod(EqData2,M);
        ber2(ii) = biterr(data,Recdm)/(2*numsymbols);
    end
    ber2(i) = sum(ber2)/length(ber2);
    ber3(i) = sum(ber3)/length(ber3);
end
ber2
ber3
close(z)
semilogy(EbNo,ber2,'-xg',EbNo,ber3,'-xy')

leg = legend('Calculated BER','Theoretical BER','Equalized Multipath','Nonequalized');










































