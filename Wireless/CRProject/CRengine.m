function [rxmsg, S] = CRengine(M,fsep,nsamp,Fs,ups,msg,noisetoggle)
%UNTITLED2 Summary of this function goes here
%[rx , S] = CRengine(16,8,16,120,100,randi([0 1],25,1),1);
msglength = length(msg);
msgext = [];

for i = 1:msglength
    msgext = [msgext msg(i).*ones(1,ups*nsamp)];
end
msgmod = qammod(msgext,4);

tone1 = ones(msglength,ups);
tone2 = ones(msglength,ups);

for i = 1:msglength
    tone1(i,:) = randi([0 Fs/fsep],1,1)*ones(1,ups);
    tone2(i,:) = randi([0 Fs/fsep],1,1)*ones(1,ups);
end

tone1 = reshape(tone1',1,msglength*ups);
tone2 = reshape(tone2',1,msglength*ups);

carrier = fskmod(tone1,M,fsep,nsamp,Fs);
carrier2 = fskmod(tone2,M,fsep,nsamp,Fs);

sizet1 = size(msgmod)
sizec1 = size(carrier)

tx = msgmod.*carrier;
% tx = msgmod.*carrier+carrier2;
if noisetoggle > 0
    tx = awgn(tx,25,'measured');
else
    tx = tx;
end

rx = tx./carrier;
rxmsg = qamdemod(rx,4);
rxmsg = downsample(rxmsg,nsamp*ups);

spectrogram(tx,128,[],[],Fs,'yaxis')
S = spectrogram(tx,128,[],[],Fs,'yaxis');

end

