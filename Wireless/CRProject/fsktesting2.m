clc; clear all;
M = 16;
fsep = 8;
nsamp = 16;
Fs = 120;
ups = 100;
msg = randi([0 1],1,30);

CREngine2(M,fsep,nsamp,Fs,ups,msg,M,fsep,nsamp,Fs,ups,msg)

% CREngine2(16,8,16,120,100,randi([0 1],1,25),16,8,16,120,100,randi([0 1],1,25));