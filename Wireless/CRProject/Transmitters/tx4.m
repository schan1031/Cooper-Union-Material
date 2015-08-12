function [tx,carrier, a] = tx4()

% clc; clear all; close all;

% dbstop if error

M = 16;
fsep = 8e4;
nsamp = 16;
Fs = 120e4;
tonecoeff = randi([0 Fs/fsep],1,1);

% if exist('tonecoeff')
%     if fdbk > 0;
%         tonecoeff = randi([0 Fs/fsep],1,1)
%     else
%         tonecoeff = tonecoeff
%     end
% else
%     tonecoeff = randi([0 Fs/fsep],1,1)
% end


msg = randi([0 3], 1, 1024);
msg = qammod(msg,4);
% msg = 1:1024;
msglength = length(msg);
b = msglength/nsamp;
c = 2048/nsamp;

msgdiv = reshape(msg,nsamp,b)';

msgde = [];

for i = 1:nsamp
    msgde = [msgde msgdiv(:,i)*ones(1,c)];
end

a = msgde(1,:);

tone = ones(1,c);

carrier = fskmod(tonecoeff*tone,M,fsep,nsamp,Fs);


tx = msgde(1,:).*carrier;
% tx = msgde.*carrier;

end