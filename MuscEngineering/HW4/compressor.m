function [soundOut,gain] = compressor(constants,inSound,threshold,slope,avg_len)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [output,gain] = compressor(constants,inSound,threshold,attack,avg_len)
%
%COMPRESSOR applies variable gain to the inSound vector by limiting the
% level of any audio sample of avg_length with rms power greater than
% threshold according to slope
%
% OUTPUTS
%   soundOut    = The output sound vector
%   gain        = The vector of gains applied to inSound to create soundOut
%
% INPUTS
%   constants   = the constants structure
%   inSound     = The input audio vector
%   threshold   = The level setting to switch between the two gain settings
%   attack      = time over which the gain changes
%   avg_len     = amount of time to average over for the power measurement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sound = inSound(:,1);

if mod(length(sound),avg_len) ~= 0
    sound = sound(1:(length(sound)-mod(length(sound),avg_len)));
end

power = sound.^2;
soundlen = length(sound);

power = reshape(power,avg_len,soundlen/avg_len);
pthresh = max(mean(power))*threshold;
power = repmat(mean(power),avg_len,1);
power = reshape(power,1,soundlen);

power = power < pthresh;
power = double(power);
power(power==0) = slope;
pvect = sqrt(double(power))';

soundOut = sound.*pvect;
gain = pvect;


end