function SPL_SUM= spl_sum(varargin)

spl= varargin{1};

SPL_SUM = 10*log10(sum(10.^(spl/10)));
