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
pos = grid_network(4,4,50);
shadow = [100 50 25];
nn = NodeNetwork(pos, txpwr, fc, fs, fd, noisefloor,shadow);


%%
trials = 10;
status = zeros(trials,1);
div_node = zeros(trials,1);

for ii = 1:trials
    disp(['Trial ' num2str(ii) ':']);
    msg = randi([0 1],2000*8,1);
    [status(ii), div_node(ii)] = nn.adaptive_tx(1,11,msg);
    nn.reset();
    fprintf('\n');
end

fail0 = sum(status == 0);
fail1 = sum(status == -1);
fail = sum( [fail0; fail1] );
success1 = sum(status == 1);
success2 = sum(status == 2);
success = sum( [success1; success2] );
disp( 'Statistics:' )
disp( [num2str(100*success/trials) '% success rate (' num2str(success) '/' num2str(trials) ')']);
disp( [' - Direct transmission accounted for ' num2str(100*success1/success) '% (' num2str(success1) '/' num2str(success) ') of successful transmissions.']);
disp( [' - Diversity transmission accounted for ' num2str(100*success2/success) '% (' num2str(success2) '/' num2str(success) ') of successful transmissions.']);
disp( [num2str(100*fail/trials) '% failure rate (' num2str(fail) '/' num2str(trials) ')']);
disp( [' - Failure to find diversity candidates accounted for ' num2str(100*fail1/fail) '% (' num2str(fail1) '/' num2str(fail) ') of failed transmissions.']);
disp( [' - Failure in transmission with diversity accounted for ' num2str(100*fail0/fail) '% (' num2str(fail0) '/' num2str(fail) ') of failed transmissions.']);


%%
% div_success = zeros(length(pos),1);
% div_failure = zeros(length(pos),1);
% for node = 1:length(pos)
%     div_success(node) = sum( div_node(status == 2) == node)./success;
%     div_failure(node) = sum( div_node(status == 0) == node)./(trials - success);
% end
% 
% figure;
% grid on
% viscircles(pos,ones(length(pos),1));
% viscircles(pos,100*div_success);
% title('Successful diversity transmission rates per node')
% 
% figure;
% grid on
% viscircles(pos,ones(length(pos),1));
% viscircles(pos,100*div_failure);
% title('Failed diversity transmission rates per node')

selected = [div_node(status == 2); div_node(status == 0)];
success = div_node(status == 2);

figure;
hist(selected,1:length(pos))
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0 .5 .5])
hold on
hist(success,1:length(pos))
