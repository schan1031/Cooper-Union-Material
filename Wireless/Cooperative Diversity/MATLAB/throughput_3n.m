close all;
clear all;
clc;

addpath fcns;

fs = 1e6;
fc = 2.4e9;
fd = 100;
c = 3e8;
wl = c/fc;
noisefloor = (10^(-77/10))*1e-3;
txpwr = 0.1;

pos = [0 0; 50 0; 25 25*sqrt(3)];
noisefloors = -70:-1:-90;
trials = 1000;

[throughput_direct, throughput_diversity, throughput_direct_shadow, throughput_diversity_shadow] = deal(zeros(length(noisefloors),1));
for ii = 1:length(noisefloors)
    noisefloor = (10^(noisefloors(ii)/10))*1e-3;
    shadow = [];
    nn = NodeNetwork(pos, txpwr, fc, fs, fd, noisefloor,shadow);
    nn.single_trial(1,3,trials);
    throughput_direct(ii) = nn.throughput;
    nn.train(1,3,trials);
    throughput_diversity(ii) = nn.throughput;
    
    shadow = [12.5 12.5*sqrt(3) 5];
    nn = NodeNetwork(pos, txpwr, fc, fs, fd, noisefloor,shadow);
    nn.single_trial(1,3,trials);
    throughput_direct_shadow(ii) = nn.throughput;
    nn.train(1,3,trials);
    throughput_diversity_shadow(ii) = nn.throughput;
end

h = figure;
plot(noisefloors,throughput_direct,noisefloors,throughput_diversity,noisefloors,throughput_direct_shadow,noisefloors,throughput_diversity_shadow);
legend('Direct transmission','Cooperative diversity transmission','Direct transmission with shadowing','Cooperative diversity transmission with shadowing')
title('Comparison of the throughput for direct and cooperative diversity transmission schemes with and without shadowing in the main transmit channel')
xlabel('Noise level (dBm)')
ylabel('Bandwidth utilization efficiency')

savefig(h,'throughput_3n_figure')