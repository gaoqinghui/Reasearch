%% Final_copy

clear all
cd('J:\WISE\Ren yu\Interpretable asset markets\Data');
load('data_complete_deseasonallized_D.mat');

%% Table 1: Summary statistics

f1 = figure('Name','Summary statistics','NumberTitle','off');

t = uitable(f1,'Data',table_data,'Position',[40 220 450 140]);
t.RowName = RowName;
t.ColumnName = ColumnName;


sub_t = uitable(f1,'Data',sub_table_data,'Position',[40 80 450 140]);
sub_t.RowName =  RowName;
sub_t.ColumnName = ColumnName;

save table_data

%% Estimation

% set up random seed
rnd_seed = 20170906;
rng(rnd_seed);

mc_time = 300;

[pdc_AR_GR, pdc_ARGARCH_GR, pdc_pred_VR, pdc_pred_eps] = MC_predict_VR(full_reg_data.p_min_d, full_reg_data.g_c, mc_time);
[pec_AR_GR, pec_ARGARCH_GR, pec_pred_VR, pec_pred_eps, pec_pred_GR] = MC_predict_VR(full_reg_data.p_min_e, full_reg_data.g_c, mc_time, 1);

[pdr_AR_GR, pdr_ARGARCH_GR, pdr_pred_VR, pdr_pred_eps] = MC_predict_VR(full_reg_data.p_min_d, full_reg_data.r_m, mc_time);
[per_AR_GR, per_ARGARCH_GR, per_pred_VR, per_pred_eps] = MC_predict_VR(full_reg_data.p_min_e, full_reg_data.r_m, mc_time);

% [pdd_AR_GR, pdd_ARGARCH_GR, pdd_pred_VR, pdd_pred_eps] = MC_predict_VR(full_reg_data.p_min_d, full_reg_data.g_d);
% [ped_AR_GR, ped_ARGARCH_GR, ped_pred_VR, ped_pred_eps] = MC_predict_VR(full_reg_data.p_min_e, full_reg_data.g_d);


%% Table_2

f2 = figure('Name','Consumption growth and market return projection','NumberTitle','off');

table_2_data = cell(19,10);

table_2_data(1:19,1) = {'AR(1) estimates',[] ,'Panel A: Consumption growth','Estimate','S.E.'...
    ,[] ,'Panel B: Market return','Estimate','S.E.'...
    ,[] ,'AR(1)-GARCH(1,1) estimates',[] ,'Panel C: Consumption','Estimate','S.E.'...
    ,[] ,'Panel D: Market return','Estimate','S.E.'};

