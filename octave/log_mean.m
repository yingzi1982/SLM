function LOG_MEAN= log_mean(varargin)

v= varargin{1};

if (nargin == 1)
  duration = ones(size(v));
elseif (nargin == 2)
  duration = varargin{2}
end
duration_weight = duration/sum(duration);

LOG_MEAN = 10*log10(sum(10.^(v/10).*duration_weight));
