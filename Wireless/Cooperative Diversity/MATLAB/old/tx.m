function [ rcv, err ] = tx( tx_node, rx_node, channel, msg )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    [rcv, err] = rx_node.recieve(channel.chfilter(tx_node.send(msg)),channel.rchan.PathGains);
end
