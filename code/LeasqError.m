function [pErr, ChiSqr] = LeasqError(covp,covr)
[N_param,~] = size(covp);
N_datapoints = length(covr);
degrees_of_freedom = N_datapoints - N_param;

ChiSqr = 1/(degrees_of_freedom) * sum(covr);

pErr = sqrt(diag(covp)*ChiSqr);