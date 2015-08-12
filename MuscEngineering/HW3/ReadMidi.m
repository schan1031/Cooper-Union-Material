function [tracks, notes, bpm, ppqn] = ReadMidi(filename)
% ReadMidi Function, reads in the midi file and grabs the note structure

% Read In the File
[readin] = fopen(filename,'r');
[song numbytes] = fread(readin,'uint8');
a = fi(song,0,8,0);
fclose(readin);
songhex = a.hex';
songhex2 = reshape(songhex,1,2*length(a));

% Header

if ~song(1:4) == [77;84;104;100]
    disp('Header incorrectly specified')
end

headlength = sum(song(5:8));

if headlength == 6
    format = hex2dec(songhex(17:20));
    numtracks = hex2dec(songhex(21:24));
    ppqn = hex2dec(songhex(25:28));
else
    disp('Error, Header Length is incorrect.')
end

% Separate Tracks

tracklocation = strfind(songhex2,'4d54726b');
tracklocation = [tracklocation length(songhex2)];
tracklength = diff(tracklocation);

for ii = 1:length(tracklocation)-1
    tracks(ii,1:tracklength(ii)) = songhex2(tracklocation(ii):(tracklocation(ii+1)-1));
    
end

% Preallocate Variables

tracksize = size(tracks);
notes = [];
notesoff = [];
notecount = 1;
patch = [];
mode = 0;
backtime = 0;
secperppq = [];

% Loop through Tracks

for jj = 1:tracksize(1)
    ii = 17;
    backtime = 0;
    mode = 0;
    
    % Find Microseconds per PPQ
    
    if length(secperppq)<1
        beat = strfind(tracks(jj,:),'ff51');
        trackstemp = tracks(jj,:);
        secperppq = hex2dec(trackstemp(beat+4:beat+5));
        secperppq = hex2dec(trackstemp(beat+6:beat+5+secperppq*2));
    end
    
    % Begin parsing through each track
    
    while ii < length(tracks(jj,:))
        pos = tracks(jj,ii);
        pos2 = tracks(jj,ii+1);
        pos3 = tracks(jj,ii+2);
        pos4 = tracks(jj,ii+3);
        val = hex2dec(pos);
        val2 = hex2dec(pos2);
        val3 = hex2dec(pos3);
        val4 = hex2dec(pos4);
        
        if length(pos)>0
            ii = ii;
        else
            ii = length(track(jj,:));   % If reaches NULL character, move to next track
        end
        
        % Find Delta Time
        if mode == 0                    % Mode 0 is looking for delta time
            if val<8
                deltime = hex2dec([pos pos2]);
                ii = ii + 2;
            else
                pos3 = [dec2bin(val,4) dec2bin(val2,4)];
                pos4 = [dec2bin(val3,4) dec2bin(val4,4)];
                deltime = bin2dec([pos3(2:8) pos4(2:8)]);
                ii = ii + 4;
            end
            backtime = backtime + deltime;
        else                            % Mode 1 is looking for commands
            switch val
                case 8                  % Note Off 
                    channel = val2;
                    notenum = hex2dec(tracks(jj,ii+2:ii+3));
                    velocityoff = tracks(jj,ii+4:ii+5);
                    
                    note{notecount}.onoff = 0;
                    note{notecount}.channel = channel;
                    note{notecount}.notenum = notenum;
                    note{notecount}.velocity = hex2dec(velocityoff);
                    note{notecount}.time = backtime;
                    note{notecount}.deltatime = deltime;
                    note{notecount}.tracknum = jj;
                    note{notecount}.patches = patch;
                    notes = [notes note{notecount}];
                    ii = ii + 6;
                    
                case 9                  % Note On
                    notecount = notecount + 1;
                    channel = val2;
                    notenum = hex2dec(tracks(jj,ii+2:ii+3));
                    velocityon = tracks(jj,ii+4:ii+5);
                    
                    note{notecount}.onoff = 1;
                    note{notecount}.channel = channel;
                    note{notecount}.notenum = notenum;
                    note{notecount}.velocity = hex2dec(velocityon);
                    note{notecount}.time = backtime;
                    note{notecount}.deltatime = deltime;
                    note{notecount}.tracknum = jj;
                    note{notecount}.patches = patch;
                    notes = [notes note{notecount}];
                    ii = ii+6;
                case 10
                    ii = ii + 6;
                case 11
                    ii = ii + 6;
                case 12                 % Patch
                    switch pos2
                        case '0'
                            patch = hex2dec([pos3 pos4]);
                    end
                    ii = ii + 4;
                case 13
                    ii = ii + 4;
                case 14
                    ii = ii + 6;
                case 15                 % FF commands
                    if hex2dec([tracks(jj,ii+2) tracks(jj,ii+3)])==47
                        ii = length(tracks(jj,:));
                    else
                        if ii > length(tracks)-5
                            length(tracks);
                        else
                            skip = hex2dec(tracks(jj,ii+4:ii+5));
                            ii = ii + 6 + 2*skip;
                        end
                    end
            end
        end
        
        % Toggle Mode
        if mode == 0
            mode = 1;
        else
            mode = 0;
        end

    end
end

% Calculate BPM

if length(secperppq)>0
    bpm = 60e6/secperppq;
else
    bpm = 120;
    
end
end