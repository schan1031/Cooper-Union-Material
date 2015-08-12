clc; clear all; close all;

Fs = 120;

% if exist('fdbk','var')
%     fdbk = fdbk;
% else
%     fdbk = 0;
% end


% Transmitters

% [tx1, carrier1] = tx1();
% [tx2, carrier2] = tx2();
% [tx, carrier3, a] = tx3(fdbk);
[tx, carrier3, a] = tx3();
[tx2, carrier4, a] = tx4();

% Power

% p = sum(abs(tx1).^2)/length(tx1);
% power = Fs*sum(abs(tx1).^2)/length(tx1);


sumout = tx + tx2;
sumout = awgn(sumout, 25, 'measured');

spectrogram(sumout,64,[],[],Fs,'yaxis')

[rcv3, fbk3] = rx3(sumout,carrier3);
[rcv4, fbk4] = rx4(sumout,carrier4);

equalsum = sum(rcv3==a);

% if sum(rcv3==a) < 2048
%     fdbk = 1;
% else
%     fdbk = 0;
% end

% Receivers

% [rcv1, fbk1] = rx1(sum,carrier1)
% [rcv2, fbk2] = rx2(sum,carrier2)