table_2_data([4,5,8,9],[2,3,8,9,10]) = num2cell([pdc_AR_GR.coef', pdc_AR_GR.AC'; pdc_AR_GR.se', pdc_AR_GR.Q.stat;...
    pdr_AR_GR.coef', pdr_AR_GR.AC';pdr_AR_GR.se', pdr_AR_GR.Q.stat]);

table_2_data([14,15,18,19],[2,3,4,5,6]) = num2cell([pdc_ARGARCH_GR.coef';pdc_ARGARCH_GR.se';...
    pdr_ARGARCH_GR.coef';pdr_ARGARCH_GR.se']);

table_2_data([14,15,18,19],4) = ...
    {EstMdl_gc_ARGARCH.Variance.Constant,sqrt(EstParamCov_gc_ARGARCH(3,3)),...
    EstMdl_rm_ARGARCH.Variance.Constant,sqrt(EstParamCov_rm_ARGARCH(3,3))};

table_2_data([4,5,8,9],7) = {'Estimate','Q-stat','Estimate','Q-stat'};


f2.Position = [560,528,900,450];

table_2 = uitable(f2,'Data',table_2_data,'Position',[40 30 715 385]);

table_2.Position = [40 30 775 385];

table_2.ColumnWidth = {150,65,65,65,65,65,65,65,65,65};
table_2.ColumnName = {[],'const','A1','w0','w1','w2',[],'AC(1)','AC(4)','AC(8)'};

%% Table 3

table_3_data = cell(9,14);
table_3_data([2:4,7:9],1) = num2cell([1,4,8,1,4,8]);
table_3_data([1,6],1) = {'Panel A: price-dividend ratio','Panel B: price-earnings ratio'};

table_3_data([2,3,4],[2,3,4,5,6,7]) = ...
    num2cell([pdc_pred_VR.lag1.b,  pdc_pred_VR.lag1.t, pdc_pred_VR.lag1.r_2,...
    pdc_pred_VR.lag1.sim_t_2_5, pdc_pred_VR.lag1.sim_t_5, pdc_pred_VR.lag1.sim_r_2_95;...
    pdc_pred_VR.lag4.b,  pdc_pred_VR.lag4.t, pdc_pred_VR.lag4.r_2,...
    pdc_pred_VR.lag4.sim_t_2_5, pdc_pred_VR.lag4.sim_t_5, pdc_pred_VR.lag4.sim_r_2_95;...
    pdc_pred_VR.lag8.b,  pdc_pred_VR.lag8.t, pdc_pred_VR.lag8.r_2,...
    pdc_pred_VR.lag8.sim_t_2_5, pdc_pred_VR.lag8.sim_t_5, pdc_pred_VR.lag8.sim_r_2_95]);

table_3_data([2,3,4],[9,10,11,12,13,14]) = ...
    num2cell([pdr_pred_VR.lag1.b,  pdr_pred_VR.lag1.t, pdr_pred_VR.lag1.r_2,...
    pdr_pred_VR.lag1.sim_t_2_5, pdr_pred_VR.lag1.sim_t_5, pdr_pred_VR.lag1.sim_r_2_95;...
    pdr_pred_VR.lag4.b,  pdr_pred_VR.lag4.t, pdr_pred_VR.lag4.r_2,...
    pdr_pred_VR.lag4.sim_t_2_5, pdr_pred_VR.lag4.sim_t_5, pdr_pred_VR.lag4.sim_r_2_95;...
    pdr_pred_VR.lag8.b,  pdr_pred_VR.lag8.t, pdr_pred_VR.lag8.r_2,...
    pdr_pred_VR.lag8.sim_t_2_5, pdr_pred_VR.lag8.sim_t_5, pdr_pred_VR.lag8.sim_r_2_95]);

table_3_data([7,8,9],[2,3,4,5,6,7]) = ...
    num2cell([pec_pred_VR.lag1.b,  pec_pred_VR.lag1.t, pec_pred_VR.lag1.r_2,...
    pec_pred_VR.lag1.sim_t_2_5, pec_pred_VR.lag1.sim_t_5, pec_pred_VR.lag1.sim_r_2_95;...
    pec_pred_VR.lag4.b,  pec_pred_VR.lag4.t, pec_pred_VR.lag4.r_2,...
    pec_pred_VR.lag4.sim_t_2_5, pec_pred_VR.lag4.sim_t_5, pec_pred_VR.lag4.sim_r_2_95;...
    pec_pred_VR.lag8.b,  pec_pred_VR.lag8.t, pec_pred_VR.lag8.r_2,...
    pec_pred_VR.lag8.sim_t_2_5, pec_pred_VR.lag8.sim_t_5, pec_pred_VR.lag8.sim_r_2_95]);

table_3_data([7,8,9],[9,10,11,12,13,14]) = ...
    num2cell([per_pred_VR.lag1.b,  per_pred_VR.lag1.t, per_pred_VR.lag1.r_2,...
    per_pred_VR.lag1.sim_t_2_5, per_pred_VR.lag1.sim_t_5, per_pred_VR.lag1.sim_r_2_95;...
    per_pred_VR.lag4.b,  per_pred_VR.lag4.t, per_pred_VR.lag4.r_2,...
    per_pred_VR.lag4.sim_t_2_5, per_pred_VR.lag4.sim_t_5, per_pred_VR.lag4.sim_r_2_95;...
    per_pred_VR.lag8.b,  per_pred_VR.lag8.t, per_pred_VR.lag8.r_2,...
    per_pred_VR.lag8.sim_t_2_5, per_pred_VR.lag8.sim_t_5, per_pred_VR.lag8.sim_r_2_95]);


clf

f3 = figure('Name','Economic uncertainty predicting future valuation ratios: USA','NumberTitle','off');


f3.Position = [560,528,1070,250];

table_3 = uitable(f3,'Data',table_3_data,'Position',[20 30 1030 200]);
table_3.Position = [20 30 1030 200];

table_3.ColumnWidth = {150,65,65,65,65,65,65,65,65,65,65,65,65,65};
table_3.ColumnName = {'J', 'b', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)',[], 'b', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)'};

%% Table 4

table_4_data = cell(9,14);
table_4_data([2:4,7:9],1) = num2cell([1,4,8,1,4,8]);
table_4_data([1,6],1) = {'Panel A: price-dividend ratio','Panel B: price-earnings ratio'};


table_4_data([2,3,4],[2,3,4,5,6,7]) = ...
    num2cell([pdc_pred_eps.lag1.a,  pdc_pred_eps.lag1.t, pdc_pred_eps.lag1.r_2,...
    pdc_pred_eps.lag1.sim_t_2_5, pdc_pred_eps.lag1.sim_t_5, pdc_pred_eps.lag1.sim_r_2_95;...
    pdc_pred_eps.lag4.a,  pdc_pred_eps.lag4.t, pdc_pred_eps.lag4.r_2,...
    pdc_pred_eps.lag4.sim_t_2_5, pdc_pred_eps.lag4.sim_t_5, pdc_pred_eps.lag4.sim_r_2_95;...
    pdc_pred_eps.lag8.a,  pdc_pred_eps.lag8.t, pdc_pred_eps.lag8.r_2,...
    pdc_pred_eps.lag8.sim_t_2_5, pdc_pred_eps.lag8.sim_t_5, pdc_pred_eps.lag8.sim_r_2_95]);

table_4_data([2,3,4],[9,10,11,12,13,14]) = ...
    num2cell([pdr_pred_eps.lag1.a,  pdr_pred_eps.lag1.t, pdr_pred_eps.lag1.r_2,...
    pdr_pred_eps.lag1.sim_t_2_5, pdr_pred_eps.lag1.sim_t_5, pdr_pred_eps.lag1.sim_r_2_95;...
    pdr_pred_eps.lag4.a,  pdr_pred_eps.lag4.t, pdr_pred_eps.lag4.r_2,...
    pdr_pred_eps.lag4.sim_t_2_5, pdr_pred_eps.lag4.sim_t_5, pdr_pred_eps.lag4.sim_r_2_95;...
    pdr_pred_eps.lag8.a,  pdr_pred_eps.lag8.t, pdr_pred_eps.lag8.r_2,...
    pdr_pred_eps.lag8.sim_t_2_5, pdr_pred_eps.lag8.sim_t_5, pdr_pred_eps.lag8.sim_r_2_95]);

table_4_data([7,8,9],[2,3,4,5,6,7]) = ...
    num2cell([pec_pred_eps.lag1.a,  pec_pred_eps.lag1.t, pec_pred_eps.lag1.r_2,...
    pec_pred_eps.lag1.sim_t_2_5, pec_pred_eps.lag1.sim_t_5, pec_pred_eps.lag1.sim_r_2_95;...
    pec_pred_eps.lag4.a,  pec_pred_eps.lag4.t, pec_pred_eps.lag4.r_2,...
    pec_pred_eps.lag4.sim_t_2_5, pec_pred_eps.lag4.sim_t_5, pec_pred_eps.lag4.sim_r_2_95;...
    pec_pred_eps.lag8.a,  pec_pred_eps.lag8.t, pec_pred_eps.lag8.r_2,...
    pec_pred_eps.lag8.sim_t_2_5, pec_pred_eps.lag8.sim_t_5, pec_pred_eps.lag8.sim_r_2_95]);

table_4_data([7,8,9],[9,10,11,12,13,14]) = ...
    num2cell([per_pred_eps.lag1.a,  per_pred_eps.lag1.t, per_pred_eps.lag1.r_2,...
    per_pred_eps.lag1.sim_t_2_5, per_pred_eps.lag1.sim_t_5, per_pred_eps.lag1.sim_r_2_95;...
    per_pred_eps.lag4.a,  per_pred_eps.lag4.t, per_pred_eps.lag4.r_2,...
    per_pred_eps.lag4.sim_t_2_5, per_pred_eps.lag4.sim_t_5, per_pred_eps.lag4.sim_r_2_95;...
    per_pred_eps.lag8.a,  per_pred_eps.lag8.t, per_pred_eps.lag8.r_2,...
    per_pred_eps.lag8.sim_t_2_5, per_pred_eps.lag8.sim_t_5, per_pred_eps.lag8.sim_r_2_95]);


clf

f4 = figure('Name','Valuation ratios prediction future economic uncertainty: USA','NumberTitle','off');


f4.Position = [560,528,1070,250];

table_4 = uitable(f4,'Data',table_4_data,'Position',[20 30 1030 200]);
table_4.Position = [20 30 1030 200];

table_4.ColumnWidth = {150,65,65,65,65,65,65,65,65,65,65,65,65,65};
table_4.ColumnName = {'J', 'a', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)',[], 'a', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)'};


