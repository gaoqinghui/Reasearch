function [AR_GR, ARGARCH_GR, pred_VR, pred_eps, robust] = MC_predict_VR( VR_data, GR_data, mc_time, robust_check)
% Summary of this function goes here
%   VR for Valuation Ratio
%   GR for growth rate of consumption or market return
%   AR_GR is the estimation(coef, se, AC of abs_eps) for AR(1) of GR(growth rate)
%   ARGARCH if the estimation(coef, se) for AR(1)-GARCH(1,1) of GR
%
% Output options:
%
%   AR_GR: the AR(1) model for GR(growth)
%       _AR_GR.mdl: the estimation of AR_GR
%       -AR_GR.coef: the estimate of the coef(const, AR(1))
%       -AR_GR.se: the standard error of  the estimation(const, AR(1))
%       -AR_GR.AC: the Autocorrelation of absolute eps in lag 1,4,8
%       -AR_GR.Q: the lbqt result of absolute eps
%           -AR_GR.Q.h: the hypothesis test result of lbqt
%           -AR_GR.Q.p: the p-value result of lbqt
%           -AR_GR.Q.stat: the Q-stat result of lbqt
%       -AR_GR.eps
%       -AR_GR.abs_eps_lag1,lag4,lag8,lag12
%
%   ARGARCH_GR: the AR(1)-GARCH(1,1) model for GR(growth)
%       -ARGARCH_GR.coef: the estimate of the coef(const,AR(1)-GARCH(1,1),var_const,ARCH,GARCH)
%       -ARGARCH_GR.se: the standard error of  the estimation(const,AR(1)-GARCH(1,1),var_const,ARCH,GARCH)
%
%

AR_mdl = arima('ARLags', 1);
ARGARCH_mdl = arima('ARLags',1,'Variance',garch(1,1));

%% (1) estimate g_c or r_m of AR(1) and examine the AC of absolute residuals

[AR_GR.mdl, AR_GR.vcov] = estimate(AR_mdl, GR_data);
AR_GR.coef = [AR_GR.mdl.Constant; AR_GR.mdl.AR{1}]; % coef
AR_GR.se = sqrt([AR_GR.vcov(1,1); AR_GR.vcov(2,2)]); % se

% infer absolute residuals
[AR_GR.eps, AR_GR.v] = infer(AR_GR.mdl, GR_data);
AR_GR.abs_eps = abs(AR_GR.eps);

AC_AR = autocorr(AR_GR.abs_eps,8);
AR_GR.AC = AC_AR([2,5,8]);
[AR_GR.Q.h, AR_GR.Q.p, AR_GR.Q.stat] = lbqtest(abs(AR_GR.abs_eps),'lags',[1,4,8]);

%% (2) estimate g_c or r_m of AR(1)-GARCH(1,1)

[ARGARCH_GR.mdl, ARGARCH_GR.vcov] = estimate(ARGARCH_mdl, GR_data);
ARGARCH_GR.coef = [ARGARCH_GR.mdl.Constant; ARGARCH_GR.mdl.AR{1}; ARGARCH_GR.mdl.Variance.Constant; ARGARCH_GR.mdl.Variance.ARCH{1}; ARGARCH_GR.mdl.Variance.GARCH{1}]; % coef
ARGARCH_GR.se = sqrt([ARGARCH_GR.vcov(1,1); ARGARCH_GR.vcov(2,2);  ARGARCH_GR.vcov(3,3);  ARGARCH_GR.vcov(5,5);  ARGARCH_GR.vcov(4,4)]); % se
[ARGARCH_GR.eps, ARGARCH_GR.v] = infer(ARGARCH_GR.mdl, GR_data);

%% (3) estimate prediction model of future valuation ratios



% construct economic uncertainty


AR_GR.sigma_lag1 = [nan; gen_sigma_J(AR_GR.abs_eps, 1)];
AR_GR.sigma_lag4 = [nan*ones(4,1); gen_sigma_J(AR_GR.abs_eps, 4)];
AR_GR.sigma_lag8 = [nan*ones(8,1); gen_sigma_J(AR_GR.abs_eps, 8)];
AR_GR.sigma_lag12 = [nan*ones(12,1); gen_sigma_J(AR_GR.abs_eps, 12)];

