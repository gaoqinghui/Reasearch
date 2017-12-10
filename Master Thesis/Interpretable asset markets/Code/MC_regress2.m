function [ vr_sigma, eps_vr] = MC_regress2( vr, gr, J, mc_time)
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
vr_sigma.b = ones(numLags,1)*nan;
vr_sigma.t = vr_sigma.b;
vr_sigma.R2adj = vr_sigma.b;
vr_sigma.t2_5 = vr_sigma.b;
vr_sigma.t5 = vr_sigma.b;
vr_sigma.R2_95 = vr_sigma.b;

eps_vr.b = vr_sigma.b;
eps_vr.t = eps_vr.b;
eps_vr.R2adj = eps_vr.b;
eps_vr.t2_5 = eps_vr.b;
eps_vr.t5 = eps_vr.b;
eps_vr.R2_95 = eps_vr.b;

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
abs_eps = abs(ols_AR.Residuals.Raw);



% The estimation of the regression function

const = ones(nrow-1,1);

% estimate vr_sigma
for i = 1:numLags
    regressand = vr(2+J(i):end);
    regressor = gen_sigma_J(abs_eps,J(i)); % regressor is sigma
    [beta,~,R2adj,~,~,~,~,~,~,t_NW] = olshac(regressand, [const(1+J(i):end), regressor],J(i),J(i));
    vr_sigma.b(i) = beta(2);
    vr_sigma.t(i) = t_NW(2);
    vr_sigma.R2adj(i) = R2adj;
end

% estimate eps_vr
for i = 1:numLags
    regressand = abs_eps(J(i):end); % regressand is abs(eps)
    regressor = vr(1:end-J(i)); % regressor is vr
    [beta,~,R2adj,~,~,~,~,~,~,t_NW] = olshac(regressand, [const(J(i):end), regressor],J(i),J(i));
    eps_vr.b(i) = beta(2);
    eps_vr.t(i) = t_NW(2);
    eps_vr.R2adj(i) = R2adj;
end





% Monte-Carlo
sim_numObs = nrow - 1;
reg1_mc_t = nan*ones(mc_time,numLags);
reg1_mc_R2 = reg1_mc_t;

reg2_mc_t = reg1_mc_t;
reg2_mc_R2 = reg1_mc_t;


for i = 1:mc_time
   
    % simulate sigma by AR_GARCH process of vr and estimate AR process of
    % vr
    mc_gr = simulate(gr_ARGARCH_mdl, sim_numObs,'NumPaths',1, 'E0',e0(1),'V0', v0(1),'Y0',gr(1));
    mc_gr = [gr(1);mc_gr];
    mc_gr_AR = fitlm(mc_gr(1:end-1),mc_gr(2:end));
    
    
    mc_vr = simulate(vr_AR_mdl, sim_numObs,'NumPaths',1,'Y0',vr(1));
    mc_vr = [vr(1);mc_vr];
    % regress and get the t-stat and R2adj
    mc_abs_eps = abs(mc_gr_AR.Residuals.Raw);
    
    % simulate regression 1
    for j = 1:numLags
        mc_regressand = mc_vr(2+J(j):end);
        mc_regressor = gen_sigma_J(mc_gr_AR.Residuals.Raw, J(j));
        [~,~,reg1_mc_R2(i,j),~,~,~,~,~,~,temp_t] = olshac(mc_regressand , [const(1+J(j):end), mc_regressor],J(j),J(j));
        reg1_mc_t(i,j) = temp_t(2);
    end
    
    % simulate regression 2
    for j = 1:numLags
        mc_regressand = mc_abs_eps(1+J(j):end);
        mc_regressor = mc_vr(1:end-J(j)-1);
        [~,~,reg2_mc_R2(i,j),~,~,~,~,~,~,temp_t] = olshac(mc_regressand , [const(1+J(j):end), mc_regressor],J(j),J(j));
        reg2_mc_t(i,j) = temp_t(2);
    end
end

for j = 1:numLags
    vr_sigma.t2_5(j) = quantile(reg1_mc_t(:,j), 0.025);
    vr_sigma.t5(j) = quantile(reg1_mc_t(:,j), 0.05);
    vr_sigma.R2_95(j) = quantile(reg1_mc_R2(:,j), 0.95);
    
    eps_vr.t2_5(j) = quantile(reg2_mc_t(:,j), 0.025);
    eps_vr.t5(j) = quantile(reg2_mc_t(:,j), 0.05);
    eps_vr.R2_95(j) = quantile(reg2_mc_R2(:,j), 0.95);
end

end

