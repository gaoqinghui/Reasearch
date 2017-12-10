%% Table 5
mc_time = 100;
[ vr_sigma, vr_sigma_lag, sigma_vr, sigma_vr_lag] = MC_regress3(full_reg_data.p_min_e, full_reg_data.g_c, mc_time);

% table 5
table_5_data = cell(15,8);
table_5_data([1:3,5:7,9:11,13:15],1) = {'Panel A:Predicting price-earnings ratio','p_t - e_t = a0 + a1*log(sigma_c_t-1^2) + eps_t',...
    'a1', 'p_t - e_t = a0 +  a1*(p_t-1 - e_t-1)+ a2*log(sigma_c_t-1^2)  + eps_t','a2','a1',...
    'Panel B: Predicting volatility','log(sigma_c_t^2) = a0 + a1*(p_t-1 - e_t-1) + eps_t',...
    'a1', 'log(sigma_c_t^2) = a0 + a1*(p_t-1 - e_t-1) + a2*log(sigma_c_t-1^2) + eps_t'...
    'a1','a2'};

table_5_data(3,2:8) = num2cell([vr_sigma.b, vr_sigma.t, vr_sigma.R2adj,...
    vr_sigma.t2_5, vr_sigma.t5, vr_sigma.R2_95, vr_sigma.R2_97_5]);

table_5_data(6:7,[2,3,5,6]) =  num2cell([vr_sigma_lag.b, vr_sigma_lag.t, vr_sigma_lag.t2_5, vr_sigma_lag.t5]);
table_5_data(6,[4,7,8]) =  num2cell([vr_sigma_lag.R2adj, vr_sigma_lag.R2_95, vr_sigma_lag.R2_97_5]);

table_5_data(11,2:8) = num2cell([sigma_vr.b, sigma_vr.t, sigma_vr.R2adj,...
    sigma_vr.t2_5, sigma_vr.t5, sigma_vr.R2_95, sigma_vr.R2_97_5]);

table_5_data(14:15,[2,3,5,6]) =  num2cell([sigma_vr_lag.b, sigma_vr_lag.t, sigma_vr_lag.t2_5, sigma_vr_lag.t5]);
table_5_data(14,[4,7,8]) =  num2cell([sigma_vr_lag.R2adj, sigma_vr_lag.R2_95, sigma_vr_lag.R2_97_5]);


clf

f5 = figure('Name','Price-earnings ratios and economic uncertainty: USA','NumberTitle','off');


f5.Position = [560,528,940,360];

table_5 = uitable(f5,'Data',table_5_data,'Position',[20 30 880 310]);
table_5.Position = [20 30 880 310];

table_5.ColumnWidth = {370,65,65,65,65,65,65,80};
table_5.ColumnName = {'J', 'a', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)','R^2(97.25%)'};