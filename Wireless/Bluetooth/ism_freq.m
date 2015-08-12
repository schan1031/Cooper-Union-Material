function [ k ] = ism_freq( npackets )
%ISM_FREQ Return the kth frequency in the ISM band
%   Generates the kth frequency, in MHz, in the regulated ISM frequency
%   band.  k can range from 0 to 78
    k = 0:78;
    njumps = 32;
    k_exclude = randi([0 78],1,78-njumps+1);
    for c = k_exclude
       k = k(k~=c);
    end
    k = k(randperm(length(k)));
    k = k(1:njumps);
    k = repmat(k,1,ceil(npackets/njumps));    
end