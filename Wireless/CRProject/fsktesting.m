% M = 8; freqsep = 8; nsamp =16;Fs = 64;
% %x = randi([0 M-1],1000,1); % Random signal
% x = [1*ones(1,250) 2*ones(1,250), 3*ones(1,250)];
% y = fskmod(x,M,freqsep,nsamp,Fs); % Modulate.
% 
% msg = [0*ones(1,nsamp*250) 1*ones(1,nsamp*250),2*ones(1,nsamp*250)];
% % msgMod = qammod(msg,4);
% 
% % tx = msgMod.*y;
% 
% % rx = tx./y;
% 
% x2 = [6*ones(1,250) 5*ones(1,250), 6*ones(1,250)];
% y2 = fskmod(x2,M,freqsep,nsamp,Fs); % Modulate.
% 
% y3 = y+y2;
% 
% spectrogram(y3,64,[],[],Fs,'yaxis')

%%
M = 16;
fsep = 8;
nsamp = 16;
Fs = 120;
size = 100;

msg = randi([0 3],1,15);
msglength = length(msg);
msgext = [];

for i = 1:msglength
    msgext = [msgext msg(i)*ones(1,size*nsamp)];
end
msgmod = qammod(msgext,4);

tone1 = ones(msglength,size);
tone2 = ones(msglength,size);

for i = 1:msglength
    tone1(i,:) = randi([0 Fs/fsep],1,1)*ones(1,size);
    tone2(i,:) = randi([0 Fs/fsep],1,1)*ones(1,size);
end

tone1 = reshape(tone1',1,msglength*size);
tone2 = reshape(tone2',1,msglength*size);

carrier = fskmod(tone1,M,fsep,nsamp,Fs);
carrier2 = fskmod(tone2,M,fsep,nsamp,Fs);

tx = msgmod.*carrier;
% tx = msgmod.*carrier+carrier2;

tx = awgn(tx,25,'measured');

rx = tx./carrier;
rxmsg = qamdemod(rx,4);
rxmsg = downsample(rxmsg,nsamp*size);

spectrogram(tx,128,[],[],Fs,'yaxis')

%%
M = 16;
fsep = 8;
nsamp = 16;
Fs = 120;
size = 100;

msg = randi([0 3],1,15);

[rxmsg, S] = CRengine(M,fsep,nsamp,Fs,size,msg,1,1,23,3);


