function [data]=matrix_standardization(data)
% standardize the input matrix to [0 1] according to the minimum and maximum value
baseline=min(data(:));
range=max(data(:))-baseline;
data=(data-baseline)./range;
