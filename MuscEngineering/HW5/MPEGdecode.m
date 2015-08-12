function [ SubAcc] = MPEGdecode( obj )
%MPEGDecoder Layer 1
    
load('filtdecodecoeff.mat');
ind = 0;
V = zeros(1024,1);
V2 = zeros(32,1);
U = zeros(512,1);
Sout = V2;
SubAcc = zeros(length(obj.frames.data)*32,1);
W2 = zeros(16,1);
loop = 0;
barloop = 0;
h=waitbar(0);
Enc = [];

if isempty(obj.frames.compressed)
    for i = 1:length(obj.frames.data)
        z = obj.frames.data{1,i};
        Enc = [Enc; z];
    end
else
    Tmp2 = zeros(12,32);
    for ii = 1:length(obj.frames.compressed)
        for jj = 1:32
            Tmp = bi2de(obj.frames.compressed{ii,jj},'left-msb');
            Tmp2(:,jj) = Tmp;
        end
        obj.frames.data{ii} = Tmp2./obj.frames.gain{ii}.*obj.frames.sign{ii};
    end
    for i = 1:length(obj.frames.data)
        z = obj.frames.data{1,i};
        Enc = [Enc; z];
    end
end

%%
for ind = 1:length(Enc)
    
    % Fill in 64
    S = Enc(ind,:);
    tmpV = zeros(64,1);
    for ii = 0:63
        kk = 0:31;
        V2 = sum(cos((16+ii)*(2*kk+1)*pi/64).*S);
        tmpV(ii+1) = sum(V2);
    end
    V = [tmpV; V(1:end-64)];
    
    % Build Value Vector U
    for ii = 0:7
        for jj = 1:32
            U(ii*64+jj) = V(ii*128+jj);
            U(ii*64+32+jj) = V(ii*128+96+jj);
        end
    end
    
    % Window
    W = U.*D;
    
    % 32 Samples
    for jj = 0:31
        for ii = 0:15
            W2(ii+1) = W(jj+1+32*ii);
        end
        Sout(jj+1) = sum(W2);
    end
    
    % SubAcc = [SubAcc; Sout];
    SubAcc(loop*32+1:loop*32+32) = Sout;
    loop = loop + 1;
    
    if barloop > 32
        waitbar(ind/length(Enc),h,num2str(ind/length(Enc)*100));
        barloop = 0;
    end
    barloop = barloop+1;
    
end
close(h)


end