pred_VR.lag1.mdl = fitlm(AR_GR.sigma_lag1,VR_data);
pred_VR.lag4.mdl = fitlm(AR_GR.sigma_lag4,VR_data);
pred_VR.lag8.mdl = fitlm(AR_GR.sigma_lag8,VR_data);

pred_VR.lag1.b = pred_VR.lag1.mdl.Coefficients.Estimate(2);
pred_VR.lag1.t = pred_VR.lag1.mdl.Coefficients.tStat(2);
pred_VR.lag1.r_2 = pred_VR.lag1.mdl.Rsquared.Adjusted;

pred_VR.lag4.b = pred_VR.lag4.mdl.Coefficients.Estimate(2);
pred_VR.lag4.t = pred_VR.lag4.mdl.Coefficients.tStat(2);
pred_VR.lag4.r_2 = pred_VR.lag4.mdl.Rsquared.Adjusted;

pred_VR.lag8.b = pred_VR.lag8.mdl.Coefficients.Estimate(2);
pred_VR.lag8.t = pred_VR.lag8.mdl.Coefficients.tStat(2);
pred_VR.lag8.r_2 = pred_VR.lag8.mdl.Rsquared.Adjusted;

%% (4) simulate  GR from AR(1)-GARCH(1,1)



pred_VR.sim_GR = simulate(ARGARCH_GR.mdl,length(GR_data)-1, 'Y0', GR_data(1), 'E0', ARGARCH_GR.eps(1), 'V0', ARGARCH_GR.v(1),'NumPaths',mc_time);
pred_VR.sim_GR = [ones(1,mc_time) *GR_data(1); pred_VR.sim_GR];

pred_VR.sim_abs_eps = ones(size(pred_VR.sim_GR))*nan;
pred_VR.sim_v = pred_VR.sim_abs_eps;
pred_VR.lag1.sim_sigma = pred_VR.sim_abs_eps;
pred_VR.lag4.sim_sigma = pred_VR.sim_abs_eps;
pred_VR.lag8.sim_sigma = pred_VR.sim_abs_eps;

for i = 1:mc_time
    pred_VR.sim_abs_eps(:,i) = abs(infer(estimate(AR_mdl, pred_VR.sim_GR(:,i), 'Display', 'off'), pred_VR.sim_GR(:,i)));
    pred_VR.lag1.sim_sigma(:,i) = [nan; gen_sigma_J(pred_VR.sim_abs_eps(:,i), 1)];
    pred_VR.lag4.sim_sigma(:,i) = [nan*ones(4,1); gen_sigma_J(pred_VR.sim_abs_eps(:,i), 4)];
    pred_VR.lag8.sim_sigma(:,i) = [nan*ones(8,1); gen_sigma_J(pred_VR.sim_abs_eps(:,i), 8)];
end









%% Simulate price-earing( price-dividend) ratio

pred_VR.AR_VR.mdl = estimate(AR_mdl, VR_data, 'Display', 'off');
[pred_VR.AR_VR.eps, pred_VR.AR_VR.v] = infer(pred_VR.AR_VR.mdl, VR_data);

pred_VR.sim_VR = simulate(pred_VR.AR_VR.mdl, length(GR_data)-1,'Y0', VR_data(1), 'E0', pred_VR.AR_VR.eps(1), 'V0', pred_VR.AR_VR.v(1),'NumPaths',mc_time);
pred_VR.sim_VR = [ones(1,mc_time)*VR_data(1); pred_VR.sim_VR];

pred_VR.lag1.sim_t = pred_VR.lag1.mdl.Coefficients.Estimate(2);
pred_VR.lag1.sim_r_2 = pred_VR.lag1.mdl.Coefficients.tStat(2);

pred_VR.lag1.sim_t = nan*zeros(1,mc_time);
pred_VR.lag4.sim_t = pred_VR.lag1.sim_t;
pred_VR.lag8.sim_t = pred_VR.lag1.sim_t;

