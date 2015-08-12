function [ sound ] = instrument_chord( temp, type, instrument, notes, constants )
%Instrument Chord Function

A = 440;
scl = nthroot(2,12);
C = A/scl^9;

% Equal temperament coefficients

a = nthroot(2,12);
eqtemp = [a a^2 a^3 a^4 a^5 a^6 a^7 a^8 a^9 a^10 a^11 a^12];

% Just temperament coefficents

justemp = [16/15 10/9 9/8 6/5 5/4 4/3 45/32 64/45 3/2 8/5 5/3 7/4 9/5 15/8 2];

if ischar(notes)
    if length(notes)<3
        note = double(notes(1));
        note = sum(note);
        octave = str2num(notes(2));
    else
        note = double(notes(1:2));
        note = sum(note);
        octave = str2num(notes(3));
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
            note = base;
        case 68
            note = base*scl^2;
        case 69
            note = base*scl^4;
        case 70
            note = base*scl^5;
        case 71
            note = base*scl^7;
        case 65
            note = base*scl^9;
        case 66
            note = base*scl^11;
        case {102, 166}
            note = base*scl;
        case {103, 167}
            note = base*scl^3;
        case {105, 169}
            note = base*scl^6;
        case {106, 163}
            note = base*scl^8;
        case {100, 164}
            note = base*scl^10;
    end
else
    note = notes;
end

switch temp
    case{'Just','just'}
        scaleup = justemp;
    case{'Equal','equal'}
        scaleup = eqtemp;
end

switch type
    case{'Major','major'}
        if length(scaleup)<13
            note = [note note*scaleup(4) note*scaleup(7)];
        else
            note = [note note*scaleup(5) note*scaleup(9)];
        end        
    case{'Minor','minor'}
        if length(scaleup)<13
            note = [note note*scaleup(3) note*scaleup(7)];
        else
            note = [note note*scaleup(4) note*scaleup(9)];
        end
end

for ii=1:3
    sound(ii,:) = [create_sound(instrument, note(ii), constants)];
end
sound = sum(sound,1);

end

