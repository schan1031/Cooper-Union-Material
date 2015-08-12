clc; clear all; close all;

for k = 1:2;
    transmit = sprintf('trans%d.mat',k);
    if exist(transmit, 'file')
        data = load(transmit);
    else
        fprintf('File DNE \n', transmit);
    end
end


%%

