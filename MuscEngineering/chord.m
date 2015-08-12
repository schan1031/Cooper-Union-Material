function [ chord ] = chord( type, temperament, notename, constants )
%CHORD function, make a chord, specify type, temperament, starting
%frequency and constants
%   constants 3 properties - fs, chordtime, scaletime

constants.chordtime = constants.chordtime + 1;

% Convert Note Name to Frequency

A = 440;
scl = nthroot(2,12);
C = A/scl^9;

if length(notename)<3
    note = double(notename(1));
    note = sum(note);
    octave = str2num(notename(2));
else
    note = double(notename(1:2));
    note = sum(note);
    octave = str2num(notename(3));
end

if octave < 4
    roota = 4 - octave;
    base = C/(2^roota);
elseif octave > 4
    roota = octave - 4;
    base = C*2^roota;
else
    base = C;
end

switch(note)
    case 67
        rootnote = base;
    case 68
        rootnote = base*scl^2;
    case 69
        rootnote = base*scl^4;
    case 70
        rootnote = base*scl^5;
    case 71
        rootnote = base*scl^7;
    case 65
        rootnote = base*scl^9;
    case 66
        rootnote = base*scl^11;
    case {102, 166}
        rootnote = base*scl;
    case {103, 167}
        rootnote = base*scl^3;
    case {105, 169}
        rootnote = base*scl^6;
    case {106, 163}
        rootnote = base*scl^8;
    case {100, 164}
        rootnote = base*scl^10;
end

% Equal temperament coefficients

a = nthroot(2,12);
eqtemp = [a a^2 a^3 a^4 a^5 a^6 a^7 a^8 a^9 a^10 a^11 a^12];

% Just temperament coefficents

justemp = [16/15 10/9 9/8 6/5 5/4 4/3 45/32 64/45 3/2 8/5 5/3 7/4 9/5 15/8 2];

% Envelope ADSR
t = 1:1/constants.fs:constants.chordtime;
notelength = length(t);
Attack = linspace(0,1,notelength/4);
Decay = linspace(1,0.75,notelength/8);
Sustain = linspace(0.75,0.75, notelength/2);
Release = linspace(0.75,0,notelength/8);

ADSR = [Attack Decay Sustain Release];
if length(t)>length(ADSR)
    ADSR = [ADSR zeros(1,length(t)-length(ADSR))];
else
    ADSR = ADSR;
end

% Cases

switch temperament
    case{'Just','just'}
        scaleup = justemp;
    case{'Equal','equal'}
        scaleup = eqtemp;
    otherwise
        error('Temperament type not recognized');
end

switch type
    case{'Major','major'}
        if length(scaleup)<13
            chord = ADSR.*sin(2*pi*rootnote*t) + ADSR.*sin(2*pi*rootnote*scaleup(4)*t) + ADSR.*sin(2*pi*rootnote*scaleup(7)*t);
        else
            chord = ADSR.*sin(2*pi*rootnote*t) + ADSR.*sin(2*pi*rootnote*scaleup(5)*t) + ADSR.*sin(2*pi*rootnote*scaleup(9)*t);
        end
    case{'Minor','minor'}
        if length(scaleup)<13
            chord = ADSR.*sin(2*pi*rootnote*t) + ADSR.*sin(2*pi*rootnote*scaleup(3)*t) + ADSR.*sin(2*pi*rootnote*scaleup(7)*t);
        else
            chord = ADSR.*sin(2*pi*rootnote*t) + ADSR.*sin(2*pi*rootnote*scaleup(4)*t) + ADSR.*sin(2*pi*rootnote*scaleup(9)*t);
        end
    otherwise
        error('Chord type not recognized');
end


end

