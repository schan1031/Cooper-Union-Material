classdef NodeNetwork < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Constants
        M = 4;
        nodenum;
        nodepos;
        noisefloor;
        nodepower;
        fs;
        fc;
        shadowpos;
        
        % Node/Channel objects
        nodearray;
        channelarray;
        awgnarray;
        shadowing;
        
        % Transmission variables
        msgarray;
        rcvarray;
        rxmsgarray;
        errarray;
        status;
        div_node;
        
        % Modulator
        hmod = comm.QPSKModulator('BitInput',true);
        hdemod = comm.QPSKDemodulator('BitOutput',true);
        hDemodSym = comm.QPSKDemodulator('BitOutput',false);
        hCRC = comm.CRCGenerator([16 15 2 0]);
        hdCRC = comm.CRCDetector([16 15 2 0]);
    end
    
    methods
        function obj = NodeNetwork(pos,power,fc,fs,fd,noisefloor,shadow)
            obj.nodepos = pos;
            obj.nodenum = length(pos);
            obj.fs = fs;
            obj.fc = fc;
            
            if length(power) == 1
                obj.nodepower = repmat(power,obj.nodenum,1);
            else
                obj.nodepower = power;
            end
            
            obj.noisefloor = noisefloor;
            
            obj.nodearray = cell(obj.nodenum,1);
            obj.channelarray = cell(obj.nodenum,obj.nodenum);
            obj.awgnarray = cell(obj.nodenum,obj.nodenum);
            
            obj.msgarray = cell(obj.nodenum,1);
            obj.rcvarray = cell(obj.nodenum,1);
            obj.errarray = zeros(obj.nodenum,1);
            obj.shadowing = zeros(obj.nodenum,obj.nodenum);
            obj.shadowpos = shadow;
            
            % Create Channels
            for tx_node = 1:obj.nodenum
                for rx_node = 1:obj.nodenum
                    if tx_node == rx_node
                        continue;
                    end
                    
                    % Check for shadowing (check for circle-line
                    % intersection)
                    for ii = 1:size(shadow,1);
                        x1 = pos(rx_node,1)-shadow(ii,1);
                        x2 = pos(tx_node,1)-shadow(ii,1);
                        y1 = pos(rx_node,2)-shadow(ii,2);
                        y2 = pos(tx_node,2)-shadow(ii,2);
                        r = shadow(ii,3);
                        dx = x2 - x1;
                        dy = y2 - y1;
                        dr = sqrt(dx^2 + dy^2);
                        
                        D = x1*y2 - x2*y1;
                        del = r^2 * dr^2 - D^2;
                        if (del >= 0) && ...
                                ~( (sign(y1) == sign(y2)) && (abs(y1) >= r) && (abs(y2) >= r) ) && ...
                                ~( (sign(x1) == sign(x2)) && (abs(x1) >= r) && (abs(x2) >= r) )
                            obj.shadowing(tx_node,rx_node) = 1;
                        end
                    end
                    
                    % Make channel                    
                    obj.channelarray{tx_node,rx_node} = rayleighchan(1/fs,fd);
                    obj.channelarray{tx_node,rx_node}.ResetBeforeFiltering = 0;
                    obj.channelarray{tx_node,rx_node}.NormalizePathGains = 0;
                    obj.channelarray{tx_node,rx_node}.StorePathGains = 1;
                end
            end
        end
        
        function [ ] = single_tx(obj,tx_node,msg)
            tx_crc = step(obj.hCRC,msg);
            signal = step(obj.hmod,tx_crc);
            signal = signal*sqrt(obj.nodepower(tx_node)/sigpower(signal,obj.fs));
            
            for rx_node = 1:obj.nodenum
                if tx_node == rx_node
                    obj.errarray(rx_node) = NaN;
                    continue;
                end
                % Rayleigh channel
                obj.update_shadowing(tx_node,rx_node);
                obj.rcvarray{rx_node} = filter(obj.channelarray{tx_node,rx_node},signal);
                
                % AWGN
                SNR = 10*log10(sigpower(obj.rcvarray{rx_node},obj.fs)/obj.noisefloor);
                obj.rcvarray{rx_node} = awgn(obj.rcvarray{rx_node},SNR,'measured');
                
                % Demod and decode
                demod = step(obj.hdemod,obj.rcvarray{rx_node}./obj.channelarray{tx_node,rx_node}.PathGains);
                
                % Check CRC
                [~, obj.errarray(rx_node)] = step(obj.hdCRC,demod);
            end
        end
        
        function [ ] = alamouti_tx(obj, tx_node1, tx_node2, msg)
            tx_crc = step(obj.hCRC,msg);
            signal = step(obj.hmod,tx_crc);
            sig0 = signal(1:2:end);
            sig1 = signal(2:2:end);
            
            % Split signal
            sig0 = sig0*sqrt(obj.nodepower(tx_node1)/sigpower(sig0,obj.fs));
            sig1 = sig1*sqrt(obj.nodepower(tx_node2)/sigpower(sig1,obj.fs));
            
            % Perform Alamouti's encoding
            tx0 = upsample(sig0,2) + circshift(upsample(-conj(sig1),2),1);
            tx1 = upsample(sig1,2) + circshift(upsample(conj(sig0),2),1);
            
            for rx_node = 1:obj.nodenum
                if rx_node == tx_node1 || rx_node == tx_node2
                    obj.errarray(rx_node) = NaN;
                    continue;
                end
                
                % Rayleigh channel
                obj.update_shadowing(tx_node1,rx_node);
                obj.update_shadowing(tx_node2,rx_node);
                rx1 = filter(obj.channelarray{tx_node1,rx_node},tx0);
                rx2 = filter(obj.channelarray{tx_node2,rx_node},tx1);
                rx = rx1 + rx2;
                
                % AWGN
                SNR = 10*log10(sigpower(rx,obj.fs)/obj.noisefloor);
                obj.rcvarray{rx_node} = awgn(rx,SNR,'measured');
                
                % Decode Alamouti code
                r0 = obj.rcvarray{rx_node}(1:2:end);
                r1 = obj.rcvarray{rx_node}(2:2:end);
                h0 = obj.channelarray{tx_node1,rx_node}.PathGains(1:2:end);
                h1 = obj.channelarray{tx_node2,rx_node}.PathGains(1:2:end);
                s0 = conj(h0).*r0+(h1).*conj(r1);
                s1 = conj(h1).*r0-(h0).*conj(r1);
                
                % Demodulate signals
                msg1 = step(obj.hDemodSym,s0);
                msg2 = step(obj.hDemodSym,s1);
                
                % Recombine signals
                msg1 = upsample(msg1,2);
                msg2 = upsample(msg2,2);
                demod = msg1 + circshift(msg2,1);
                demod = dec2bin(demod)';
                demod = str2num(demod(:));

                % Check CRC
                [~, obj.errarray(rx_node)] = step(obj.hdCRC,demod);
            end
        end
        
        function [ status, div_node ] = adaptive_tx(obj,tx_node,dest_node,msg)
            div_node = 0;
            obj.single_tx(tx_node,msg)
            if obj.errarray(dest_node) == 0
                disp(['Direct transmission from node ' num2str(tx_node) ' to node ' num2str(dest_node) ' successful.']);
                status = 1;
            else
                disp(['Direct transmission from node ' num2str(tx_node) ' to node ' num2str(dest_node) ' failed.']);
                candidates = find(obj.errarray == 0);
                if isempty(candidates)
                    disp('No diversity candidates found.  Data was not sent successfully.');
                    status = -1;
                    return;
                else
                    if length(candidates) == 1
                        disp(['One candidate found: node ' num2str(candidates)]);
                        div_node = candidates;
                    else
                        disp(['Multiple candidates found: nodes ' num2str(candidates')]);
                        ii = randi(length(candidates),1,1);
                        div_node = candidates(ii);
                        disp(['Node ' num2str(div_node) ' selected randomly.']);
                    end
                    obj.alamouti_tx(tx_node,div_node,msg)
                end
                
                % Check if data was correct second time around
                if obj.errarray(dest_node) == 0
                    disp(['Diversity transmission from node ' num2str(tx_node) ' to node ' num2str(dest_node) ' successful.']);
                    status = 2;
                else
                    disp(['Diversity transmission from node ' num2str(tx_node) ' to node ' num2str(dest_node) ' failed.']);
                    status = -2;
                end
            end
        end
        
        function [ ] = update_shadowing(obj,tx_node,rx_node)
            dist = norm(obj.nodepos(tx_node,:) - obj.nodepos(rx_node,:));
            pathloss = -rf_pathloss(dist,obj.fc);
            if obj.shadowing(tx_node,rx_node) == 0
                shadow_loss = 0;
            elseif obj.shadowing(tx_node,rx_node) == 1
                gamma = 3.0;
                sigma = 7.0;
                shadow_loss = 10*gamma*log10(dist/1000) + normrnd(0,sigma);
            end
            obj.channelarray{tx_node,rx_node}.AvgPathGaindB = pathloss + shadow_loss; 
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
        
        function [ h ] = topology(obj)
            h = figure;
            grid on;
            xmax = max(obj.nodepos(:,1));
            xmin = min(obj.nodepos(:,1));
            ymax = max(obj.nodepos(:,2));
            ymin = min(obj.nodepos(:,2));
            xrange = xmax - xmin;
            yrange = ymax - ymin;
            change = 0.5*max(xrange,yrange);
            xmin = xmin - change;
            xmax = xmax + change;
            ymin = ymin - change;
            ymax = ymax + change;
            plot(obj.nodepos(:,1),obj.nodepos(:,2),'ks');
            if ~isempty(obj.shadowpos)
                viscircles(obj.shadowpos(:,1:2),obj.shadowpos(:,3),'EdgeColor','k','DrawBackgroundCircle',false);
            end
            text(obj.nodepos(:,1),obj.nodepos(:,2),num2str((1:length(obj.nodepos))'))
            axis([xmin xmax ymin ymax]);
            axis equal
            title('Network Topology')
        end
        
        function [ ] = single_trial(obj,tx_node,rx_node,trials)
            obj.status = zeros(trials,1);
            obj.div_node = zeros(trials,1);
            for trial = 1:trials
                disp(['Trial ' num2str(trial)]);
                msg = randi([0 1],2000*8,1);
                obj.reset();
                obj.single_tx(tx_node,msg);
                if obj.errarray(rx_node) == 0
                    obj.status(trial) = 1;
                elseif obj.errarray(rx_node) == 1
                    obj.status(trial) = -1;
                end
            end
        end
        
        function train(obj,tx_node,rx_node,trials)
            obj.status = zeros(trials,1);
            obj.div_node = zeros(trials,1);
            for trial = 1:trials
                disp(['Trial ' num2str(trial) ':']);
                msg = randi([0 1],2000*8,1);
                [obj.status(trial), obj.div_node(trial)] = obj.adaptive_tx(tx_node,rx_node,msg);
                obj.reset();
            end
        end
        
        function [ throughput ] = throughput(obj)
            throughput = sum(obj.status > 0)/sum(abs(obj.status));
        end
        
        function [ h ] = hist( obj )
            selected = [obj.div_node(obj.status == 2); obj.div_node(obj.status == -2)];
            success = obj.div_node(obj.status == 2);
            
            figure;
            hist(selected,1:length(obj.nodepos));
            h = findobj(gca,'Type','patch');
            set(h,'FaceColor',[0 .5 .5])
            hold on
            hist(success,1:length(obj.nodepos));
        end

    end
end