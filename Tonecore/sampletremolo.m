% Spencer Chan
% ECE314 ToneCore Effect MATLAB Preview
% Stereo Tremolo Effect

clc; clear all; close all;

[x,Fs] = audioread('guitar_riff_acoustic.wav');
y = tremolo(Fs,x,'sin',5,100,0.8);
soundsc(y,Fs)