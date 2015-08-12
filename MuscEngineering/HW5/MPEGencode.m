function [obj ] = MPEGencode( song, obj, fs, compress )
%MPEG1 Layer 1 Encoder

load('filtercoeff.mat');

soundin = song(:,1);
obj.fs = fs;

% Preallocate
x = zeros(512,1);
ind = 1;
Sub = zeros(64,1);
Subsum = zeros(12,32);
SubAcc = [];
barloop = 0;
h = waitbar(0);

%% Polyphase Filter Bank

loop = 1;
while ind < length(soundin)-1024
    
    for frame = 1:12
        
        % Read in 32 at a time
        x(33:end) = x(1:end-32);
        x(1:32) = flipud(soundin(ind:ind+31));
        x = soundin((ind+511):-1:ind);

        % Window
        Z = x.*C;
        
        Y = zeros(8,1);
        Ysum = zeros(64,1);
        
        % Partial Calculation
        v = [0 1 2 3 4 5 6 7];
        for ii = 1:64
            for jj = 1:length(v)
                Y(jj) = Z(ii+64*v(jj));
            end
            Ysum(ii) = sum(Y);
        end
        
        % 32 Samples Matrixing
        for ii = 0:31
            Sub2 = [];
            for jj = 0:63
                Sub(jj+1) = cos((2*ii+1)*(jj-16)*pi/64).*Ysum(jj+1);
            end
            Subsum(frame,ii+1) = sum(Sub);
        end
        
        ind = ind+32;
    end
    
    obj.frames.data{loop} = Subsum;
    loop = loop + 1;
    
    if barloop > 8
        waitbar(ind/length(soundin),h,num2str(ind/length(soundin)*100));
        barloop = 0;
    end
    barloop = barloop + 1;
end
close(h)

%% Bit Allocation and Quantization

if compress > 0
    
    % Threshold model
    f = 1:obj.fs/2;
    Tf = 3.64*(f/1000).^-.8 - 6.5*exp(-.6*(f/1000-3.3).^2)+10e-3*(f/1000).^4;
    
    bands = round(linspace(1, obj.fs/2, 32));
    SNRbits = 16-round((Tf(bands)+1.25)/6);
    SNRbits(1:3) = 16;
    SNRbits(SNRbits<4) = 4;
    bitsaved = 16*32 - sum(SNRbits);
    total = length(obj.frames.data)*bitsaved;
    total2 = length(obj.frames.data)*16*32;
    
    for jj = 1:length(obj.frames.data)
        
        % Signs
        signs = sign(obj.frames.data{jj});
        obj.frames.sign{jj} = signs;
        
        % Gains
        framemax = max(max(abs(obj.frames.data{jj})));
        numbits = 16;
        maxvalue = 2^(numbits)-1;
        gain = floor(maxvalue/framemax);
        obj.frames.gain{jj} = gain;
        buffer1 = round(abs(obj.frames.data{jj}*gain));
        
        % Convert to binary and Quantize Based on SNR
        for ii = 1:32;
            buffermid = de2bi(buffer1(:,ii),numbits,'left-msb');
            buffermid = buffermid(:,numbits-SNRbits(ii)+1:end);
            obj.frames.compressed{jj,ii} = buffermid;
        end
    end
    disp(['A total of ' num2str(total) ' bits were compressed out of ' num2str(total2) ' bits.']);
    disp(['That is ' num2str(total/total2*100) ' % compression.']);
    disp('The default data rate is 705.6 kbps.')
    disp(['The compressed data rate is ' num2str(44100/384*bitsaved*16/1000) ' kbps.'])
else
    obj.frames.compressed = [];
    disp('The default data rate is 705.6 kbps.')
    disp('With no compression, the output data rate is 705.6 kbps.')
end

end

