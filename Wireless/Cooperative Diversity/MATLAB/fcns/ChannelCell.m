classdef ChannelCell < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nodearray;
        channelarray;
        nodenum;
    end
    
    methods
        function obj = ChannelCell(nodearray,fc,fs,fd,noisefloor)
            obj.nodearray = nodearray;
            obj.nodenum = length(obj.nodearray);
                obj.channelarray = cell(obj.nodenum,obj.nodenum);
                for tx_node = 1:obj.nodenum
                    for rx_node = 1:obj.nodenum
                        if tx_node == rx_node
                            continue;
                        end
                        obj.channelarray{tx_node,rx_node} = Channel(nodearray{tx_node},nodearray{rx_node},fc,fs,fd,noisefloor);                       
                    end
                end
        end
        
        function [ rcv, err ] = tx(obj,tx_node,rx_node,msg)
            [rcv, err] = obj.channelarray{tx_node,rx_node}.tx(msg);
        end
        
        function [ ] = reset(obj)
            for tx_node = 1:obj.nodenum
                for rx_node = 1:obj.nodenum
                    if tx_node == rx_node
                        continue;
                    end
                    obj.channelarray{tx_node,rx_node}.reset();
                end
            end
        end
    end
end


