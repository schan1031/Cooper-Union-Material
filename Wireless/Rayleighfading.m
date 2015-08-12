%Spencer Chan
%ECE408 Mini MATLAB Rayleigh Fading

clc; clear all; close all;

%% Declaring Variables
M = 4;                                  % # of Samples
k=log2(M);
L = 1;
fs = 1e6;                               % Sampling Rate
numsymbols = 10000;                     % # of Symbols
EbNo = 0:1:10;
SNR = EbNo + 10*log10(k);
tau = [0 1e-5];
pdb = [0 -10];
nweights = 8;
trainlength = numsymbols/50;            % Training Sequence

% Establish First Channel

ch1 = rayleighchan(1/fs,130);
ch1.StorePathGains = 1;

% Equalizer

eqobj = lineareq(nweights,lms(.01));    % Linear Equalizer
eqobj.SigConst = (qammod([0 1 2 3],4));
eqobj.RefTap=1;

% Generate Data

data = randi([0 3],numsymbols,1);       % Generate Data
x = qammod(data,M);                     % 4-QAM Modulation
fil = filter(ch1,x);                    % Apply Rayleigh Channel

%% Hypothetical

bers = berfading(EbNo,'qam',M,1);       % Hypothetical Fading BER for QAM

%% Frequency Flat Rayleigh Channel

for i=1:length(SNR)
    Nsy = awgn(fil,SNR(i),'measured');              % Apply Noise
    Recdm = qamdemod(Nsy./ch1.PathGains,M);         % Demodulate
    ber(i) = biterr(data,Recdm)/(2*numsymbols);     % Calculate BER
end
%% Quasi-Static Frequency Selective Channel

z = waitbar(0);
for i = 1:length(SNR)
    for ii = 1:1
        
        % Establish Second Channel
        
        ch2 = rayleighchan(1/fs,0,tau,pdb);
        
        xx = qammod(data,M);
        modData = filter(ch2,xx);
        Nsy = awgn(modData,SNR(i),'measured');
        
        % No Equalizer
        
        Recdm2 = qamdemod(Nsy,M);
        ber3(ii) = biterr(data,Recdm2)/(2*numsymbols);
    
        % Equalized
        
        EqData2 = equalize(eqobj,Nsy,x(1:trainlength));
        waitbar(i/length(SNR))
        Recdm = qamdemod(EqData2(trainlength+1:end),M);
        ber2(ii) = biterr(data(trainlength+1:end),Recdm)/(2*(numsymbols-trainlength));
    end
    ber2(i) = sum(ber2)/length(ber2);
    ber3(i) = sum(ber3)/length(ber3);
end

close(z)
semilogy(EbNo,ber,'-xr',EbNo,bers,EbNo,ber2,'-xg',EbNo,ber3,'-xy')          % Plot BERs
leg = legend('Calculated BER','Theoretical BER','Equalized Multipath','Nonequalized');

%% Frequency Response of MultiPath Channel

figure
title('Frequency Response of Quasi-Static Frequency Selective Rayleigh Channel')
channel = ch2.ChannelFilter.TapGains.Values;
freqz(channel)








































