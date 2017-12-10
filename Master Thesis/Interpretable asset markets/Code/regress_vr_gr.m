function [output] = regress_vr_gr( vr, gr, J, mc_time)
%regress_vr_gr Summary of this function goes here
%   Valuation ratios predicting future growth rates and returns
%   Detailed explanation goes here
%   Monte-Carlo of Table 3
%   vr: Valuation Ratio
%   gr: Growth Rate
%   J: lag
%   mc_time: The simulation times of Monte Carlo


% Define the MC_result
numLags = length(J);
output.b = ones(numLags,1)*nan;
output.t = output.b;
output.R2adj = output.b;

if nargin == 4
    % Define the MC output
    output.t90 = output.b;
    output.t95 = output.b;
    output.t97_5 = output.b;
    output.R2_95 = output.b;
end



% The AR-GARCH for gr



nrow = size(vr,1);
const = ones(nrow,1);
for i = 1:numLags
    % generate the sum of gr
    regressand = zeros(nrow-J(i),1);
    for j = 1:J(i)
        regressand = regressand + gr(1+j:end-J(i)+j);
    end
    [beta,~,R2adj,~,~,~,~,~,~,~,t_HH] = olshac(regressand, [const(1+J(i):end), vr(1:end-J(i))],J(i),J(i));
    output.b(i) = beta(2);
    output.t(i) = t_HH(2);
    output.R2adj(i) = R2adj;
end



if nargin == 4
    AR_mdl = arima('ARLags',1);
    gr_AR_mdl = estimate(AR_mdl, gr, 'Display','off');
    vr_AR_mdl = estimate(AR_mdl, vr, 'Display','off');
    
    % predefine gr and vr
    mc_gr = nan*zeros(nrow,1);
    mc_vr = mc_gr;
    mc_gr(1) = gr(1);
    mc_vr(1) = vr(1);
    sim_numObs = nrow - 1;
    
    temp_t = nan*zeros(mc_time,4);
    temp_R2adj = temp_t;
    
    for i = 1:mc_time
        % simulate gr and vr
        mc_gr(2:end) = simulate(gr_AR_mdl, sim_numObs,'NumPaths',1,'Y0',gr(1));
        mc_vr(2:end) = simulate(vr_AR_mdl, sim_numObs,'NumPaths',1,'Y0',vr(1));
        for j = 1:numLags
            regressand = zeros(nrow-J(j),1);
            for k = 1:J(j)
                regressand = regressand + mc_gr(1+k:end-J(j)+k);
            end
            [~,~,temp_R2adj(i,j),~,~,~,~,~,~,~,t_HH] = olshac(regressand, [const(1+J(j):end), mc_vr(1:end-J(j))],J(j),J(j));
            temp_t(i,j) = t_HH(2);
        end
    end
    
    
    output.t90 = quantile(temp_t, 0.9)';
    output.t95 = quantile(temp_t, 0.95)';
    output.t97_5 = quantile(temp_t, 0.975)';
    output.R2_95 = quantile(temp_R2adj, 0.95)';
   
    
end



end

