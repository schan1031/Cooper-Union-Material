clear all;
clc;

addpath fcns;

fs = 1e6;
fc = 2.4e9;
c = 3e8;
wl = c/fc;
power = .1;
noisefloor = (10^(-60/10))*1e-3; % Noise floor of -60 dBm

nodearray = { ...
    Node(1,0,fs,power); ...
    Node(2,10,fs,power); ...
    Node(3,20,fs,power); ...
    Node(4,30,fs,power); ...
    Node(5,40,fs,power); ...
    };

% ch12 = Channel(n1,n2,fc,fs,100,noisefloor);
% ch13 = Channel(n1,n3,fc,fs,100,noisefloor);
% ch14 = Channel(n1,n4,fc,fs,100,noisefloor);
% ch15 = Channel(n1,n5,fc,fs,100,noisefloor);

channelcell = ChannelCell(nodearray,fc,fs,100,noisefloor);

msg = randi([0 1],1024,1);
[err2, err3, err4, err5] = deal(zeros(1,100));
for ii=1:100
    disp(ii);
%     ch12.chreset();
%     ch13.chreset();
%     ch14.chreset();
%     ch15.chreset();
    channelcell.reset();
    [~,err2(ii)] = channelcell.tx(1,2,msg);
    [~,err3(ii)] = channelcell.tx(1,3,msg);
    [~,err4(ii)] = channelcell.tx(1,4,msg);
    [~,err5(ii)] = channelcell.tx(1,5,msg);
end

sum(err2)
sum(err3)
sum(err4)
sum(err5)