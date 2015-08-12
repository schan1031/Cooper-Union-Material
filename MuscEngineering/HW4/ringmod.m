function [output] = ringmod(constants,inSound,inputFreq,depth)
%RINGMOD applies ring modulator effect to inSound

t = (0:1/constants.fs:length(inSound)/constants.fs-1/constants.fs)';
numvects = size(inSound);
fixed = sin(2*pi*inputFreq*t)+1;
fixed = repmat(fixed,[1 numvects(2)]);
output = depth*fixed.*inSound + inSound;

end