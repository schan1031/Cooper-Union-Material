function [ sound ] = create_sound( instrument, notes, constants )
%CREATE SOUND, instrument, notes to play, constants inputs

% Convert Note Name to Frequency

A = 440;
scl = nthroot(2,12);
C = A/scl^9;

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

% Cases

switch instrument
    case{'Additive','additive'}
        Duration = constants.time;
        Tone = note;
        basetime = 1/constants.fs:1/constants.fs:Duration;
        
        % Amplitude and Duration
        amp = [1 .67 1 1.8 2.67 1.67 1.46 1.3 1.33 1 1.33];
        dur = Duration * [ 1 .9 .65 .55 .325 .35 .25 .2 .15 .1 .075];
        
        % Frequency Vector
        freqs = [.56 .56 .92 .92 1.19 1.7 2 2.74 3 3.76 4.07];
        
        % Amplitude Vector
        envelope = linspace(1,0.5,Duration*constants.fs);
        wave = zeros(length(dur),Duration*constants.fs);
        for ii = 1:length(dur)
            c = ceil(constants.fs*dur(ii));
            wave(ii,:) = [ones(1,ceil(constants.fs*dur(ii))) zeros(1,floor(Duration*constants.fs - c))];
        end
        
        % First Stage Out
        for ii = 1:length(amp)
            wave(ii,:) = amp(ii)*wave(ii,:);
        end
        
        % Waves
        soundout = zeros(length(dur),Duration*constants.fs);
        for ii = 1:length(freqs)
            soundout(ii,:) = wave(ii,:).*sin(2*pi*Tone*freqs(ii).*basetime);
        end
        soundout = sum(soundout,1);
        sound = envelope.*soundout;
        
    case{'Subtractive','subtractive'}
        Fs = constants.fs;
        Time = constants.time;
        basetime = 1/Fs:1/Fs:Time;
        Tone = note;
        soundout = sawtooth(2*pi*Tone*basetime,1);
        soundout2 = [];
        len = length(soundout);
        r = 0.6;
        x = Tone;
        for ii = 1:x
            size = Fs/x;
            theta = (-x+ii)/x*pi;
            a = [1 -2*r*cos(theta) r^2];
            soundout2 = [soundout2 filter(1,a,soundout(round(1:len/x)))];
        end
        enve = linspace(0.5,1,length(soundout2));
        sound = [enve.*soundout2 zeros(1,length(soundout)-length(soundout2))];
    case{'Frequency','frequency','fm','fmmod','FM'}
        Duration = constants.time;
        Fs = constants.fs;
        basetime = 1/Fs:1/Fs:Duration;
        Tone = note;
        fc = Tone;
        fdev = 500;
        
        A = linspace(0,.8,Duration*Fs*.08);
        D = linspace(.8,.75,Duration*Fs*.25);
        S = linspace(.75,.75,Duration*Fs*.65);
        R = linspace(.75,0,Duration*Fs*.02);
        ADSR = [A D S R];
        ADSR = [ADSR zeros(1,Duration*constants.fs - length(ADSR))];
        
        sounda = ADSR.*sin(2*pi*Tone*basetime);
        soundb = fmmod(sounda,fc,Fs,fdev);
        soundc = ADSR.*soundb;
        sound = sounda.*sin(2*pi*soundc.*basetime);
        
    case{'Wave','wave','Wave Shaping','wave shaping','waves'}
        Fs = constants.fs;
        Tone = note;
        Duration = constants.time;
        t1 = 1/Fs:1/Fs:Duration;
        t2 = 1/Fs:1/Fs:Duration;
        amp1 = linspace(1,0,length(t1)*.2);
        amp1 = 255.*[amp1 zeros(1,length(t1)*.8)];
        amp2 = [linspace(0,1,length(t1)*.1) linspace(1,.5,length(t1)*.1) linspace(.5,.25,length(t1)*.2) linspace(.25,0,length(t1)*.6)];
        
        wave1 = amp1.*sin(2*pi*Tone*.7071*t2);
        wave1 = wave1+256;
        wave2 = amp2.*sin(2*pi*Tone*t1);
        
        wave1 = [.21*wave1; .25*wave1; -.297*wave1; -.354*wave1; .42*wave1; .5*wave1; -.595*wave1; -.707*wave1; .841*wave1; 1*wave1];
        wave1 = sum(wave1,1);
        wavefinal = wave1.*wave2;
        sound = wavefinal;
    otherwise
        error('Synthesis type not recognized');
end

end

