function [ result ] = pred_sum_GR_MC( GR_data, sim_VR )
% Summary of this function goes here
%   Detailed explanation goes here

AR_mdl = arima('ARLags', 1);

mc_time = size(sim_VR, 2);

GR_mdl = estimate(AR_mdl, GR_data, 'Display', 'off');
[GR_eps, GR_v] = infer(GR_mdl, GR_data);

sim_GR = simulate(GR_mdl, length(GR_data)-1, 'Y0', GR_data(1), 'E0', GR_eps(1), 'V0', GR_v(1),'NumPaths',mc_time);

sim_GR = [ones(1, mc_time); sim_GR];


sim_sum_GR.lag4 = ones(size(sim_GR))*nan;
sim_sum_GR.lag8 = sim_sum_GR.lag4;
sim_sum_GR.lag12 = sim_sum_GR.lag4;
sim_sum_GR.lag16 = sim_sum_GR.lag4;

for i = 1:mc_time
    sim_sum_GR.lag4(:,i) = [gen_sum_J(sim_GR(:,i), 4); ones(4,1)*nan];
    sim_sum_GR.lag8(:,i) = [gen_sum_J(sim_GR(:,i), 8); ones(8,1)*nan];
    sim_sum_GR.lag12(:,i) = [gen_sum_J(sim_GR(:,i), 12); ones(12,1)*nan];
    sim_sum_GR.lag16(:,i) = [gen_sum_J(sim_GR(:,i), 16); ones(16,1)*nan];
end

result.t = ones(4,mc_time);
result.r_2 = result.t;

for i = 1:mc_time
    [result.t(1,i), result.r_2(1,i)] = Extract_lm(fitlm(sim_VR(:,i), sim_sum_GR.lag4(:,i)));
    [result.t(2,i), result.r_2(2,i)] = Extract_lm(fitlm(sim_VR(:,i), sim_sum_GR.lag8(:,i)));
    [result.t(3,i), result.r_2(3,i)] = Extract_lm(fitlm(sim_VR(:,i), sim_sum_GR.lag12(:,i)));
    [result.t(4,i), result.r_2(4,i)] = Extract_lm(fitlm(sim_VR(:,i), sim_sum_GR.lag16(:,i)));
end

for i = 1:4
    result.t_90(i) = quantile(result.t(i,:), 0.9);
    result.t_95(i) = quantile(result.t(i,:), 0.95);
    result.t_975(i) = quantile(result.t(i,:), 0.975);
    result.r_2_95(i) = quantile(result.r_2(i,:), 0.95);
end

end

