% Mini Matlab 4
% Kelvin Lin, Neema Aggarwal, Spencer Chan
%% Part 1
clc; clear all; close all;

x = 0:.01:1;
x = x.';
green = sin(2*pi*x);
noise = .25*randn(1,length(green)).';
data = green+noise;

% 1 Sample

n1 = randi([1 length(data)],1,1);
% 2 Samples
n2 = [n1 randi([1 length(data)],1,1)];
% 4 Samples
n3 = [n2 randi([1 length(data)],1,2)];
% 25 Samples
n4 = [n3 randi([1 length(data)],1,21)];

n = {n1,n2,n3,n4};

mean = [];
s = 0.25;
lambda = 0.2;
for i1 = 1:4
   m = [];
   nn = cell2mat(n(i1));
   [xx,xy] = meshgrid(x(nn),x(nn));
   K = exp(-abs(xx-xy).^2/2/s^2);
   
   for i2 = 1:length(x)      
       k = exp(-abs(x(nn)-x(i2)).^2/2/s^2);
       y = k.'*(K+lambda*eye(size(K)))^-1*data(nn);
       m = [m,y];
   end
   mean = [mean;m];
end

figure;

for ii = 1:4
   nn = cell2mat(n(ii));
   subplot(2,2,ii); hold on;
   plot(x,green,'g')
   plot(x,mean(ii,:),'r')
   plot(x(nn),data(nn),'o')   
end

%% Part 2
n2 = randi([1 length(data)],1,7);
xn = x(n2)';
datan = data(n2)';
x2 = x(randi([1 length(data)],1,1));
beta = 25;
s = .25;

[xx,xy] = meshgrid(xn,xn);
C = exp(-abs(xx-xy).^2/(2*s^2)) + 1/beta*eye(size(xx));

mu = [];
sigma = [];
for ii = 1:length(x)
    x2 = x(ii);
    k = exp(-abs(xn-x(ii)).^2/(2*s^2));
    mu = [mu k*inv(C)*datan'];
    c = exp(-abs(x2-x2).^2/2/s^2) + inv(25);
    sig = c - k*inv(C)*k.';
    sigma = [sigma sig];
end;
a = mu + 2*sqrt(sigma);
b = mu - 2*sqrt(sigma); 

figure; hold on;
h = fill([x' fliplr(x')], [a fliplr(b)], 'r');
set(h,'facealpha',0.3)
plot(x,green,'g')
plot(xn,datan,'o')
plot(x,mu,'r')