%% Table 5


table_5_data = cell(15,8);
table_5_data([1:3,5:7,9:11,13:15],1) = {'Panel A:Predicting price-earnings ratio','p_t - e_t = a0 + a1*log(sigma_c_t-1^2) + eps_t',...
    'a1', 'p_t - e_t = a0 +  a1*(p_t-1 - e_t-1)+ a2*log(sigma_c_t-1^2)  + eps_t','a2','a1',...
    'Panel B: Predicting volatility','log(sigma_c_t^2) = a0 + a1*(p_t-1 - e_t-1) + eps_t',...
    'a1', 'log(sigma_c_t^2) = a0 + a1*(p_t-1 - e_t-1) + a2*log(sigma_c_t-1^2) + eps_t'...
    'a1','a2'};

table_5_data(3,[2,3,4,5,6,7,8]) = ...
    num2cell([pec_pred_GR.mdl1.a1,  pec_pred_GR.mdl1.t1 , pec_pred_GR.mdl1.r_2,  pec_pred_GR.mdl1.sim_t1_2_5,...
    pec_pred_GR.mdl1.sim_t1_5, pec_pred_GR.mdl1.sim_r_2_95, pec_pred_GR.mdl1.sim_r_2_975]);

table_5_data([6,7],[2,3,4,5,6,7,8]) = ...
    num2cell([pec_pred_GR.mdl2.a1,  pec_pred_GR.mdl2.t1 , pec_pred_GR.mdl2.r_2,  pec_pred_GR.mdl2.sim_t1_2_5,...
    pec_pred_GR.mdl2.sim_t1_5, pec_pred_GR.mdl2.sim_r_2_95, pec_pred_GR.mdl2.sim_r_2_975;...
    pec_pred_GR.mdl2.a2,  pec_pred_GR.mdl2.t2 , nan,  pec_pred_GR.mdl2.sim_t2_2_5,...
    pec_pred_GR.mdl2.sim_t2_5, nan, nan]);

