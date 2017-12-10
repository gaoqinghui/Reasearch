function [ MC_result ] = MC_regress1( vr, gr, J, mc_time)
%MC_regress1s Summary of this function goes here
%   Version1: simulate one regression at each time
%   Detailed explanation goes here
%   Monte-Carlo of Table 3
%   vr: Valuation Ratio
%   gr: Growth Rate
%   J: lag
%   mc_time: The simulation times of Monte Carlo

% The AR-GARCH for vr
nrow = size(vr,1);
ARGARCH_mdl = arima('ARLags',1,'Variance',garch(1,1));
AR_mdl = arima('ARLags',1);

gr_ARGARCH_mdl = estimate(ARGARCH_mdl, gr, 'Display','off');
[e0, v0] = infer(gr_ARGARCH_mdl, gr);

% Estimate the AR process for vr
vr_AR_mdl = estimate(AR_mdl, vr, 'Display','off');

% Estimate the AR and using eps to calculate sigma
ols_AR = fitlm(gr(2:end),gr(1:end-1));

const = ones(nrow-J-1,1);
regressand = vr(2+J:end);
regressor = gen_sigma_J(ols_AR.Residuals.Raw,J); % regressor is sigma

% The estimation of the regression function

[beta,~,R2adj,~,~,~,~,~,~,t_NW] = olshac(regressand, [const, regressor],J,J);
MC_result.b = beta(2);
MC_result.t = t_NW(2);
MC_result.R2adj = R2adj;


% Monte-Carlo
sim_numObs = nrow - 1;
mc_t = nan*ones(mc_time,1);
mc_R2 = mc_t;

for i = 1:mc_time
    % simulate sigma by AR_GARCH process of vr and estimate AR process of
    % vr
    mc_gr = simulate(gr_ARGARCH_mdl, sim_numObs,'NumPaths',1, 'E0',e0(1),'V0', v0(1));
    mc_gr = [gr(1);mc_gr];
    mc_gr_AR = fitlm(mc_gr(2:end),mc_gr(1:end-1));
    
    
    mc_vr = simulate(vr_AR_mdl, sim_numObs,'NumPaths',1);
    % regress and get the t-stat and R2adj
    mc_regressand = mc_vr(1+J:end);
    mc_regressor = gen_sigma_J(mc_gr_AR.Residuals.Raw, J);
    [~ ,~,mc_R2(i),~,~,~,~,~,~,temp_t] = olshac(mc_regressand , [const, mc_regressor],J,J);
    mc_t(i) = temp_t(2);
end

MC_result.t2_5 = quantile(mc_t, 0.025);
MC_result.t5 = quantile(mc_t, 0.05);
MC_result.R2_95 = quantile(mc_R2, 0.95);



end

