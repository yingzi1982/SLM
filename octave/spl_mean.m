function SPL_MEAN= spl_mean(varargin)

spl= varargin{1};

if (nargin == 1)
  duration = ones(size(spl));
elseif (nargin == 2)
  duration = varargin{2}
end
duration_weight = duration/sum(duration);

SPL_MEAN = 10*log10(sum(10.^(spl/10).*duration_weight));
