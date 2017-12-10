function [ vr_sigma, vr_sigma_lag, sigma_vr, sigma_vr_lag] = MC_regress3( vr, gr, mc_time)
%MC_regress3 Summary of this function goes here
%   Detailed explanation goes here
%   Monte-Carlo of Table 3
%   vr: Valuation Ratio
%   gr: Growth Rate
%   J: lag
%   mc_time: The simulation times of Monte Carlo




% The AR-GARCH for gr

nrow = size(vr,1);
ARGARCH_mdl = arima('ARLags',1,'Variance',garch(1,1));
AR_mdl = arima('ARLags',1);

gr_ARGARCH_mdl = estimate(ARGARCH_mdl, gr, 'Display','off');
[e0, v0] = infer(gr_ARGARCH_mdl, gr);

% Estimate the AR process for vr
vr_AR_mdl = estimate(AR_mdl, vr, 'Display','off');

% Estimate the regressions
sim_numObs = nrow - 1;
T = floor(4*(sim_numObs/100)^(2/9))+1;


% vr_sigma
vr_sigma_mdl = fitlm(log(v0(1:end-1)), vr(2:end));
[~, vr_sigma_se] = hac(vr_sigma_mdl,'type','HAC','bandwidth',T,'weights','BT','display','off');
vr_sigma.b = vr_sigma_mdl.Coefficients.Estimate(2);
vr_sigma.t = vr_sigma_mdl.Coefficients.Estimate(2)/vr_sigma_se(2);
vr_sigma.R2adj = vr_sigma_mdl.Rsquared.Adjusted;

% vr_sigma_lag
vr_sigma_lag_mdl = fitlm([log(v0(1:end-1)), vr(1:end-1)], vr(2:end));
[~, vr_sigma_lag_se] = hac(vr_sigma_lag_mdl,'type','HAC','bandwidth',T,'weights','BT','display','off');
vr_sigma_lag.b = vr_sigma_lag_mdl.Coefficients.Estimate(2:3);
vr_sigma_lag.t = vr_sigma_lag_mdl.Coefficients.Estimate(2:3)./vr_sigma_lag_se(2:3);
vr_sigma_lag.R2adj = vr_sigma_lag_mdl.Rsquared.Adjusted;

% sigma_vr
sigma_vr_mdl = fitlm(vr(1:end-1),log(v0(2:end)));
[~, sigma_vr_se] = hac(sigma_vr_mdl,'type','HAC','bandwidth',T,'weights','BT','display','off');
sigma_vr.b = sigma_vr_mdl.Coefficients.Estimate(2);
sigma_vr.t = sigma_vr_mdl.Coefficients.Estimate(2)/sigma_vr_se(2);
sigma_vr.R2adj = sigma_vr_mdl.Rsquared.Adjusted;

% sigma_vr_lag
sigma_vr_lag_mdl = fitlm([vr(1:end-1), log(v0(1:end-1))],log(v0(2:end)));
[~, sigma_vr_lag_se] = hac(sigma_vr_lag_mdl,'type','HAC','bandwidth',T,'weights','BT','display','off');
sigma_vr_lag.b = sigma_vr_lag_mdl.Coefficients.Estimate(2:3);
sigma_vr_lag.t = sigma_vr_lag_mdl.Coefficients.Estimate(2:3)./sigma_vr_lag_se(2:3);
sigma_vr_lag.R2adj = sigma_vr_lag_mdl.Rsquared.Adjusted;


% The estimation of the regression function


% Define the result container
mc_vr_sigma_t = ones(mc_time,1);
mc_vr_sigma_r = mc_vr_sigma_t;
mc_vr_sigma_lag_t = ones(mc_time,2);
mc_vr_sigma_lag_r = mc_vr_sigma_t;

mc_sigma_vr_t = mc_vr_sigma_t;
mc_sigma_vr_r = mc_vr_sigma_t;
mc_sigma_vr_lag_t = mc_vr_sigma_lag_t;
mc_sigma_vr_lag_r = mc_vr_sigma_t;



mc_gr = nan*ones(nrow,1);
mc_vr = mc_gr;
mc_gr(1) = gr(1);
mc_vr(1) = vr(1);

