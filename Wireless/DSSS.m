clc; clear all; close all;

SNR = -10:9;
Hmod = comm.BPSKModulator
Hdemod = comm.BPSKDemodulator

m = randi([0 1],100000,1);
m = step(Hmod,m);
chip = randi([0 1],50,1)*2-1;
chip = repmat(chip,1,2000);
chip = reshape(chip,100000,1);
y = m.*chip;
for i=1:20
mnoise = awgn(m,SNR(i),'measured');
ynoise = awgn(m,SNR(i),'measured');

mrec = step(Hdemod,mnoise);
yrec = step(Hdemod,ynoise).*chip;

err(i) = sum(mrec==m);
err2(i) = sum(yrec==m);
end
ber1 = err/length(m);
ber2 = err2/length(m);
hold on
semilogy(SNR,ber1)
semilogy(SNR,ber2,'r')