function [env] = trace2envelope(signal,np)
pkg load signal

t = signal(:,1);
s = signal(:,2:end);

envPositive = abs(hilbert(s));
envNegative = -abs(hilbert(-s));

envPositiveResample = resample(envPositive,np,length(envPositive));
envNegativeResample = resample(envNegative,np,length(envNegative));
envResample = [envPositiveResample;flipud(envNegativeResample)];

tResample = resample(t,np,length(t));
tResample = [tResample;flipud(tResample)];

env =[tResample envResample];

pkg unload signal
end
