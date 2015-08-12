function [output]=distortion(constants,inSound,gain,tone)
%DISTORTION applies the specified gain to inSound, then applies clipping
%according to internal parameters and filtering according to the specified
%tone parameter

% Modeled from DAFX:Digital Audio Effects, Schetzen formula

sound = inSound;
copy = sound;
thresh = max(abs(sound))/gain;

for ii = 1:length(inSound);
    if abs(sound(ii))<thresh
        copy(ii) = 2*copy(ii);
    elseif abs(sound(ii))>=thresh
        if copy(ii) > 0
            copy(ii) = (3 - (2-copy(ii)*3).^2)/3;
        else
            copy(ii) = -(3 - (2-abs(copy(ii))*3).^2)/3;
        end
    elseif abs(sound(ii))>2*thresh;
        if copy(ii) > 0
            copy(ii) = copy(ii);
        else
            copy(ii) = -copy(ii);
        end
    end
end

output = sound + copy;

fn=constants.fs/2;
fc=5000 + tone*5000;
[b,a]=butter(2,fc/fn);
output=filter(b,a,output);

end