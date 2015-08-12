function [output]=delay(constants,inSound,depth,delay_time,feedback)
%DELAY applies a delay effect to inSound which is delayed by delay_time 
% then added to the original signal according to depth and passed back as
% feedback with the feedback gain specified

zeropad = delay_time*constants.fs;
soundsize = size(inSound);
sound = inSound';
count = 0;
amp = feedback;

if feedback >= 1
    error('Feedback of 1 or higher will go infinitely')
end

if feedback >0
    while amp > 1/25
        amp = amp*feedback;
        count = count + 1;
    end
else
    count = 1;
end

numloops = count;
Acc = zeros(soundsize(2),length(inSound)+zeropad*numloops);
Acc = [sound zeros(soundsize(2),zeropad*numloops)] + Acc;
sizeAcc = length(Acc);

for ii = 1:numloops
    delay = (feedback^(ii-1))*depth*[zeros(soundsize(2),zeropad*ii) sound];
    Acc = Acc + [delay zeros(soundsize(2),sizeAcc-length(delay))];
end

output = Acc;

end