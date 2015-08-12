function [AccAudio] = Synth(tracks,notes,bpm,ppqn,constants)
% Synth function, synthesize midi notes structure.

% Manual Fix for random cases of bpm reading incorrectly
if bpm < 10
    bpm = 10;
end

% Setting Up Matrices To Work With
constants.constants.Fs = 44100;
track = [notes.tracknum]';
tone = [notes.notenum]';
velocity = [notes.velocity]';
onoff = [notes.onoff]';
channel = [notes.channel]';
time = [notes.deltatime]';
totime = [notes.time]';

x = [tone totime velocity channel onoff track time];
xlen = length(x);
numtracks = unique(x(:,6));
patch = [notes.patches];
patch = unique(patch);
patch = patch(1);

% Sort by track and by note

if length(numtracks)>1

    for ii = 1:length(numtracks)-1
        ind(ii) = min(find(x(:,6)==numtracks(ii+1)));
    end
    ind = [1 ind xlen + 1];
    
    for ii = 1:length(numtracks)
        y(ind(ii):ind(ii+1)-1,:) = sortrows(x(ind(ii):ind(ii+1)-1,:));
    end    
else    
    y = sortrows(x);
end
z = y(:,1:3);

% Allocate Accumulated Audio
AccAudio = zeros(1,ceil(max(totime)/ppqn*constants.Fs*60/bpm));

% Loops
ii = 1;
while ii<length(y)
    
    % Calculate Note Frequency
    note = z(ii,1);
    
    % Convert note
    notebase = note/12;
    modnote = mod(note,12);
    
    A = 440;
    scl = nthroot(2,12);
    C = A/scl^9;
    
    if notebase < 1
        base = C/2^4;
    elseif notebase < 2
        base = C/2^3;
    elseif notebase < 3
        base = C/2^2;
    elseif notebase < 4
        base = C/2;
    elseif notebase < 5
        base = C;
    elseif notebase < 6
        base = C*2;
    elseif notebase < 7
        base = C*2^2;
    elseif notebase < 8
        base = C*2^3;
    else
        base = C;
    end
    
    switch(modnote)
        case 0
            note = base;
        case 2
            note = base*scl^2;
        case 4
            note = base*scl^4;
        case 5
            note = base*scl^5;
        case 7
            note = base*scl^7;
        case 9
            note = base*scl^9;
        case 11
            note = base*scl^11;
        case 1
            note = base*scl;
        case 3
            note = base*scl^3;
        case 6
            note = base*scl^6;
        case 8
            note = base*scl^8;
        case 10
            note = base*scl^10;
    end
    
    % Create Time Vectors
    time = (z(ii+1,2) - z(ii,2));
    timesec = time/ppqn;
    timestart = z(ii,2)/ppqn;
    
    if timesec > 16*ppqn
        timesec = 1;
    end
    t = 0:1/constants.Fs:(timesec-1/constants.Fs)*60/bpm;
    
    
    % Create ADSR Envelope
    A = linspace(0,1,length(t)*.15);
    D = linspace(1,.75,length(t)*.15);
    S = linspace(.75,.75,length(t)*.6);
    R = linspace(0.75,0,length(t)*.1);
    ADSR = [A D S R];
    ADSR = [ADSR zeros(1,length(t) - length(ADSR))];
        
    if patch<63
        
        %Regular Wave
        TmpAudio = z(ii,3)*sin(2*pi*note*t);

    elseif 64<patch<80
        
        % Slight Vibrato Wave
        Wave = sin(2*pi*note*t);
        Mod = 1.3*sin(2*pi*1.5*t);
        Sum = sin(2*pi*note*t + pi/2).*Mod;
        TmpAudio = z(ii,3)*(Wave+Sum);
        
    else
        % FM
        fc = note;
        Fs = constants.Fs;
        fdev = 500;
        basetime = t;
        sounda = ADSR.*sin(2*pi*note*basetime);
        soundb = fmmod(sounda,fc,Fs,fdev);
        soundc = ADSR.*soundb;
        TmpAudio = sounda.*sin(2*pi*soundc.*basetime);
    
    end
    
    % Compile Audio
    TmpAudio = ADSR.*TmpAudio;
    TmpAudio = [zeros(1,round(timestart*constants.Fs*60/bpm)) TmpAudio];
    TmpAudio = [TmpAudio zeros(1,length(AccAudio) - length(TmpAudio))];
    AccAudio = AccAudio+TmpAudio;

    ii = ii+2;
    h = waitbar(ii/length(y));
end
close(h)

end