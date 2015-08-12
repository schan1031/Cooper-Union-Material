clc; clear all;
%%

constants.fs = 44100;
constants.time = 2;
%%

[bell] = create_sound('Additive','A6',constants);

soundsc(bell,constants.fs)
pause(constants.time+1)

%%

constants.time = 2;
[subtractive] = create_sound('Subtractive','A4',constants);

soundsc(subtractive,constants.fs)
pause(constants.time+1)

%%
constants.time = 2;

[fm] = create_sound('fm','C4',constants);

soundsc(fm,constants.fs)
pause(constants.time+1)


%%
[wave] = create_sound('wave','A3',constants);

soundsc(wave,constants.fs)
pause(constants.time+1)

%%
constants.fs = 44100;
constants.time = 2;

instruments = {'Additive' 'Subtractive' 'fm' 'wave'}
notes = {'A6' 'A4' 'C4' 'A2'}

for ii = 1:length(instruments)
    [soundout] = create_sound(instruments{ii},notes{ii},constants);
    soundsc(soundout,constants.fs)
    disp(['Now playing ' instruments{ii} ' synthesis.'])
    pause(constants.time+1)
end
%%
[soundout ]= instrument_chord('Just','Major','wave','A3',constants);
soundsc(soundout,constants.fs)
