% Machine Learning Sequential Estimation
% Neema Aggarwal, Spencer Chan, Kelvin Lin
% Sept 23, 2014
% implement sequential estimators for Binomial and Gaussian random
% variables
clc; clear all; close all;
% Binomial Sequential Estimator
p = 0.3;
N = 1e5;
n = 1e3;
xmlb = zeros(1,n);
samplesb = binornd(N,p,[n,1]);
for ii = 2:n
    xmlb(ii) = xmlb(ii-1) + 1/ii*(samplesb(ii) - xmlb(ii-1));
end
MSEb = (xmlb - N*p).^2;
figure
semilogy(1:n,MSEb);

% Gaussian Sequential Estimator
m = 3;
var = 3;
N = 10000;
xmlg = zeros(N,n);

samplesg = zeros(N,n);
for jj = 1:N
    samplesg(jj,1:end) = normrnd(m,var,[n,1]);
    for ii = 2:n
        xmlg(jj,ii) = xmlg(jj,ii-1) + 1/ii*(samplesg(jj,ii) - xmlg(jj,ii-1));
    end
end
xmlg2 = mean(xmlg,1);
MSEg = (xmlg2-m).^2;
figure
semilogy(1:n,MSEg);

%% Conjugate Prior binomial
% Plotting MSE and prior to posterior
n = 100;
N = 1000;
a = 2;
b = 1;
m = 3;
l = 1;
x = linspace(0,1,n);
estimate = zeros(N,n);
data2 = zeros(N,n);

figure
data = binornd(1,0.5,[1 n]);
for ii = 1:n
    m = sum(data(1:ii));
    l = ii-m;
    p = betapdf(x,a+m,b+l);
    plot(x,p); 
    pause(0.02);
end

for jj = 1:N
    data2(jj,1:end) = binornd(1,0.5,[1 n]);
    for ii = 1:n
        m = sum(data2(jj,1:ii));
        l = ii-m;
        p = betapdf(x,a+m,b+l);
        estimate(jj,ii) = (m+a)/(m+a+l+b);
    end
end
figure
estimate2 = mean(estimate,1);
MSEbip = (estimate2 - 0.5).^2;
semilogy(x,MSEbip)

%% Conjugate Prior gaussian
% Plotting MSE
muo = 1; % prior, hyperparameters
varo = 1;
mu = 2; % distribution parameters
var = 2;
n = 1e3; % total number of samples
r=1000;

mun = zeros(r,n);
muml = zeros(r,n);
xmlgp = zeros(1,n);
n2 = zeros(r,n);

for jj = 1:r
n2(jj,1:end) = mu + var*randn(1,n);

for ii = 1:n
    
    muml(jj,ii) = 1/ii.*sum(n2(jj,1:ii));
    
    mun(jj,ii) = var/(ii*varo+var)*muo+ii*varo/(ii*varo+var)*muml(jj,ii);
    varn(ii) = 1/(1/varo + ii/var);
    
end
end
mun2 = mean(mun,1);
MSEgp = (mun2-mu).^2;
figure
semilogy(1:n,MSEgp)


