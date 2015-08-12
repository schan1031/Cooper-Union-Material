function [ rxmsg , fdbk ] = rx4( sum, carrier )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

nsamp = 16;

rx = sum./carrier;
rxmsg = qamdemod(rx,4);
% rxmsg = downsample(rxmsg,nsamp);
rxmsg = rx;

fdbk = 0;
end