classdef CRNodeNetwork < handle
    properties
        
        % Constants
        fs;
        nodepos;
        noisefloor;
        nodepower;
        nodenum;
        
        % Arrays
        nodearray;
        channelarray;
        
    end
    
    methods
        function obj = CRNodeNetwork(pos,power,fs,fd,noisefloor)
            obj.nodepos = pos;
            obj.nodenum = length(pos);
           
            if length(power) == 1
                obj.nodepower = repmat(power,obj.nodenum,1);
            else
                obj.nodepower = power;
            end
            
            obj.noisefloor = noisefloor;
            
            obj.nodearray = cell(obj.nodenum,1);
            obj.channelarray = cell(obj.nodenum,obj.nodenum);
            
            
            % Create Channels
            for tx_node = 1:obj.nodenum
                for rx_node = 1:obj.nodenum
                    if tx_node == rx_node
                        continue;
                    end
                    
                    % Make channel                    
                    obj.channelarray{tx_node,rx_node} = rayleighchan(1/fs,fd);
                    obj.channelarray{tx_node,rx_node}.ResetBeforeFiltering = 0;
                    obj.channelarray{tx_node,rx_node}.NormalizePathGains = 0;
                    obj.channelarray{tx_node,rx_node}.StorePathGains = 1;
                end
            end
        end
    end
end