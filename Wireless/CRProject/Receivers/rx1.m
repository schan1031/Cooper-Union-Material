function [ rxmsg , fdbk ] = rx1(sum,carrier)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

M = 16;
fsep = 8;
nsamp = 16;
Fs = 120;
ups = 100;


rx = sum./carrier;
rxmsg = qamdemod(rx,4);
rxmsg = downsample(rxmsg,nsamp*ups);

fdbk = 1;

end

