% Spencer Chan
% HW 3 MIDI Parser

clear all;

% 3 Different Patches Used
% Regular ADSR Sine Wave, ADSR sine wave with vibrato, FM synthesis used.
% Additive Bell, Subtractive and Waveform Drum don't function with the
% proper frequencies well.

% Other files to test, 'bach_bourree.mid', 'test.mid', 'happy_birthday.mid'

constants.Fs = 44100;
[tracks, notes, bpm, ppqn] = ReadMidi('bach_bourree.mid');
[Audio] = Synth(tracks,notes,bpm,ppqn,constants);

soundsc(Audio,constants.Fs)