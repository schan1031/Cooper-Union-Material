function [ y ] = repdecode( x, N )
    y = reshape(x,N,length(x)/N);
    y = sum(y);
    y = (y>N/2)';
end

