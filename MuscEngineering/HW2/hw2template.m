%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT
%     hw2
% Spencer Chan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear functions
clear variables

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs = 44100;
constants.time = 3;

instruments = {'Additive' 'Subtractive' 'FM' 'Wave Shaping'}
notes = {'A6' 'A4' 'C4' 'A2'}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Questions 1--4 - samples
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1:length(instruments)
    [soundout] = create_sound(instruments{ii},notes{ii},constants);
    soundsc(soundout,constants.fs)
    disp(['Now playing ' instruments{ii} ' synthesis.'])
    pause(constants.time+1)
end
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 5  - chords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Temperaments = {'Just' 'Equal' 'Just' 'Equal'};
Type = {'Major' 'Major' 'Minor' 'Minor'};
Instruments = {'Additive' 'Subtractive' 'FM' 'Wave Shaping'};
notes = {'G5' 'C4' 'C4' 'A3'}

for jj = 1:4
    for ii = 1:4
        [ soundout ]= instrument_chord(Temperaments{ii},Type{ii},Instruments{jj},notes{jj},constants);
        soundsc(soundout,constants.fs)
        disp(['Now playing ' instruments{jj} ' ' Temperaments{ii} ' Tempered ' Type{ii} ' chord.' char(10)])
        pause(constants.time+1)
        clear soundout
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 6  - Discussion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Part a/b
% I can hear the difference between the just tempered and equal tempered
% major chords most clearly on the additive synthesis because the bell
% model works only at higher frequencies, when the gap between the equal
% and tempered frequencies is larger. It is hard to differentiate on the
% others. The bell itself is hard to tell which sounds better, or even
% clearly hear the chord, so it is hard to differentiate, and choose one
% over the other. However, only in the Equal tempered major chord in the
% wave shaping model, I hear some sort of pulsing to the sound which makes
% it sound better than the Just tempered major chord.

% Part c/d
% Similar to the major chord, the bell provides the clearest difference. It
% is quite difficult to discern a difference between the temperaments.

%% Song - Short Version of Long Long Ago
constants.time = 0.3;
LLAgo = {'C4' 'G3' 'C4' 'D4' 'E4' 'G3' 'E4' 'F4' 'G4' 'G3' 'A4' 'G4' 'E4' 'G3' 'G3' 'G3' 'G4' 'G3' 'F4' 'E4' 'D4' 'G3' 'E4' 'D4' 'C4' 'G3' 'E3' 'G3'};

for ii = 1:length(LLAgo)
    [soundout] = create_sound('FM',LLAgo{ii},constants);
    soundsc(soundout,constants.fs)
    pause(constants.time)
end

constants.time = 1;
[chord] = instrument_chord('equal','major','FM','C3',constants);
soundsc(chord,constants.fs)
pause(constants.time)

%% Song
q = 0.2;
constants.time = q;
ent = {'D4' 'D#4' 'E4'};
for ii = 1:length(ent)
    [soundout] = create_sound('FM',ent{ii},constants);
    soundsc(soundout,constants.fs)
    pause(constants.time)
end

constants.time = 2*q;
[soundout] = create_sound('FM','C5',constants);
soundsc(soundout,constants.fs)
pause(constants.time)

constants.time = q;
ent = {'E4' 'C5'};
for ii = 1:length(ent)
    [soundout] = create_sound('FM',ent{ii},constants);
    soundsc(soundout,constants.fs)
    pause(constants.time)
end
pause(0.3)

[soundout] = create_sound('FM','E4',constants);
soundsc(soundout,constants.fs)
pause(constants.time)

constants.time = 2*q;
[soundout] = create_sound('FM','C5',constants);
soundsc(soundout,constants.fs)
pause(constants.time)

constants.time = q;
ent = {'C5' 'D5' 'D#5' 'E5' 'C5' 'D5'};
for ii = 1:length(ent)
    [soundout] = create_sound('FM',ent{ii},constants);
    soundsc(soundout,constants.fs)
    pause(constants.time)
end

constants.time = 2*q;
[soundout] = create_sound('FM','E5',constants);
soundsc(soundout,constants.fs)
pause(constants.time)

constants.time = q;
[soundout] = create_sound('FM','B4',constants);
soundsc(soundout,constants.fs)
pause(constants.time)

constants.time = 2*q;
ent = {'D5' 'C5'};
for ii = 1:length(ent)
    [soundout] = create_sound('FM',ent{ii},constants);
    soundsc(soundout,constants.fs)
    pause(constants.time)
end
pause(2*q)

constants.time = q;
ent = {'C5' 'D5' 'E5' 'C5' 'D5'};
for ii = 1:length(ent)
    [soundout] = create_sound('FM',ent{ii},constants);
    soundsc(soundout,constants.fs)
    pause(constants.time)
end

constants.time = 2*q;
[soundout] = create_sound('FM','E5',constants);
soundsc(soundout,constants.fs)
pause(constants.time)

constants.time = q;
ent = {'C5' 'D5' 'C5' 'E5' 'C5' 'D5'};
for ii = 1:length(ent)
    [soundout] = create_sound('FM',ent{ii},constants);
    soundsc(soundout,constants.fs)
    pause(constants.time)
end

constants.time = 2*q;
[soundout] = create_sound('FM','E5',constants);
soundsc(soundout,constants.fs)
pause(constants.time)

constants.time = q;
ent = {'C5' 'D5' 'C5' 'E5' 'C5' 'D5'};
for ii = 1:length(ent)
    [soundout] = create_sound('FM',ent{ii},constants);
    soundsc(soundout,constants.fs)
    pause(constants.time)
end

constants.time = 2*q;
[soundout] = create_sound('FM','E5',constants);
soundsc(soundout,constants.fs)
pause(constants.time)

constants.time = q;
[soundout] = create_sound('FM','B4',constants);
soundsc(soundout,constants.fs)
pause(constants.time)

constants.time = 2*q;
[soundout] = create_sound('FM','D5',constants);
soundsc(soundout,constants.fs)
pause(constants.time)

constants.time = 4*q;
[soundout] = create_sound('FM','C5',constants);
soundsc(soundout,constants.fs)
pause(constants.time)