function [ power ] = sigpower( signal, fs )
%SIGPOWER Calculate the power of a signal at the given sample rate
%   power = sigpower( signal, fs)
    power = fs*sum(abs(signal).^2)/length(signal);
end

