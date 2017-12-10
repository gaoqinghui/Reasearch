function [ result ] = pred_sum_GR( GR_data, VR_data)
% Summary of this function goes here
%   Detailed explanation goes here
%   table 6, predicting future growth rate by VR

sum_GR.lag4 = [gen_sum_J(GR_data, 4); ones(4,1)*nan];
sum_GR.lag8 = [gen_sum_J(GR_data, 8); ones(8,1)*nan];
sum_GR.lag12 = [gen_sum_J(GR_data, 12); ones(12,1)*nan];
sum_GR.lag16 = [gen_sum_J(GR_data, 16); ones(16,1)*nan];

result.mdl_lag4 = fitlm(VR_data, sum_GR.lag4);
result.mdl_lag8 = fitlm(VR_data, sum_GR.lag8);
result.mdl_lag12 = fitlm(VR_data, sum_GR.lag12);
result.mdl_lag16 = fitlm(VR_data, sum_GR.lag16);

result.b = [result.mdl_lag4.Coefficients.Estimate(2);result.mdl_lag8.Coefficients.Estimate(2);...
    result.mdl_lag12.Coefficients.Estimate(2);result.mdl_lag16.Coefficients.Estimate(2)];

result.t = [result.mdl_lag4.Coefficients.tStat(2);result.mdl_lag8.Coefficients.tStat(2);...
    result.mdl_lag12.Coefficients.tStat(2);result.mdl_lag16.Coefficients.tStat(2)];

result.r_2 = [result.mdl_lag4.Rsquared.Adjusted;result.mdl_lag8.Rsquared.Adjusted;...
    result.mdl_lag12.Rsquared.Adjusted; result.mdl_lag16.Rsquared.Adjusted];

end

