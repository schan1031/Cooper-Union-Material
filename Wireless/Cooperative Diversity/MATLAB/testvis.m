clc; clear all; close all;

addpath fcns;

fs = 1e6;
fc = 2.4e9;
fd = 100;
c = 3e8;
wl = c/fc;
noisefloor = (10^(-77/10))*1e-3;
txpwr = 0.1;
pos = grid_network(3,3,50);
shadow = [100 50 25];
nn = NodeNetwork(pos, txpwr, fc, fs, fd, noisefloor,shadow);

%% 
tx_node = 1;
dest_node = 9;
nn.topology;
hold on
axis([-75 175 -50 150])

for trials = 1:15
    msg = randi([0 1],2000*8,1);
    div_node = 0;
    nn.single_tx(tx_node,msg)
    pause(.5)
    if nn.errarray(dest_node) == 0
        disp(['Direct transmission from node ' num2str(tx_node) ' to node ' num2str(dest_node) ' successful.']);
        status = 1;
        a = viscircles(nn.nodepos(dest_node,:),5);
        b = plot([nn.nodepos(tx_node,1) nn.nodepos(dest_node,1)], [nn.nodepos(tx_node,2) nn.nodepos(dest_node,2)],'g');
        pause(1)
        delete(a)
        delete(b)
    else
        a = viscircles(nn.nodepos(dest_node,:),5);
        b = plot([nn.nodepos(tx_node,1) nn.nodepos(dest_node,1)], [nn.nodepos(tx_node,2) nn.nodepos(dest_node,2)],'r');
        pause(1)
        delete(a)
        delete(b)
        disp(['Direct transmission from node ' num2str(tx_node) ' to node ' num2str(dest_node) ' failed.']);
        candidates = find(nn.errarray == 0);
        if isempty(candidates)
            disp('No diversity candidates found.  Data was not sent successfully.');
            status = -1;
            continue;
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
            a = viscircles(nn.nodepos(div_node,:),5);
            b = plot([nn.nodepos(tx_node,1) nn.nodepos(div_node,1)], [nn.nodepos(tx_node,2) nn.nodepos(div_node,2)]);
            pause(1)
            delete(a)
            delete(b)
            nn.alamouti_tx(tx_node,div_node,msg)
        end
        
        % Check if data was correct second time around
        if nn.errarray(dest_node) == 0
            disp(['Diversity transmission from node ' num2str(tx_node) ' to node ' num2str(dest_node) ' successful.']);
            status = 2;
            a = viscircles(nn.nodepos(dest_node,:),5);
            b = plot([nn.nodepos(div_node,1) nn.nodepos(dest_node,1)], [nn.nodepos(div_node,2) nn.nodepos(dest_node,2)],'g');
            c = plot([nn.nodepos(tx_node,1) nn.nodepos(dest_node,1)], [nn.nodepos(tx_node,2) nn.nodepos(dest_node,2)],'g');
            pause(1)
            delete(a)
            delete(b)
            delete(c)
        else
            disp(['Diversity transmission from node ' num2str(tx_node) ' to node ' num2str(dest_node) ' failed.']);
            status = 0;
            a = viscircles(nn.nodepos(dest_node,:),5);
            b = plot([nn.nodepos(div_node,1) nn.nodepos(dest_node,1)], [nn.nodepos(div_node,2) nn.nodepos(dest_node,2)],'r');
            c = plot([nn.nodepos(tx_node,1) nn.nodepos(dest_node,1)], [nn.nodepos(tx_node,2) nn.nodepos(dest_node,2)],'r');
            pause(1)
            delete(a)
            delete(b)
            delete(c)
        end
    end
    nn.reset();
    fprintf('\n');
end
