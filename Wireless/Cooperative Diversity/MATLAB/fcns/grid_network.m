function [ pos ] = grid_network( m, n, d )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    pos = zeros(m*n,2);
    count = 1;
    for x = 0:m-1
        for y = 0:n-1
            pos(count,:) = [d*x d*y];
            count = count + 1;
        end
    end
end

