x = 'C1';
A = 440;
scl = nthroot(2,12);
C = A/scl^9;

note = double(x(1));
octave = str2num(x(2));

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
end