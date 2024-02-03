function [env] = trace2envelope(signal)
pkg load signal

t = signal(:,1);
s = signal(:,2:end);

envPositive = [t abs(hilbert(s))];
envNegative = [t -abs(hilbert(-s))];
env = [envPositive;flipud(envNegative)];

pkg unload signal
end
