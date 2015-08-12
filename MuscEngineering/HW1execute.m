clear all; close all; dbstop if error;

% Constants Object

constants.fs = 44100;
constants.chordtime = 3;
constants.scaletime = 0.5;

%% Part 2

% Part a
% Note syntax - note followed by accidental, then octave e.g. C4, D#3

[JustMajorScale] = musicscale('Major','Just','C4',constants);
[JustMinorScale] = musicscale('Minor','Just','C4',constants);

disp('Playing just tempered major scale')
soundsc(JustMajorScale,constants.fs);
pause(constants.scaletime*10);

disp('Playing just tempered minor scale')
soundsc(JustMinorScale,constants.fs);
pause(constants.scaletime*10);

% Part b

[EqualMajorScale] = musicscale('Major','Equal','C4',constants);
[EqualMinorScale] = musicscale('Minor','Equal','C4',constants);

disp('Playing equal tempered major scale')
soundsc(EqualMajorScale,constants.fs);
pause(constants.scaletime*10);

disp('Playing equal tempered minor scale')
soundsc(EqualMinorScale,constants.fs);
pause(constants.scaletime*10);


%% Part 3

% Part a

[JustMajorChord] = chord('Major','Just','C4',constants);
[JustMinorChord] = chord('Minor','Just','C4',constants);

disp('Playing just tempered major chord')
soundsc(JustMajorChord,constants.fs);
pause(constants.chordtime+0.5);

disp('Playing just tempered minor chord')
soundsc(JustMinorChord,constants.fs);
pause(constants.chordtime+0.5);

% Part b

[EqualMajorChord] = chord('Major','Equal','C4',constants);
[EqualMinorChord] = chord('Minor','Equal','C4',constants);

disp('Playing equal tempered major chord')
soundsc(EqualMajorChord,constants.fs);
pause(constants.chordtime+0.5);

disp('Playing equal tempered minor chord')
soundsc(EqualMinorChord,constants.fs);
pause(constants.chordtime+0.5);


%% Part 4 - Graphs

% Equal temperament coefficients

a = nthroot(2,12);
eqtemp = [a a^2 a^3 a^4 a^5 a^6 a^7 a^8 a^9 a^10 a^11 a^12];

% Just temperament coefficents

justemp = [16/15 10/9 9/8 6/5 5/4 4/3 45/32 64/45 3/2 8/5 5/3 7/4 9/5 15/8 2];

% Equal Tempered Major Chord
t = 0:0.0001:.025;
x = sin(2*pi*440*t)+sin(2*pi*440*eqtemp(4)*t)+sin(2*pi*440*eqtemp(7)*t);
subplot(2,1,1)
plot(t,x)
title('Equal Tempered Major Chord, One Wavelength')
subplot(2,1,2)
t2 = 0:0.0001:.1;
x2 = sin(2*pi*440*t2)+sin(2*pi*440*eqtemp(4)*t2)+sin(2*pi*440*eqtemp(7)*t2);
plot(t2,x2)

% Equal Tempered Minor Chord
figure
t = 0:0.0001:.025;
x = sin(2*pi*440*t)+sin(2*pi*440*eqtemp(3)*t)+sin(2*pi*440*eqtemp(7)*t);
subplot(2,1,1)
plot(t,x)
title('Equal Tempered Minor Chord, One Wavelength and Multiple Wavelengths')
subplot(2,1,2)
t2 = 0:0.0001:.1;
x2 = sin(2*pi*440*t2)+sin(2*pi*440*eqtemp(3)*t2)+sin(2*pi*440*eqtemp(7)*t2);
plot(t2,x2)

% Just Tempered Major Chord
figure
t = 0:0.0001:.025;
x = sin(2*pi*440*t)+sin(2*pi*440*justemp(5)*t)+sin(2*pi*440*justemp(9)*t);
subplot(2,1,1)
plot(t,x)
title('Just Tempered Major Chord, One Wavelength and Multiple Wavelengths')
subplot(2,1,2)
t2 = 0:0.0001:.1;
x2 = sin(2*pi*440*t2)+sin(2*pi*440*justemp(5)*t2)+sin(2*pi*440*justemp(9)*t2);
plot(t2,x2)

% Just Tempered Minor Chord
figure
t = 0:0.0001:.025;
x = sin(2*pi*440*t)+sin(2*pi*440*justemp(4)*t)+sin(2*pi*440*justemp(9)*t);
subplot(2,1,1)
plot(t,x)
title('Just Tempered Minor Chord, One Wavelength and Multiple Wavelengths')
subplot(2,1,2)
t2 = 0:0.0001:.1;
x2 = sin(2*pi*440*t2)+sin(2*pi*440*justemp(4)*t2)+sin(2*pi*440*justemp(9)*t2);
plot(t2,x2)

% Part b

% There is a visible difference in the plots of just tempered and equal
% tempered chords. The just tempered chords are much more periodic, while
% the equal tempered chord has some varying amplitudes. Over multiple
% wavelengths, it is easy to see the periodic behavior of the just tempered
% chord compared to the equal tempered chords.

%% Part 5

% Part a & b

% It is difficult to hear the difference between the just tempered and
% equal tempered Major scales. However the equal tempered scale sounds
% slightly more natural, most likely due to my previous music experience.
% It is more likely that I am geared torwards equal tempered sounds in
% terms of scales.

% Part c & d

% It is more clear in the minor scale the difference in the equal and just
% tempered scales. On the flat notes in the minor scale, the just tempered
% scale sounds slightly higher in pitch compared to those in the equal
% tempered scale. The equal tempered sounds better because the flat note is
% further down from the natural, which sounds slightly better.

% Part e & f

% There is a barely a difference in the just and equal temperament major
% chords. However, it is not too noticeable, and the chords are pretty
% close in frequency. It is hard to audibly discern the difference.

% Part g & h

% The minor chords give a clearer difference than the major scales. Similar
% to the minor scales, the minor chords contain the minor third which are
% further apart in frequency than each other. In this case, the equal
% tempered chord sounds different, and slightly more awkward. This is due
% to the fact that the equal tempered system scales off of the 12th root of
% 2. On the other hand, the just tempered system synchronizes harmonically
% much better, which, in chords, makes the sound harmonize better.

%% Extra Credit

% ADSR envelope was added.