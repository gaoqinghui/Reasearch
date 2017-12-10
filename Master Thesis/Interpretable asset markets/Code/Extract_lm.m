function [ t1, r_2, t2 ] = Extract_lm( mdl )
% Summary of this function goes here
%   Detailed explanation goes here
%   Extract the t-value and R-square of the mdl

t1 = mdl.Coefficients.tStat(2);
r_2 = mdl.Rsquared.Adjusted;

if nargout >= 3
    t2 = mdl.Coefficients.tStat(3);
end

end