for i = 1:mc_time
   
    % simulate AR_GARCH process of gr and estimate ARGRACH process
    % gr to get log_sigma
    mc_gr(2:end) = simulate(gr_ARGARCH_mdl, sim_numObs,'NumPaths',1, 'E0',e0(1),'V0', v0(1),'Y0',gr(1));
    mc_gr_ARGARCH = estimate(ARGARCH_mdl, mc_gr,'Display','off');
    [~, mc_v0] = infer(mc_gr_ARGARCH, mc_gr);
    mc_log_sigma = log(mc_v0);
    
    % simulate vr
    mc_vr(2:end) = simulate(vr_AR_mdl, sim_numObs,'NumPaths',1,'Y0',vr(1));

    
    
    % estimate those four regressions
    
    % vr_sigma
    temp_mdl = fitlm(mc_log_sigma(1:end-1), mc_vr(2:end));
    [~, temp_se] = hac(vr_sigma_mdl,'type','HAC','bandwidth',T,'weights','BT','display','off');
    mc_vr_sigma_t(i) = temp_mdl.Coefficients.Estimate(2)/temp_se(2);
    mc_vr_sigma_r(i) = temp_mdl.Rsquared.Adjusted;

    % vr_sigma_lag
    temp_mdl = fitlm([mc_log_sigma(1:end-1), mc_vr(1:end-1)], mc_vr(2:end));
    [~, temp_se] = hac(vr_sigma_lag_mdl,'type','HAC','bandwidth',T,'weights','BT','display','off');
    mc_vr_sigma_lag_t(i,:) = temp_mdl.Coefficients.Estimate(2:3)./temp_se(2:3);
    mc_vr_sigma_lag_r(i) = temp_mdl.Rsquared.Adjusted;
    
    % sigma_vr
    temp_mdl = fitlm(mc_log_sigma(1:end-1), mc_vr(2:end));
    [~, temp_se] = hac(sigma_vr_mdl,'type','HAC','bandwidth',T,'weights','BT','display','off');
    mc_sigma_vr_t(i) = temp_mdl.Coefficients.Estimate(2)/temp_se(2);
    mc_sigma_vr_r(i) = temp_mdl.Rsquared.Adjusted;

    % sigma_vr_lag
    temp_mdl = fitlm([mc_log_sigma(1:end-1), mc_vr(1:end-1)], mc_vr(2:end));
    [~, temp_se] = hac(sigma_vr_lag_mdl,'type','HAC','bandwidth',T,'weights','BT','display','off');
    mc_sigma_vr_lag_t(i,:) = temp_mdl.Coefficients.Estimate(2:3)./temp_se(2:3);
    mc_sigma_vr_lag_r(i) = temp_mdl.Rsquared.Adjusted;
end

% Calculate the quantile
vr_sigma.t2_5 = quantile(mc_vr_sigma_t, 0.025);
vr_sigma.t5 = quantile(mc_vr_sigma_t, 0.05);
vr_sigma.R2_95 = quantile(mc_vr_sigma_r, 0.95);
vr_sigma.R2_97_5 = quantile(mc_vr_sigma_r, 0.975);

% Calculate the quantile
sigma_vr.t2_5 = quantile(mc_sigma_vr_t, 0.025);
sigma_vr.t5 = quantile(mc_sigma_vr_t, 0.05);
sigma_vr.R2_95 = quantile(mc_sigma_vr_r, 0.95);
sigma_vr.R2_97_5 = quantile(mc_sigma_vr_r, 0.975);

% Calculate the quantile
vr_sigma_lag.t2_5 = [quantile(mc_vr_sigma_lag_t(:,1), 0.025); quantile(mc_vr_sigma_lag_t(:,2), 0.025)];
vr_sigma_lag.t5 = [quantile(mc_vr_sigma_lag_t(:,1), 0.05); quantile(mc_vr_sigma_lag_t(:,2), 0.05)];

vr_sigma_lag.R2_95 = quantile(mc_vr_sigma_lag_r, 0.95);
vr_sigma_lag.R2_97_5 = quantile(mc_vr_sigma_lag_r, 0.975);

% Calculate the quantile
sigma_vr_lag.t2_5 = [quantile(mc_sigma_vr_lag_t(:,1), 0.025); quantile(mc_sigma_vr_lag_t(:,2), 0.025)];
sigma_vr_lag.t5 = [quantile(mc_sigma_vr_lag_t(:,1), 0.05); quantile(mc_sigma_vr_lag_t(:,2), 0.05)];
sigma_vr_lag.R2_95 = quantile(mc_sigma_vr_lag_r, 0.95);
sigma_vr_lag.R2_97_5 = quantile(mc_sigma_vr_lag_r, 0.975);

end

