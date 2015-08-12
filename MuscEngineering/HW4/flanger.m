function [soundOut]=flanger(constants,inSound,depth,delay,width,LFO_Rate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [soundOut]=flanger(constants,inSound,depth,delay,width,LFO_Rate)
%
% This function creates the sound output from the flanger effect
%
% OUTPUTS
%   soundOut = The output sound vector
%
% INPUTS
%   constants   = the constants structure
%   inSound     = The input audio vector
%   depth       = depth setting in seconds
%   delay       = minimum time delay in seconds
%   width       = total variation of the time delay from the minimum to the maximum
%   LFO_Rate    = The frequency of the Low Frequency oscillator in Hz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

soundsize = size(inSound);
delaysamp = round(constants.fs*delay);
maxind = round(delaysamp + 2*width*constants.fs);

sound = [zeros(soundsize(2),maxind) inSound' zeros(soundsize(2),maxind)];
copy = sound;
t = 0:1/constants.fs:length(copy)/constants.fs - 1/constants.fs;
wave = round(sin(2*pi*LFO_Rate*t)*width/2*constants.fs)+delaysamp;

wavbuff = 1:length(wave);
wave2 = wavbuff-wave;
wave2 = [wave2(1+delaysamp:end) ones(1,delaysamp)];
wave2(wave2<=0) = 1;
copy = copy(wave2);
delaymix = repmat(copy,soundsize(2),1);
soundOut = depth*delaymix + sound;

end