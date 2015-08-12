clear buffer1 SNR

% Threshold model
f = 1:enc2.fs/2;
Tf = 3.64*(f/1000).^-.8 - 6.5*exp(-.6*(f/1000-3.3).^2)+10e-3*(f/1000).^4;

SNRbits = [];
bands = round(linspace(1, enc2.fs/2, 32));
for ii = 1:31
SNRbitsa = 16-round((Tf(bands(ii)+345)+1.25)/6);
SNRbitsb = 16-round((Tf(bands(ii+1)-345)+1.25)/6);
SNRbits = [SNRbits max([SNRbitsa SNRbitsb])];
end
% SNRbits = max([SNRbitsa; SNRbitsb]);
% SNRbits(1) = 16;
SNRbits(SNRbits<2) = 2;

%%

for jj = 1:length(enc2.frames.data)

% Signs
buffer2 = sign(enc2.frames.data{jj});
enc2.frames.sign{jj} = buffer2;
% buffer2(buffer2==-1) = 0;

framemax = max(max(abs(enc2.frames.data{jj})));
numbits = 16;
maxvalue = 2^(numbits)-1;
gain = floor(maxvalue/framemax);

buffer1 = round(abs(enc2.frames.data{jj}*gain));

for ii = 1:32;
    buffermid = de2bi(buffer1(:,ii),numbits,'left-msb');
    buffermid = buffermid(:,numbits-SNRbits(ii)+1:end);
    enc2.frames.compressed{jj,ii} = buffermid;
end

end

% % buffer1(:,16-bitscut+1:16) = 0;
% % buffer1 = bi2de(buffer1,'left-msb');
% shaped = reshape(buffer1,12,32);
% final = shaped/gain;

%%
Tmp2 = zeros(12,32);
for ii = 1:length(enc2.frames.compressed)
    for jj = 1:32
        Tmp = bi2de(enc2.frames.compressed{ii,jj},'left-msb');
        Tmp2(:,jj) = Tmp;
    end
    enc2.frames.data{ii} = Tmp2/enc2.frames.gain{ii};
end