pred_VR.lag1.sim_r_2 = pred_VR.lag1.sim_t;
pred_VR.lag4.sim_r_2 = pred_VR.lag1.sim_t;
pred_VR.lag8.sim_r_2 = pred_VR.lag1.sim_t;


for i = 1:mc_time
    [pred_VR.lag1.sim_t(i), pred_VR.lag1.sim_r_2(i)] = Extract_lm(fitlm(pred_VR.lag1.sim_sigma(:,i),pred_VR.sim_VR(:,i)));
    [pred_VR.lag4.sim_t(i), pred_VR.lag4.sim_r_2(i)] = Extract_lm(fitlm(pred_VR.lag4.sim_sigma(:,i),pred_VR.sim_VR(:,i)));
    [pred_VR.lag8.sim_t(i), pred_VR.lag8.sim_r_2(i)] = Extract_lm(fitlm(pred_VR.lag8.sim_sigma(:,i),pred_VR.sim_VR(:,i)));
end

pred_VR.lag1.sim_t_2_5 = quantile(pred_VR.lag1.sim_t, 0.025);
pred_VR.lag1.sim_t_5 = quantile(pred_VR.lag1.sim_t, 0.05);
pred_VR.lag1.sim_r_2_95 = quantile(pred_VR.lag1.sim_r_2, 0.95);

pred_VR.lag4.sim_t_2_5 = quantile(pred_VR.lag4.sim_t, 0.025);
pred_VR.lag4.sim_t_5 = quantile(pred_VR.lag4.sim_t, 0.05);
pred_VR.lag4.sim_r_2_95 = quantile(pred_VR.lag4.sim_r_2, 0.95);

pred_VR.lag8.sim_t_2_5 = quantile(pred_VR.lag8.sim_t, 0.025);
pred_VR.lag8.sim_t_5 = quantile(pred_VR.lag8.sim_t, 0.05);
pred_VR.lag8.sim_r_2_95 = quantile(pred_VR.lag8.sim_r_2, 0.95);



%% Predict abs_eps

pred_eps.lag1.real_abs_eps = [AR_GR.abs_eps(2:end); nan];
pred_eps.lag4.real_abs_eps = [AR_GR.abs_eps(5:end); ones(4,1)*nan];
pred_eps.lag8.real_abs_eps = [AR_GR.abs_eps(9:end); ones(8,1)*nan];

pred_eps.lag1.sim_abs_eps = [pred_VR.sim_abs_eps(2:end,:); ones(1,mc_time)*nan];
pred_eps.lag4.sim_abs_eps = [pred_VR.sim_abs_eps(5:end,:); ones(4,mc_time)*nan];
pred_eps.lag8.sim_abs_eps = [pred_VR.sim_abs_eps(9:end,:); ones(8,mc_time)*nan];

pred_eps.lag1.mdl = fitlm(VR_data, pred_eps.lag1.real_abs_eps);
pred_eps.lag4.mdl = fitlm(VR_data, pred_eps.lag4.real_abs_eps);
pred_eps.lag8.mdl = fitlm(VR_data, pred_eps.lag8.real_abs_eps);

pred_eps.lag1.a = pred_eps.lag1.mdl.Coefficients.Estimate(2);
pred_eps.lag1.t = pred_eps.lag1.mdl.Coefficients.tStat(2);
pred_eps.lag1.r_2 = pred_eps.lag1.mdl.Rsquared.Adjusted;

pred_eps.lag4.a = pred_eps.lag4.mdl.Coefficients.Estimate(2);
pred_eps.lag4.t = pred_eps.lag4.mdl.Coefficients.tStat(2);
pred_eps.lag4.r_2 = pred_eps.lag4.mdl.Rsquared.Adjusted;

pred_eps.lag8.a = pred_eps.lag8.mdl.Coefficients.Estimate(2);
pred_eps.lag8.t = pred_eps.lag8.mdl.Coefficients.tStat(2);
pred_eps.lag8.r_2 = pred_eps.lag8.mdl.Rsquared.Adjusted;