table_5_data(11,[2,3,4,5,6,7,8]) = ...
    num2cell([pec_pred_GR.mdl3.a1,  pec_pred_GR.mdl3.t1 , pec_pred_GR.mdl3.r_2,  pec_pred_GR.mdl3.sim_t1_2_5,...
    pec_pred_GR.mdl3.sim_t1_5, pec_pred_GR.mdl3.sim_r_2_95, pec_pred_GR.mdl3.sim_r_2_975]);

table_5_data([14,15],[2,3,4,5,6,7,8]) = ...
    num2cell([pec_pred_GR.mdl4.a1,  pec_pred_GR.mdl4.t1 , pec_pred_GR.mdl4.r_2,  pec_pred_GR.mdl4.sim_t1_2_5,...
    pec_pred_GR.mdl4.sim_t1_5, pec_pred_GR.mdl4.sim_r_2_95, pec_pred_GR.mdl4.sim_r_2_975;...
    pec_pred_GR.mdl4.a2,  pec_pred_GR.mdl4.t2 , nan,  pec_pred_GR.mdl4.sim_t2_2_5,...
    pec_pred_GR.mdl4.sim_t2_5, nan, nan]);

table_5_data([7,15],[4,7,8]) = {[],[],[];[],[],[]};

clf

f5 = figure('Name','Price-earnings ratios and economic uncertainty: USA','NumberTitle','off');


