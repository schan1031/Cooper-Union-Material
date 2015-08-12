function [tx,carrier] = tx1()

M = 16;
fsep = 8;
nsamp = 16;
Fs = 120;
ups = 10;

% [rxmsg, fdbk] = 

% freqtone = ;

% msg = randi([0 3],1,15)
msg = dlmread('data.txt')';
msglength = length(msg);
msgext = [];

for i = 1:msglength
    msgext = [msgext msg(i)*ones(1,ups*nsamp)];
end
% msgmod = qammod(msgext,4);
msgmod = msgext;

tone1 = ones(msglength,ups);

for i = 1:msglength
    tone1(i,:) = 4*ones(1,ups);
%     tone1(i,:) = randi([0 Fs/fsep],1,1)*ones(1,size);
end

tone1 = reshape(tone1',1,msglength*ups);

carrier = fskmod(tone1,M,fsep,nsamp,Fs);

tx = msgmod.*carrier;
% tx = msgmod.*carrier+carrier2;


end