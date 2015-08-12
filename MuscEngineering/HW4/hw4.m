%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT
%    hw4
%
% NAME: Spencer Chan
%
% This script runs questions 1 through 7 of the HW4 from ECE313:Music and
% Engineering.
%
% This script was adapted from hw1 received in 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear functions
clear variables
dbstop if error

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs=44100;                     % Sampling rate in samples per second
STDOUT=1;                               % Define the standard output stream
STDERR=2;                               % Define the standard error stream

%% Sound Samples
% claims to be guitar
% source: http://www.traditionalmusic.co.uk/scales/musical-scales.htm
[guitarSound, fsg] = audioread('guitar_C_major.wav');

% sax riff - should be good for compressor
% source: http://www.freesound.org/people/simondsouza/sounds/763
[saxSound, fss] = audioread('sax_riff.wav');

% a fairly clean guitar riff
% http://www.freesound.org/people/ERH/sounds/69949/
[cleanGuitarSound, fsag] = audioread('guitar_riff_acoustic.wav');

% Harmony central drums (just use the first half)
[drumSound, fsd] = audioread('drums.wav');
L = size(drumSound,1);
drumSound = drumSound(1:round(L/2), :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Common Values 
% may work for some examples, but not all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
depth=75;
LFO_type='sin';
LFO_rate=0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 1 - Compressor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
threshold = 0.2; 
slope = 0.3;
avg_len = 5000;
[output,gain]=compressor(constants,saxSound,threshold,slope,avg_len);

soundsc(output,constants.fs)
disp('Playing the Compressor Output');
pause(length(output)/constants.fs)
audiowrite('output_compressor.wav',output',fss);

% PLOTS for Question 1d
figure
subplot(3,1,1)
plot(saxSound);
title('Original Input Sound')
subplot(3,1,2)
plot(output);
title('Compressed Sound')
subplot(3,1,3)
plot(gain)
title('Gain Signal')

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2 - Ring Modulator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs = fsg;
% the input frequency is fairly arbitrary, but should be about an order of
% magnitude higher than the input frequencies to produce a
% consistent-sounding effect
inputFreq = 2500;
depth = 0.5;
[output]=ringmod(constants,guitarSound,inputFreq,depth);

soundsc(output,constants.fs)
disp('Playing the RingMod Output');
pause(length(output)/constants.fs)
audiowrite('output_ringmod.wav',output,fsg);

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 3 - Stereo Tremolo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LFO_type = 'sin';
LFO_rate = 5;
% lag is specified in number of samples
% the lag becomes very noticeable one the difference is about 1/10 sec
lag = 100;
depth = 0.4;
[output]=tremolo(constants,cleanGuitarSound,LFO_type,LFO_rate,lag,depth);

soundsc(output,constants.fs)
disp('Playing the Tremolo Output');
pause(length(output)/constants.fs)
audiowrite('output_tremelo.wav',output,fsg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 4 - Distortion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Overdrive Distortion

gain = 12;
inSound = cleanGuitarSound(:,1);
tone = 0.7;
[output]=distortion(constants,inSound,gain,tone);

soundsc(output,constants.fs)
disp('Playing the Distortion Output');
pause(length(output)/constants.fs)
audiowrite('output_distortion.wav',output',fsag);

figure
hold on
plot(output,'r')
plot(inSound)
legend('Distorted Signal','Input Signal')

L = 10000;
n = 1:L;
sinSound = sin(2*pi*440*(n/fsag));
[output]=distortion(constants,sinSound,gain,tone);

figure; hold on;
plot(output,'r');
plot(sinSound);
legend('Distorted Signal','Input Sine Wave')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 5 - Delay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% slapback settings
inSound = guitarSound;
delay_time = 0.1; % in seconds
depth = 0.8;
feedback = 0;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(output,constants.fs)
disp('Playing the Slapback Output');
pause(length(output)/constants.fs)
audiowrite('output_slapback.wav',output',fsag);

%%
% cavern echo settings
inSound = guitarSound;
delay_time = 0.4;
depth = 0.6;
feedback = 0.6;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(output,constants.fs)
disp('Playing the cavern Output');
pause(length(output)/constants.fs)
audiowrite('output_cave.wav',output',fsg);

%%
% delay (to the beat) settings
inSound = guitarSound;
delay_time = 0.18;
depth = 1;
feedback = 0;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(output,constants.fs)
disp('Playing the delayed on the beat Output');
pause(length(output)/constants.fs)
audiowrite('output_beatdelay.wav',output',fsg);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 6 - Flanger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inSound = drumSound;
constants.fs = fsd;

depth = 0.8;
delay = .001;   
width = .002;   
LFO_Rate = 1;   
[output]=flanger(constants,inSound,depth,delay,width,LFO_Rate);

soundsc(output,constants.fs)
disp('Playing the Flanger Output');
pause(length(output)/constants.fs)
audiowrite('output_flanger.wav',output',fsd);

% I used a sine wave as my LFO waveform because it provides a smooth
% oscillating sweep which sounds really good. The triangle waveform is a
% little harsher.

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 7 - Chorus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inSound = guitarSound(:,1);
constants.fs = fsg;
depth = 0.9;
delay = .03;   
width = 0.02;   
LFO_Rate = 0.5; % irrelevant if width = 0
[output]=flanger(constants,inSound,depth,delay,width,LFO_Rate);

soundsc(output,constants.fs)
disp('Playing the Chorus Output');
pause(length(output)/constants.fs)
audiowrite('output_chorus.wav',output',fsg);
