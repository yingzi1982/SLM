function LOG_SUM= log_sum(varargin)

v= varargin{1};

LOG_SUM = 10*log10(sum(10.^(v/10)));