for i = 1:mc_time
    [pred_eps.lag1.sim_t(i), pred_eps.lag1.sim_r_2(i)] = Extract_lm(fitlm(pred_VR.sim_VR(:,i), pred_eps.lag1.sim_abs_eps(:,i)));
    [pred_eps.lag4.sim_t(i), pred_eps.lag4.sim_r_2(i)] = Extract_lm(fitlm(pred_VR.sim_VR(:,i), pred_eps.lag4.sim_abs_eps(:,i)));
    [pred_eps.lag8.sim_t(i), pred_eps.lag8.sim_r_2(i)] = Extract_lm(fitlm(pred_VR.sim_VR(:,i), pred_eps.lag8.sim_abs_eps(:,i)));
end

pred_eps.lag1.sim_t_2_5 = quantile(pred_eps.lag1.sim_t, 0.025);
pred_eps.lag1.sim_t_5 = quantile(pred_eps.lag1.sim_t, 0.05);
pred_eps.lag1.sim_r_2_95 = quantile(pred_eps.lag1.sim_r_2, 0.95);

pred_eps.lag4.sim_t_2_5 = quantile(pred_eps.lag4.sim_t, 0.025);
pred_eps.lag4.sim_t_5 = quantile(pred_eps.lag4.sim_t, 0.05);
pred_eps.lag4.sim_r_2_95 = quantile(pred_eps.lag4.sim_r_2, 0.95);

pred_eps.lag8.sim_t_2_5 = quantile(pred_eps.lag8.sim_t, 0.025);
pred_eps.lag8.sim_t_5 = quantile(pred_eps.lag8.sim_t, 0.05);
pred_eps.lag8.sim_r_2_95 = quantile(pred_eps.lag8.sim_r_2, 0.95);



%% Robust check

if nargin <= 3 || ~robust_check
    robust = nan;
    return;
end



robust.log_v = log(ARGARCH_GR.v);
robust.log_v_lag1 = [nan; log(ARGARCH_GR.v(1:end-1))];
robust.VR_lag1 = [nan; VR_data(1:end-1)];

robust.mdl1.mdl = fitlm(robust.log_v_lag1, VR_data);
robust.mdl1.a1 = robust.mdl1.mdl.Coefficients.Estimate(2);
robust.mdl1.t1 = robust.mdl1.mdl.Coefficients.tStat(2);
robust.mdl1.r_2 = robust.mdl1.mdl.Rsquared.Adjusted;

robust.mdl2.mdl = fitlm([robust.log_v_lag1, robust.VR_lag1], VR_data);
robust.mdl2.a1 = robust.mdl2.mdl.Coefficients.Estimate(2);
robust.mdl2.a2 = robust.mdl2.mdl.Coefficients.Estimate(3);
robust.mdl2.t1 = robust.mdl2.mdl.Coefficients.tStat(2);
robust.mdl2.t2 = robust.mdl2.mdl.Coefficients.tStat(3);
robust.mdl2.r_2 = robust.mdl2.mdl.Rsquared.Adjusted;

robust.mdl3.mdl = fitlm(robust.VR_lag1, robust.log_v);
robust.mdl3.a1 = robust.mdl3.mdl.Coefficients.Estimate(2);
robust.mdl3.t1 = robust.mdl3.mdl.Coefficients.tStat(2);
robust.mdl3.r_2 = robust.mdl3.mdl.Rsquared.Adjusted;

robust.mdl4.mdl = fitlm([robust.VR_lag1, robust.log_v_lag1], robust.log_v);
robust.mdl4.a1 = robust.mdl4.mdl.Coefficients.Estimate(2);
robust.mdl4.t1 = robust.mdl4.mdl.Coefficients.tStat(2);
robust.mdl4.a2 = robust.mdl4.mdl.Coefficients.Estimate(3);
robust.mdl4.t2 = robust.mdl4.mdl.Coefficients.tStat(3);
robust.mdl4.r_2 = robust.mdl4.mdl.Rsquared.Adjusted;

robust.sim_VR_lag1 = [nan*ones(1,mc_time); pred_VR.sim_VR(1:end-1,:)];
for i = 1:mc_time
    [~, robust.sim_log_v(:,i)] = infer(estimate(ARGARCH_mdl, pred_VR.sim_GR(:,i), 'Display', 'off'), pred_VR.sim_GR(:,i)); 
