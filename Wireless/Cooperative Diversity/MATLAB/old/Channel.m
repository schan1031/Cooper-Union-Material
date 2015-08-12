classdef Channel < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dist;
        id;
        rchan;
        awgnchan;
        SNR;
    end
    
    methods
        function obj = Channel(node1,node2,fc,ts,fd,SNR)
            obj.dist = sqrt(sum((node1.coords-node2.coords).^2));
            obj.id = sort([node1.id node2.id]);
            obj.rchan = rayleighchan(ts,fd);
            obj.rchan.NormalizePathGains = 1;
%             obj.rchan.AvgPathGaindB = -20*log10(4*pi*obj.dist/(3e8/fc));
            obj.rchan.StorePathGains = 1;
            obj.awgnchan = comm.AWGNChannel('SNR',SNR);
            obj.SNR = SNR;
        end
        
        function output = chfilter(obj,input)
            output = filter(obj.rchan,input);
            output = step(obj.awgnchan,output);
        end
    end
    
end

