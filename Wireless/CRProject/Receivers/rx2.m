function [ rxmsg , fdbk ] = rx2( sum, carrier )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

M = 16;
fsep = 8;
nsamp = 16;
Fs = 120;
ups = 100;


rx = sum./carrier;
rxmsg = qamdemod(rx,4);
rxmsg = downsample(rxmsg,nsamp*ups);

fdbk = 0;

end

