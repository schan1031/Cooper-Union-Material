function [ loss ] = rf_pathloss( d, f )
%PATHLOSS Calculates the free-space path loss from distance and frequency
%   PATHLOSS( d, f) returns the pathloss of a channel length d meters on
%   frequency f.

    loss = 20*log10(d) + 20*log10(f) - 147.55;
    
end

