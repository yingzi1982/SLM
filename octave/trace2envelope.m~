function [env] = trace2envelope(signal,np)
pkg load signal

t = signal(:,1);
%t = t-t(1);

s = signal(:,2:end);

envPositive = abs(hilbert(s));
envNegative = abs(hilbert(-s));
env = [envPositive;flipud(-envNegative)];

%env = env/max(abs(env(:)));

t = [t;flipud(t)];
env =[t env];

resampleRate = floor(rows(s)/np);
env = env(1:resampleRate:end,:);

pkg unload signal
end
