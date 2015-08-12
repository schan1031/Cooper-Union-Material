% Homework 2
% Spencer Chan

clc; clear all;
%% Part 1 - Additive Synthesis Model

Amplitude = 1;
Duration = 0.5;
Fs = 44100;
Frequency = 1600;
basetime = 1/Fs:1/Fs:Duration;

% Amplitude Vector
amp = [1 .67 1 1.8 2.67 1.67 1.46 1.3 1.33 1 1.33];

% Duration Vector
dur = Duration * [ 1 .9 .9 .95 .6 .35 .25 .2 .15 .1 .075];

% Frequency Vector
freqs = [.56 .56 .92 .92 1.19 1.7 2 2.74 3 3.76 4.07];

% Envelope Vector

% env = zeros(length(dur),Duration*Fs);
% for ii = 1:length(dur)
%     env(ii,:) = [1/Fs:1/Fs:dur(ii) zeros(1,ceil(Duration*Fs - Fs*dur(ii)))];
% end

env = zeros(length(dur),Duration*Fs);
for ii = 1:length(dur)
    c = Duration*Fs-Fs*dur(ii);
    env(ii,:) = [ones(1,ceil(Fs*dur(ii))) zeros(1,floor(Duration*Fs - Fs*dur(ii)))];
end

% First Stage Out
for ii = 1:length(amp)
    env(ii,:) = amp(ii)*env(ii,:);
end

% Waves
soundout = zeros(length(dur),Duration*Fs);
for ii = 1:length(freqs)
    soundout(ii,:) = env(ii,:).*sin(2*pi*Frequency*freqs(ii).*basetime);
end

soundout = sum(soundout,1);
soundsc(soundout,Fs)
subplot(3,1,1)
plot(soundout)
%% Problem 2 Subtractive Synthesis

Fs = 44100;
Time = 4;
basetime = 1/Fs:1/Fs:Time;
tone = 200;
soundout = sawtooth(2*pi*tone*basetime,1);
soundout2 = [];
len = length(soundout);
r = 0.6;
x = tone;
for ii = 1:x
    size = Fs/x;
    theta = (-x+ii)/x*pi;
    a = [1 -2*r*cos(theta) r^2];
    soundout2 = [soundout2 filter(1,a,soundout(round(1:len/x)))];
%     soundout2
end

soundsc(soundout2,Fs)

%% Problem 3 Frequency Modulation

% Horn - fc 1000, tone 200; fdev 700 
% Fog Horn - fc 700, tone 100, fdev 700

Duration = 1;
Fs = 44100;
basetime = 1/Fs:1/Fs:Duration;
tone = 400;
fc = tone;
fdev = 500;

A = linspace(0,.8,Duration*Fs*.08);
D = linspace(.8,.75,Duration*Fs*.25);
S = linspace(.75,.75,Duration*Fs*.65);
R = linspace(.75,0,Duration*Fs*.02);
ADSR = [A D S R];

sounda = ADSR.*sin(2*pi*tone*basetime);
soundb = fmmod(sounda,fc,Fs,fdev);
soundc = ADSR.*soundb;
soundsc(soundc,Fs)
subplot(3,1,2)
plot(soundc)
%% Problem 4 Wave Shaping

% Figure 5.31

Fs = 44100;
Tone = 50;
Duration = 2;
t1 = 1/Fs:1/Fs:Duration;
t2 = 1/Fs:1/Fs:Duration;
amp1 = linspace(1,0,length(t1)*.2).*ones(1,length(t1)*.2);
amp1 = [amp1 zeros(1,length(t1)*.8)];
amp2 = [linspace(0,1,length(t1)*.1) linspace(1,.5,length(t1)*.1) linspace(.5,.25,length(t1)*.2) linspace(.25,0,length(t1)*.6)];

wave1 = amp2.*sin(2*pi*Tone*.7071*t2);
wave1 = wave1*0.5;
wave2 = amp1.*sin(2*pi*Tone*t1);

tf = filter([.21 .25 -.297 -.354 .42 .5 -.595 -.707 .841 1],[1],length(t1));
wave1 = sum(wave1.*tf);
wavefinal = conv(wave2,wave1);
% wavefinal = wave2.*wave1;

soundsc(wavefinal,Fs)
subplot(3,1,3)
plot(wavefinal)

