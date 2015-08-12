clc; clear all; close all;

%%
fs = 5e6;
npackets = 1;

% Modulators
hmod = comm.BPSKModulator;
hdemod = comm.BPSKDemodulator;
chan = rayleighchan;
chan.StorePathGains = 1;

% Rates
symrate = 1e6;
voice_size = 240;
vrate = 1/3;
encsize = voice_size/vrate;

%% SNRs

% Find values of SNR to iterate over:
EbNo = 1:5:21;
SNR = EbNo - 10*log10((fs)/(symrate*vrate));

%% Time/Freq vectors

t_v = (0:1/fs:(encsize-1)/fs)';

[voice, voice_dec] = deal(zeros(voice_size,npackets));

% Generate 32 random hop frequencies:
freq = ism_freq(npackets);
freq = 70;

% Generate all carriers that will be used:
carrier = exp(1i*2*pi.*repmat(freq,encsize,1).*repmat(t_v,1,length(freq)));

%% Simulate voice transmission
for i=1:length(SNR)                                                         % Perform transmission at several SNRs
    for p = 1:npackets                                                      % Parallel iterate over many packets
        voice(:,p)      = randi([0 1],voice_size,1);                        % Generate random bits for message
        voice_enc(:,p)  = [repcode(voice(:,p),1/vrate)];                    % Encode with 1/3 repetition code and account for viterbi delay
        voice_out(:,p)  = step(hmod,voice_enc(:,p));                        % Modulate with GMSK
        voice_out(:,p)  = voice_out(:,p).*carrier(:,p);                     % Modulate with carrier
        voice_out(:,p)  = filter(chan,voice_out(:,p));                      % Rayleigh Channel
        voice_out1(:,p)  = awgn(voice_out(:,p),SNR(i),'measured');          % Simulate AWGN channel
        voice_out(:,p)  = voice_out1(:,p)./carrier(:,p);                    % Demodulate carrier
        voice_dmod(:,p) = step(hdemod,voice_out(:,p)./chan.PathGains);      % Demodulate GMSK
        voice_tb        = voice_dmod(:,p);                                  % Slice variable
        voice_dec(:,p)  = repdecode(voice_tb,1/vrate);                      % Decode repetition code accounting for viterbi
    end
    voice_ber(i) = sum(sum(voice~=voice_dec))/(npackets*voice_size);        % Calculate bit error rate
end
voice_ber
%% FFT

y = fft(voice_out1(:,1));
z = abs(y);
plot(78/720:78/720:78,fftshift(z))
mz = mean(z)

% PSD spectrum sensing
pwelch(z)