% Spencer Chan
% Music and Engineering
% MPEG Encoder HW 5

clc; clear all; close all;
enc = Encoding();

% Other songs include 'sound2.wav', 'guitarriff.wav'.
[song, fs] = audioread('entertainment.wav');

%% No Compression

% Encode
% Last Argument is Toggle Compress.
% 1 is compress, 0 is don't compress.
[enc2] = MPEGencode(song,enc,fs,0);

% Decode
[output] = MPEGdecode(enc2);

soundsc(song,enc2.fs)
disp('Playing Original Song')
pause(length(song)/enc2.fs+1);
soundsc(output,enc2.fs);
disp('Playing Encoded/Decoded Song with no compression')
pause(length(output)/enc2.fs);

figure;
subplot(2,1,1)
plot(song)
title('Original Song Spectrum')
axis([0 8e5 -2 2])
subplot(2,1,2)
plot(output)
title('Encoded and Decoded, No Compression')
axis([0 8e5 -2 2])


%% Compressed

[song, fs] = audioread('sound2.wav');

% Encode
% Last Argument is Toggle Compress.
% 1 is compress, 0 is don't compress.
[enc2] = MPEGencode(song,enc,fs,1);

% Decode
[output] = MPEGdecode(enc2);

soundsc(song,enc2.fs);
disp('Playing Original Song')
pause(length(output)/enc2.fs+1);
soundsc(output,enc2.fs);
disp('Playing Compressed Song')

figure;
subplot(2,1,1)
plot(song)
title('Original Song Spectrum')
axis([0 8e5 -2 2])
subplot(2,1,2)
plot(output)
title('Encoded and Decoded, Compressed')
axis([0 8e5 -2 2])

%NOTE - I used the perceptual threshold model, but it still has a notable
%difference.