function [ h ] = nn_hist( obj )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
selected = [obj.div_node(obj.status == 2); obj.div_node(obj.status == -2)];
success = obj.div_node(obj.status == 2);

figure;
hist(selected,1:length(obj.nodepos))
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0 .5 .5])
hold on
hist(success,1:length(obj.nodepos))


end