f5.Position = [560,528,940,360];

table_5 = uitable(f5,'Data',table_5_data,'Position',[20 30 880 310]);
table_5.Position = [20 30 880 310];

table_5.ColumnWidth = {370,65,65,65,65,65,65,80};
table_5.ColumnName = {'J', 'a', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)','R^2(97.25%)'};


%% table_6

epd = pred_sum_GR(full_reg_data.g_e, full_reg_data.p_min_d);
epe = pred_sum_GR(full_reg_data.g_e, full_reg_data.p_min_e);
dpd = pred_sum_GR(full_reg_data.g_d, full_reg_data.p_min_d);
dpe = pred_sum_GR(full_reg_data.g_d, full_reg_data.p_min_e);
rpd = pred_sum_GR(full_reg_data.r_m, full_reg_data.p_min_d);
rpe = pred_sum_GR(full_reg_data.r_m, full_reg_data.p_min_e);


% table_6_data

table_6_data = cell(11,12);
table_6_data([1:5,7:11],1) = {'Panel A: Price-dividend ratio', 4, 8, 12, 16, ...
    'Panel B: Price-earnings ratio', 4, 8, 12, 16};

table_6_data(2:5,2:4) = num2cell([epd.b, epd.t, epd.r_2]);

table_6_data(8:11,2:4) = num2cell([epe.b, epe.t, epe.r_2]);

table_6_data(2:5,6:8) = num2cell([dpd.b, dpd.t, dpd.r_2]);

table_6_data(8:11,6:8) = num2cell([dpe.b, dpe.t, dpe.r_2]);

table_6_data(2:5,10:12) = num2cell([rpd.b, rpd.t, rpd.r_2]);

table_6_data(8:11,10:12) = num2cell([rpe.b, rpe.t, rpe.r_2]);

clf

f6 = figure('Name','Price-earnings ratios and economic uncertainty: USA','NumberTitle','off');


f6.Position = [560,528,840,270];

table_6 = uitable(f6,'Data',table_6_data,'Position',[20 30 805 235]);
table_6.Position = [20 30 805 235];

table_6.ColumnWidth = {140,65,65,65,20,65,65,65,20,65,65,65};
table_6.ColumnName = {'J', 'beta_J', 't-stat', 'R^2', [], 'beta_J', 't-stat', 'R^2', [],'beta_J', 't-stat', 'R^2'};

%% Table 7

epe_MC = pred_sum_GR_MC(full_reg_data.g_e, per_pred_VR.sim_VR);


% table_7_data

table_7_data = cell(5,8);
table_7_data(1:5,1) = {'Earning growth rate : Price-earnings ratio', 4, 8, 12, 16};

table_7_data(2:5,2:4) = num2cell([epe.b, epe.t, epe.r_2]);
table_7_data(2:5,5:8) = num2cell([epe_MC.t_90', epe_MC.t_95', epe_MC.t_975', epe_MC.r_2_95']);


f7 = figure('Name','Price-earnings ratios and growth rates','NumberTitle','off');

f7.Position = [280,20,775,160];

table_7 = uitable(f7,'Data',table_7_data,'Position',[20 30 775 125]);
table_7.Position = [20 30 775 125];

table_7.ColumnWidth = {220,65,65,65};
table_7.ColumnName = {'J', 'beta_J', 't-stat', 'R^2', 't(90%)', 't(95%)', 't(97.5%)', 'R^2(95%)'};

save final_copy

load('final_copy.mat')
