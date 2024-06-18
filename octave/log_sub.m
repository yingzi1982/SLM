function LOG_SUB= log_sub(v2,v1)

LOG_SUB = 10*log10(10.^(v2/10) - 10.^(v1/10));
