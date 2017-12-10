function [ MC_result] = MC_regress1_2( vr, gr, J, mc_time)
%MC_regress1s Summary of this function goes here
%   Version2: simulate all J lags at each time
%   Detailed explanation goes here
%   Monte-Carlo of Table 3
%   vr: Valuation Ratio
%   gr: Growth Rate
%   J: lag
%   mc_time: The simulation times of Monte Carlo


% Define the MC_result
numLags = length(J);
MC_result.b = ones(numLags,1)*nan;
MC_result.t = MC_result.b;
MC_result.R2adj = MC_result.b;
MC_result.t2_5 = MC_result.b;
MC_result.t5 = MC_result.b;
MC_result.R2_95 = MC_result.b;

% The AR-GARCH for gr

nrow = size(vr,1);
ARGARCH_mdl = arima('ARLags',1,'Variance',garch(1,1));
AR_mdl = arima('ARLags',1);

gr_ARGARCH_mdl = estimate(ARGARCH_mdl, gr, 'Display','off');
[e0, v0] = infer(gr_ARGARCH_mdl, gr);

% Estimate the AR process for vr
vr_AR_mdl = estimate(AR_mdl, vr, 'Display','off');

% Estimate the AR and using eps to calculate sigma
ols_AR = fitlm(gr(1:end-1),gr(2:end));



% The estimation of the regression function

const = ones(nrow-2,1);

for i = 1:numLags
    regressand = vr(2+J(i):end);
    regressor = gen_sigma_J(ols_AR.Residuals.Raw,J(i)); % regressor is sigma
    [beta,~,R2adj,~,~,~,~,~,~,t_NW] = olshac(regressand, [const(J(i):end), regressor],J(i),J(i));
    MC_result.b(i) = beta(2);
    MC_result.t(i) = t_NW(2);
    MC_result.R2adj(i) = R2adj;
end



% Monte-Carlo
sim_numObs = nrow - 1;
mc_t = nan*ones(mc_time,numLags);
mc_R2 = mc_t;


for i = 1:mc_time
   
    % simulate sigma by AR_GARCH process of vr and estimate AR process of
    % vr
    mc_gr = simulate(gr_ARGARCH_mdl, sim_numObs,'NumPaths',1, 'E0',e0(1),'V0', v0(1));
    mc_gr = [gr(1);mc_gr];
    mc_gr_AR = fitlm(mc_gr(1:end-1),mc_gr(2:end));
    
    
    mc_vr = simulate(vr_AR_mdl, sim_numObs,'NumPaths',1);
    % regress and get the t-stat and R2adj
    for j = 1:numLags
        mc_regressand = mc_vr(1+J(j):end);
        mc_regressor = gen_sigma_J(mc_gr_AR.Residuals.Raw, J(j));
        [~,~,mc_R2(i,j),~,~,~,~,~,~,temp_t] = olshac(mc_regressand , [const(J(j):end), mc_regressor],J(j),J(j));
        mc_t(i,j) = temp_t(2);

    end
end

for j = 1:numLags
    MC_result.t2_5(j) = quantile(mc_t(:,j), 0.025);
    MC_result.t5(j) = quantile(mc_t(:,j), 0.05);
    MC_result.R2_95(j) = quantile(mc_R2(:,j), 0.95);
end

end