end
robust.sim_log_v = log(robust.sim_log_v);
robust.sim_log_v_lag1 = [nan*ones(1,mc_time); robust.sim_log_v(1:end-1,:)];

robust.mdl1.sim_t1 = ones(mc_time,1)*nan;
robust.mdl1.sim_r_2 = robust.mdl1.sim_t1;

robust.mdl2.sim_t1 = robust.mdl1.sim_t1;
robust.mdl2.sim_t2 = robust.mdl1.sim_t1;
robust.mdl2.sim_r_2 = robust.mdl1.sim_t1;

robust.mdl3.sim_t1 = robust.mdl1.sim_t1;
robust.mdl3.sim_r_2 = robust.mdl1.sim_t1;

robust.mdl4.sim_t1 = robust.mdl1.sim_t1;
robust.mdl4.sim_t2 = robust.mdl1.sim_t1;
robust.mdl4.sim_r_2 = robust.mdl1.sim_t1;

for i = 1:mc_time
    [robust.mdl1.sim_t1(i), robust.mdl1.sim_r_2(i)] = Extract_lm(fitlm(robust.sim_log_v_lag1(:,i),pred_VR.sim_VR(:,i)));
    [robust.mdl2.sim_t1(i), robust.mdl2.sim_r_2(i), robust.mdl2.sim_t2(i)] = Extract_lm(fitlm([robust.sim_log_v_lag1(:,i), robust.sim_VR_lag1(:,i)],pred_VR.sim_VR(:,i)));
    [robust.mdl3.sim_t1(i), robust.mdl3.sim_r_2(i)] = Extract_lm(fitlm(robust.sim_VR_lag1(:,i), robust.sim_log_v(:,i)));
    [robust.mdl4.sim_t1(i), robust.mdl4.sim_r_2(i), robust.mdl4.sim_t2(i)] = Extract_lm(fitlm([robust.sim_VR_lag1(:,i), robust.sim_log_v_lag1(:,i)], robust.sim_log_v(:,i)));
end

robust.mdl1.sim_t1_2_5 = quantile(robust.mdl1.sim_t1, 0.025);
robust.mdl1.sim_t1_5 = quantile(robust.mdl1.sim_t1, 0.05);
robust.mdl1.sim_r_2_95 = quantile(robust.mdl1.sim_r_2, 0.95);
robust.mdl1.sim_r_2_975 = quantile(robust.mdl1.sim_r_2, 0.975);

robust.mdl2.sim_t1_2_5 = quantile(robust.mdl2.sim_t1, 0.025);
robust.mdl2.sim_t1_5 = quantile(robust.mdl2.sim_t1, 0.05);
robust.mdl2.sim_t2_2_5 = quantile(robust.mdl2.sim_t2, 0.025);
robust.mdl2.sim_t2_5 = quantile(robust.mdl2.sim_t2, 0.05);
robust.mdl2.sim_r_2_95 = quantile(robust.mdl2.sim_r_2, 0.95);
robust.mdl2.sim_r_2_975 = quantile(robust.mdl2.sim_r_2, 0.975);

robust.mdl3.sim_t1_2_5 = quantile(robust.mdl3.sim_t1, 0.025);
robust.mdl3.sim_t1_5 = quantile(robust.mdl3.sim_t1, 0.05);
robust.mdl3.sim_r_2_95 = quantile(robust.mdl3.sim_r_2, 0.95);
robust.mdl3.sim_r_2_975 = quantile(robust.mdl3.sim_r_2, 0.975);

robust.mdl4.sim_t1_2_5 = quantile(robust.mdl4.sim_t1, 0.025);
robust.mdl4.sim_t1_5 = quantile(robust.mdl4.sim_t1, 0.05);
robust.mdl4.sim_t2_2_5 = quantile(robust.mdl4.sim_t2, 0.025);
robust.mdl4.sim_t2_5 = quantile(robust.mdl4.sim_t2, 0.05);
robust.mdl4.sim_r_2_95 = quantile(robust.mdl4.sim_r_2, 0.95);
robust.mdl4.sim_r_2_975 = quantile(robust.mdl4.sim_r_2, 0.975);





