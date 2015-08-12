function [output] = tremolo(constants.fs,inSound,LFO_type,LFO_rate,lag,depth)
%TREMOLO tremolo(constants.fs,inputsound,LFO_type,LFO_rate,lag,depth)
%LFO_type is sin, square or triangle
%LFO_rate is speed of LFO
%Lag adjusts the stereo timing
%Depth changes the depth of the stereo switches

t = (0:1/constants.fs:length(inSound)/constants.fs-1/constants.fs)';
t2 = (-(lag*1000/constants.fs):1/constants.fs:(length(inSound)/constants.fs - 1/constants.fs - lag*1000/constants.fs))';
switch LFO_type
    case {'sin','SIN','Sin'}
        lowosc = sin(2*pi*LFO_rate*t)+1;
        lowosc = repmat(lowosc,[1 2]);
        lowosc(:,2) = sin(2*pi*LFO_rate*t2)+1;
    case {'square','Square','sq'}
        lowosc = square(2*pi*LFO_rate*t)+1;
        lowosc = repmat(lowosc,[1 2]);
        lowosc(:,2) = sin(2*pi*LFO_rate*t2)+1;
    case {'triangle','Triangle'}
        lowosc =sawtooth(2*pi*LFO_rate*t,1)+1;
        lowosc = repmat(lowosc,[1 2]);
        lowosc(:,2) = sin(2*pi*LFO_rate*t2)+1;
end

output = depth*lowosc.*inSound + inSound;

end