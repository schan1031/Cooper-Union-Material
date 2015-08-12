function [ y ] = repcode( x, N )
    y = repmat(x,1,N);
    y = reshape(y',length(x)*N,1);
end

