classdef Node < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        coords;
        fs;
        power;
        err;
        
        hmod = comm.QPSKModulator('BitInput',true);
        hdemod = comm.QPSKDemodulator('BitOutput',true);
        hCRC = comm.CRCGenerator([16 15 2 0]);
        hdCRC = comm.CRCDetector([16 15 2 0]);
        trsig;

    end
    
    methods
        function obj = Node(coords, fs, power)
            obj.coords = coords;
            obj.fs = fs;
            obj.power = power;
        end
        
        function [ bits, err ] = receive(obj,signal,pathgains)
            demod = step(obj.hdemod,signal./pathgains);
            [bits, err] = step(obj.hdCRC,demod);
            obj.err = err;
        end
        
        function [ signal ] = send(obj, bits)
            tx_crc = step(obj.hCRC,bits);
            signal = step(obj.hmod,tx_crc);
            signal = signal*sqrt(obj.power/sigpower(signal,obj.fs));
        end
            
    end
end

