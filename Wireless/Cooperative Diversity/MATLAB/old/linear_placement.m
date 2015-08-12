clear all;
clc;

fs = 1e6;
fc = 2.4e9;
c = 3e8;
wl = c/fc;
SNR = 10;


n1 = Node(1,0,fs);
n2 = Node(2,10,fs);
n3 = Node(3,20,fs);
n4 = Node(4,30,fs);
n5 = Node(5,40,fs);
ch12 = Channel(n1,n2,fc,1/fs,130,SNR);
ch13 = Channel(n1,n3,fc,1/fs,130,SNR);
ch14 = Channel(n1,n4,fc,1/fs,130,SNR);
ch15 = Channel(n1,n5,fc,1/fs,130,SNR);

msg = randi([0 1],100,1);
[err2, err3, err4, err5] = deal(zeros(1,100));
for ii=1:100
    disp(ii);
    [~,err2(ii)] = tx(n1,n2,ch12,msg);
    [~,err3(ii)] = tx(n1,n3,ch13,msg);
    [~,err4(ii)] = tx(n1,n4,ch14,msg);
    [~,err5(ii)] = tx(n1,n5,ch15,msg);
end

sum(err2)
sum(err3)
sum(err4)
sum(err5)