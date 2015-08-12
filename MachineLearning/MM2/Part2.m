clc; clear all; close all;

x = 0:.01:1;
green = sin(2*pi*x);

noise = .25*randn(1,length(green));
data = green+noise;
n1 = randi([1 length(data)],1,1);

%%
% 1 Sample

subplot(2,2,1);
axis([0,1,-1.5,1.5])
hold on;
plot(x,green,'g')
plot(x(n1),data(n1),'x')

% 2 Samples

subplot(2,2,2);
axis([0,1,-1.5,1.5])
hold on;
plot(x,green,'g')

n2 = [n1 randi([1 length(data)],1,1)];
subplot(2,2,2);
plot(x(n2),data(n2),'x')

% 4 Samples

subplot(2,2,3);
axis([0,1,-1.5,1.5])
hold on;
plot(x,green,'g')

n3 = [n2 randi([1 length(data)],1,2)];
subplot(2,2,3);
plot(x(n3),data(n3),'x')

% 25 Samples

subplot(2,2,4);
axis([0,1,-1.5,1.5])
hold on;
plot(x,green,'g')

n4 = [n3 randi([1 length(data)],1,21)];
subplot(2,2,4);
plot(x(n4),data(n4),'x')

%% Bases
s = 2.5;
mu = [0:.05:0.4];
phi1 = zeros(1,9);
phi1 = exp(-(x(n1)-mu).^2/(2*s^2));

phi2 = zeros(length(n2),9);
for ii = 1:length(n2)
    phi2(ii,:) = exp(-(x(n2(ii))-mu).^2/(2*s^2));
end

phi3 = zeros(length(n3),9);
for ii = 1:length(n3)
    phi3(ii,:) = exp(-(x(n3(ii))-mu).^2/(2*s^2));
end

phi4 = zeros(length(n4),9);
for ii = 1:length(n4)
    phi4(ii,:) = exp(-(x(n4(ii))-mu).^2/(2*s^2));
end

%% 
beta = 16;
alpha = 2;
sphi1 = phi1';
sphi2 = phi2';

sn1 = (alpha*eye(9) + beta*phi1'*phi1)^-1;
mn1 = beta*sn1*sphi1*data(n1);

mean1 = mn1'*sphi1;
var1 = 1/beta + sphi1'*sn1*sphi1;
pred1 = normpdf(x,mean1,var1);
subplot(2,2,1)
hold on;
plot(x,pred1)
