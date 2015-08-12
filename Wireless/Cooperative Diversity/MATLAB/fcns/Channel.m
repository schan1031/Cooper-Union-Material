classdef Channel < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tx_node;
        rx_node;
        dist;
        rchan;
        SNR;
        awgnchan;
        noisepwr;
        fs;
    end
    
    methods
        function obj = Channel(tx_node,rx_node,fc,fs,fd,noisefloor)
            obj.tx_node = tx_node;
            obj.rx_node = rx_node;
            obj.dist = sqrt(sum((tx_node.coords-rx_node.coords).^2));
            
            % Rayleigh channel properties
            obj.rchan = rayleighchan(1/fs,fd);
            obj.rchan.ResetBeforeFiltering = 0;
            obj.rchan.NormalizePathGains = 1;
            obj.rchan.AvgPathGaindB = rf_pathloss(obj.dist,fc);
            obj.rchan.StorePathGains = 1;
            obj.awgnchan = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (SNR)');
            obj.noisepwr = noisefloor;
            obj.fs = fs;
        end
        
        function output = chfilter(obj,input)
            obj.SNR = 10*log10(sigpower(input,obj.fs)/obj.noisepwr);
%             obj.awgnchan.SignalPower = sigpower(input,obj.fs);
            output = filter(obj.rchan,input);
%             output = step(obj.awgnchan,output);
%             output = awgn(output,obj.awgnchan.SNR,'measured');
        end
        
        function loss = pathloss(obj)
            loss = obj.rchan.AvgPathGaindB;
        end
        
        function [ rcv, err ] = tx( obj, msg )
            [rcv, err] = obj.rx_node.receive(obj.chfilter(obj.tx_node.send(msg)),obj.rchan.PathGains);
        end
        
        function [ ] = updatenodes(obj, tx_node, rx_node)
            obj.tx_node = tx_node;
            obj.rx_node = rx_node;
            obj.dist = sqrt(sum((tx_node.coords-rx_node.coords).^2));
        end

        function [ ] = reset(obj)
            reset(obj.rchan);
        end
    end
end

