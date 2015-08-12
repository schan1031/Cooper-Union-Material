function [] = CREngine2( varargin )
%(M,fsep,nsamp,Fs,ups,msg)
%CREngine2(16,8,16,120,10,randi([0 1],1,25));
%CREngine2(16,8,16,120,10,randi([0 1],1,25),16,8,16,120,10,randi([0 1],1,25));
% Organize inputs
a = length(varargin);
var = reshape(varargin,6,a/6)';
var = cell2mat(var);
varsize = size(var);

% Deal Single Constants
[M, fsep, nsamp, Fs, ups] = deal(ones(a,1));
M = var(:,1)
fsep = var(:,2)
nsamp = var(:,3)
Fs = var(:,4)
ups = var(:,5)

% Extract messages
msg = var(:,6:end)

msglength = length(msg);
[msgext] = deal([])

varsize(1)
msglength

% Repetition and Modulate

for i = 1:varsize(1)
    for j = 1:msglength
        msgext = [msgext msg(i,j)*ones(1,ups(i)*nsamp(i))];
    end
end
size(msgext)
msglength*ups(1)*nsamp(1)
msgext = reshape(msgext,msglength*ups(1)*nsamp(1),varsize(1))';
msgmod = qammod(msgext,4);
size(msgmod)
x=1;

for x = 1:10
% Tones
b = Fs(1)/fsep(1);
tone = randi([0 b], varsize(1), msglength);
tonext = [];
for i = 1:varsize(1)
    for j = 1:msglength
        tonext = [tonext tone(i,j)*ones(1,ups(i))];
    end
end
tonext = reshape(tonext,msglength*ups(1),varsize(1))';

sizetone = size(tonext)

carrier = ones(2,msglength*ups(1)*nsamp(1));

for i = 1:varsize(1)
    carrier(i,:) = fskmod(tonext(i,:),M(1),fsep(1),nsamp(1),Fs(1));
end
size(carrier)

if varsize(1) > 1
    tx = msgmod(1,:).*carrier(1,:) + msgmod(2,:).*carrier(2,:);
else
    tx = msgmod(1,:).*carrier(1,:);
end
tx = awgn(tx,45,'measured');

spectrogram(tx,64,[],[],Fs(1),'yaxis')
pause(1)
x = x+1
end

end