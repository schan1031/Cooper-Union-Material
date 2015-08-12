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

pos = grid_network(2,2,50);
noisefloors = -70:-1:-90;
trials = 1000;

ideall = ones(4,4,2);
ideall(1,2,1) = 0;
ideall(1,2,2) = 1000;
ideall(1,3,2) = 1000;

[throughput_direct, throughput_diversity, throughput_l, throughput_l_prior, throughput_direct_shadow, throughput_diversity_shadow] = deal(zeros(length(noisefloors),1));
for ii = 1:length(noisefloors)
    noisefloor = (10^(noisefloors(ii)/10))*1e-3;
    %%
    shadow = [];
    nn = NodeNetwork(pos, txpwr, fc, fs, fd, noisefloor,shadow);
    
    nn.single_trial(1,4,trials);
    throughput_direct(ii) = nn.throughput;
    
    nn.train(1,4,trials);
    nn.likelihoodflag = 0;
    throughput_diversity(ii) = nn.throughput;
    
    
    %%
    shadow = [25 50 10];
    nn = NodeNetwork(pos, txpwr, fc, fs, fd, noisefloor,shadow);
    
    nn.single_trial(1,4,trials);
    throughput_direct_shadow(ii) = nn.throughput;
    
    nn.likelihoodflag = 0;
    nn.train(1,4,trials);
    throughput_diversity_shadow(ii) = nn.throughput;
    
    nn.likelihoodflag = 1;
    nn.likelihood = ideall;
    nn.train(1,4,trials);
    throughput_l_prior(ii) = nn.throughput;
    
    nn.likelihoodflag = 1;
    nn.gen_likelihood(1,0,0);
    nn.train(1,4,trials);
    throughput_l(ii) = nn.throughput;
    
end

h = figure;
plot(noisefloors,throughput_direct,noisefloors,throughput_diversity,noisefloors,throughput_direct_shadow,noisefloors,throughput_diversity_shadow,noisefloors,throughput_l,noisefloors,throughput_l_prior);
legend('Direct transmission','Cooperative diversity transmission','Direct transmission with shadowing','Cooperative diversity transmission with shadowing','Cooperative diversity building knowledge of costs','Cooperative diversity with prior knowledge of costs')
title('Comparison of the throughput for direct and cooperative diversity transmission schemes with and without shadowing in the main transmit channel')
xlabel('Noise level (dBm)')
ylabel('Bandwidth utilization efficiency')

savefig(h,'throughput_4n_figure')