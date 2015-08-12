classdef Node < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id;
        coords;
        fs;
        rx_bin;
        rx_crc;
        tx_bin;
        tx_crc;
        err;
        hmod = comm.QPSKModulator();
        hdemod = comm.QPSKDemodulator();
        hCRC = comm.CRCGenerator([16 15 2 0]);
        hdCRC = comm.CRCDetector([16 15 2 0]);
    end
    
    methods
        function obj = Node(id, coords, fs)
            obj.id = id;
            obj.coords = coords;
            obj.fs = fs;
        end
        
        function [ bits, err ] = recieve(obj,signal,pathgains)
            sym = step(obj.hdemod,signal./pathgains);
            bin = str2num(reshape(dec2bin(sym)',2*length(sym),1));
            [bits, err] = step(obj.hdCRC,bin);
            obj.rx_bin = bits;
            obj.rx_crc = bin;
            obj.err = err;
        end
        
        function [ signal ] = send(obj, bits)
            obj.tx_bin = bits;
            obj.tx_crc = step(obj.hCRC,bits);
            sym = bin2dec([num2str(obj.tx_crc(1:2:end,:)) num2str(obj.tx_crc(2:2:end,:))]);
            signal = step(obj.hmod,sym);
%             signal = signal/sum((obj.fs/(2*length(signal)))*abs(signal).^2);
        end
            
    end
end

