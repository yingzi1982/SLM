function [env] = trace2envelope(signal,np)
pkg load signal

t = signal(:,1);
s = signal(:,2:end);

envPositive = [t abs(hilbert(s))];
%envPositive([1,end],:) = [];
envNegative = [t -abs(hilbert(-s))];
%envNegative([1,end],:) = [];
env = [envPositive;flipud(envNegative)];
env = resample(env,np,length(env));

pkg unload signal
end
