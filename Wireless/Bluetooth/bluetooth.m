%% IEEE 802.15.1 - Bluetooth
% Caleb Zulawski and Spencer Chan
%%
close all; clear all; clc;

%% Declare Variables

%%
% Set up simulation variables:
fs = 5e6;           % Baseband sample rate
npackets_v = 1000;  % Number of voice packets to send
npackets_d = 100;   % Number of data packets to send
L = 8;              % Length of the gaussian pulse shaping filter
Tb = 16;            % Length of the GMSK demodulation viterbi traceback buffer

%%
% Create GMSK modulator and demodulator objects:
hMod = comm.GMSKModulator('BitInput',true,'BandwidthTimeProduct',0.5,'SamplesPerSymbol',L);
hDemod = comm.GMSKDemodulator('BitOutput',true,'BandwidthTimeProduct',0.5,'SamplesPerSymbol',L,'TracebackDepth',Tb);

%%
% Set up Bluetooth variables:
symbol_rate = 1e6;                      % Bluetooth transmits at 1 Msymbol/s

voice_rate = 1/3;                       % Voice is transmitted with a 1/3 rate repetition code
voice_size = 240;                       % Voice packets are 240 bits long
enc_size_v = voice_size/voice_rate+Tb;  % Calculate total encoded voice bitstream size for one packet

data_rate = 2/3;                        % Data is transmitted with (15, 10) shortened hamming code
data_size = 240;                        % Data packets can be any length (indicated in the header)
enc_size_d = data_size/data_rate+Tb;    % Calculate total encoded data bitstream size for one packet

genpoly = [1 1 0 1 0 1];                % Generator polynomial for the (15, 10) code

%%
% Find values of SNR to iterate over:
EbNo = 1:4:10;
SNR = EbNo - 10*log10((fs*L)/(symbol_rate*L*voice_rate));

%%
% Create time vectors for voice and data passband signals:
t_v = (0:1/fs:(L*enc_size_v-1)/fs)';
t_d = (0:1/fs:(L*enc_size_d-1)/fs)';

%%
% Preallocate simulation variables for parallel looping:
[voice, voice_dec] = deal(zeros(voice_size,npackets_v));        % Message and decoded message arrays
[voice_enc, voice_dmod] = deal(zeros(enc_size_v,npackets_v));   % Encoded and demodulated message arrays
voice_out = zeros(enc_size_v*L,npackets_v);                     % Working array
voice_ber = zeros(1,length(SNR));                               % Bit error rates
voice_tb = zeros(enc_size_v,1);                                 % Sliced array for correcting traceback delay

[data, data_dec] = deal(zeros(data_size,npackets_d));           % Message and decoded message arrays
[data_enc, data_dmod] = deal(zeros(enc_size_d,npackets_d));     % Encoded and demodulated message arrays
data_out = zeros(enc_size_d*L,npackets_d);                      % Working array
data_ber = zeros(1,length(SNR));                                % Bit error rates
data_tb = zeros(enc_size_d,1);                                  % Sliced array for correcting traceback delay

%%
% Generate 32 random hop frequencies:
freq_v = ism_freq(npackets_v);  
freq_d = ism_freq(npackets_d);

%%
% Generate all carriers that will be used:
carrier_v = exp(1i*2*pi.*repmat(freq_v,enc_size_v*L,1).*repmat(t_v,1,length(freq_v)));
carrier_d = exp(1i*2*pi.*repmat(freq_d,enc_size_d*L,1).*repmat(t_d,1,length(freq_d)));

%% Simulate voice transmission
for i=1:length(SNR)                                                         % Perform transmission at several SNRs
    parfor p = 1:npackets_v                                                 % Parallel iterate over many packets
        voice(:,p)      = randi([0 1],voice_size,1);                        % Generate random bits for message
        voice_enc(:,p)  = [repcode(voice(:,p),1/voice_rate); zeros(Tb,1)];  % Encode with 1/3 repetition code and account for viterbi delay
        voice_out(:,p)  = step(hMod,voice_enc(:,p));                        % Modulate with GMSK
        voice_out(:,p)  = voice_out(:,p).*carrier_v(:,p);                   % Modulate with carrier
        voice_out1(:,p)  = awgn(voice_out(:,p),SNR(i),'measured');           % Simulate AWGN channel
        voice_out(:,p)  = voice_out1(:,p)./carrier_v(:,p);                   % Demodulate carrier
        voice_dmod(:,p) = step(hDemod,voice_out(:,p));                      % Demodulate GMSK
        voice_tb        = voice_dmod(:,p);                                  % Slice variable
        voice_dec(:,p)  = repdecode(voice_tb(Tb+1:end),1/voice_rate);       % Decode repetition code accounting for viterbi
    end
    voice_ber(i) = sum(sum(voice~=voice_dec))/(npackets_v*voice_size);      % Calculate bit error rate
end

%% Simulate data transmission
for i=1:length(SNR)                                                                         % Perform transmission at several SNRs
    parfor p = 1:npackets_d                                                                 % Parallel iterate over many packets
        data(:,p)       = randi([0 1],data_size,1);                                         % Generate random bits for message
        data_enc(:,p)   = [encode(data(:,p),15,10,'cyclic/binary',genpoly); zeros(Tb,1)];   % Encode with (15,10) accounting for viterbi delay
        data_out(:,p)   = step(hMod,data_enc(:,p));                                         % Modulate with GMSK
        data_out(:,p)   = data_out(:,p).*carrier_d(:,p);                                    % Modulate with carrier
        data_out(:,p)   = awgn(data_out(:,p),SNR(i),'measured');                            % Simulate AWGN channel
        data_out(:,p)   = data_out(:,p)./carrier_d(:,p);                                    % Demodulate carrier
        data_dmod(:,p)  = step(hDemod,data_out(:,p));                                       % Demodulate GMSK
        data_tb         = data_dmod(:,p);                                                   % Slice variable
        data_dec(:,p)   = decode(data_tb(Tb+1:end),15,10,'cyclic/binary');                  % Decode (15,10) accounting for viterbi
    end
    data_ber(i) = sum(sum(data~=data_dec))/(npackets_d*data_size);                          % Calculate bit error rate
end
%% Results

ber = berawgn(EbNo,'msk','on');     % Calculate theoretical MSK bit error rate

semilogy(EbNo,voice_ber,'--or',EbNo,data_ber,'--xb',EbNo,ber,'-');
legend('Voice transmission','Data transmission','Theoretical');
title('IEEE 802.15.1 (Bluetooth) Simulated Bit Error Rates');
xlabel('E\_b/N\_0 (dB)');
ylabel('Bit error rate (%)');

%% repcode.m
%   function [ y ] = repcode( x, N )
%       y = repmat(x,1,N);
%       y = reshape(y',length(x)*N,1);
%   end

%% repdecode.m
%   function [ y ] = repdecode( x, N )
%       y = reshape(x,N,length(x)/N);
%       y = sum(y);
%       y = (y>N/2)'; % Perform majority logic decoding
%   end

%% ism_freqs.m
%   function [ k ] = ism_freq( npackets )
%       k = 0:78;
%       njumps = 32;
%       k_exclude = randi([0 78],1,78-njumps+1);
%       for c = k_exclude
%          k = k(k~=c);
%       end
%       k = k(randperm(length(k)));
%       k = k(1:njumps);
%       k = repmat(k,1,ceil(npackets/njumps));    
%   end
