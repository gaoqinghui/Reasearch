%% Empirical
clear global

cd('J:\WISE\Ren yu\Interpretable asset markets\Data');
load('data_complete_deseasonallized_D.mat');


%% Summary statistics

f1 = figure('Name','Summary statistics','NumberTitle','off');

t = uitable(f1,'Data',table_data,'Position',[40 220 450 140]);
t.RowName = RowName;
t.ColumnName = ColumnName;


sub_t = uitable(f1,'Data',sub_table_data,'Position',[40 80 450 140]);
sub_t.RowName =  RowName;
sub_t.ColumnName = ColumnName;

%% Table 2

% Set up the random seed
rnd_seed = 20170906;
rng(rnd_seed);

AR = arima('ARlags', 1);

ARGARCH =  arima('ARLags',1,'Variance',garch(1,1));

[EstMdl_gc_AR,EstParamCov_gc_AR] = estimate(AR, full_data(:,2));

[EstMdl_rm_AR,EstParamCov_rm_AR] = estimate(AR, full_data(:,5));

[EstMdl_gc_ARGARCH,EstParamCov_gc_ARGARCH] = estimate(ARGARCH, full_data(:,2));

[EstMdl_rm_ARGARCH,EstParamCov_rm_ARGARCH] = estimate(ARGARCH, full_data(:,5));



[res_gc_AR] = infer(EstMdl_gc_AR,full_data(:,2));
[res_rm_AR] = infer(EstMdl_rm_AR,full_data(:,5));

AC_AR(:,1) = autocorr(abs(res_gc_AR));
AC_AR(:,2) = autocorr(abs(res_rm_AR));

AC_AR([2,5,8],:);

[h_gc, pValue_gc, stat_gc] = lbqtest(abs(res_gc_AR),'lags',[1,4,8]);

[h_rm, pValue_rm, stat_rm] = lbqtest(abs(res_rm_AR),'lags',[1,4,8]);

clf


f2 = figure('Name','Consumption growth and market return projection','NumberTitle','off');


f2_data(1:19,1) = {'AR(1) estimates',[] ,'Panel A: Consumption growth','Estimate','S.E.'...
    ,[] ,'Panel B: Market return','Estimate','S.E.'...
    ,[] ,'AR(1)-GARCH(1,1) estimates',[] ,'Panel C: Consumption','Estimate','S.E.'...
    ,[] ,'Panel D: Market return','Estimate','S.E.'};

f2_data([4,5,8,9,14,15,18,19],2) = {EstMdl_gc_AR.Constant,sqrt(EstParamCov_gc_AR(1,1)),...
    EstMdl_rm_AR.Constant,sqrt(EstParamCov_rm_AR(1,1)),...
    EstMdl_gc_ARGARCH.Constant,sqrt(EstParamCov_gc_ARGARCH(1,1)),...
    EstMdl_rm_ARGARCH.Constant,sqrt(EstParamCov_rm_ARGARCH(1,1))};

f2_data([4,5,8,9,14,15,18,19],3) = {EstMdl_gc_AR.AR{1},sqrt(EstParamCov_gc_AR(2,2)),...
    EstMdl_rm_AR.AR{1},sqrt(EstParamCov_rm_AR(2,2)),...
    EstMdl_gc_ARGARCH.AR{1},sqrt(EstParamCov_gc_ARGARCH(2,2)),...
    EstMdl_rm_ARGARCH.AR{1},sqrt(EstParamCov_rm_ARGARCH(2,2))};

f2_data([14,15,18,19],4) = ...
    {EstMdl_gc_ARGARCH.Variance.Constant,sqrt(EstParamCov_gc_ARGARCH(3,3)),...
    EstMdl_rm_ARGARCH.Variance.Constant,sqrt(EstParamCov_rm_ARGARCH(3,3))};

f2_data([14,15,18,19],5) = ...
    {EstMdl_gc_ARGARCH.Variance.ARCH{1},sqrt(EstParamCov_gc_ARGARCH(5,5)),...
    EstMdl_rm_ARGARCH.Variance.ARCH{1},sqrt(EstParamCov_rm_ARGARCH(5,5))};

f2_data([14,15,18,19],6) = ...
    {EstMdl_gc_ARGARCH.Variance.GARCH{1},sqrt(EstParamCov_gc_ARGARCH(4,4)),...
    EstMdl_rm_ARGARCH.Variance.GARCH{1},sqrt(EstParamCov_rm_ARGARCH(4,4))};

f2_data([4,5,8,9],7) = {'Estimate','Q-stat','Estimate','Q-stat'};

f2_data(4,[8,9,10]) = {AC_AR(2,1) AC_AR(5,1) AC_AR(9,1)};
f2_data(8,[8,9,10]) = {AC_AR(2,2) AC_AR(5,2) AC_AR(9,2)};

f2_data(5,[8,9,10]) = {stat_gc(1)  stat_gc(2)  stat_gc(3)};
f2_data(9,[8,9,10]) = {stat_rm(1)  stat_rm(2)  stat_rm(3)};

f2.Position = [560,528,900,450];

table_2 = uitable(f2,'Data',f2_data,'Position',[40 30 715 385]);
table_2.Position = [40 30 775 385];

table_2.ColumnWidth = {150,65,65,65,65,65,65,65,65,65};
table_2.ColumnName = {[],'const','A1','w0','w1','w2',[],'AC(1)','AC(4)','AC(8)'};



%% Table 3


[res_gc_ARGARCH, v_gc_ARGARCH] = infer(EstMdl_gc_ARGARCH,full_data(:,2));
[res_rm_ARGARCH, v_rm_ARGARCH] = infer(EstMdl_rm_ARGARCH,full_data(:,5));


% full_reg_data.vc =  v_gc_ARGARCH;
% full_reg_data.vr_lag1 =  [nan; v_gc_ARGARCH(1:end-1)];
% full_reg_data.vr_lag4 =  [ones(4,1)*nan; v_gc_ARGARCH(1:end-4)];
% full_reg_data.vr_lag8 =  [ones(8,1)*nan; v_gc_ARGARCH(1:end-8)];
% 
% full_reg_data.vr =  v_rm_ARGARCH;
% full_reg_data.vr_lag1 =  [nan; v_rm_ARGARCH(1:end-1)];
% full_reg_data.vr_lag4 =  [ones(4,1)*nan; v_rm_ARGARCH(1:end-4)];
% full_reg_data.vr_lag8 =  [ones(8,1)*nan; v_rm_ARGARCH(1:end-8)];

% generate sigma

% gen_sigma_J is a function defined by me

res_gc_AR = abs(res_gc_AR);
res_rm_AR = abs(res_rm_AR);

full_reg_data.sigma_c_1 =  [nan; gen_sigma_J(res_gc_AR, 1)];
full_reg_data.sigma_c_4 =  [ones(4,1)*nan; gen_sigma_J(res_gc_AR, 4)];
full_reg_data.sigma_c_8  =  [ones(8,1)*nan;gen_sigma_J(res_gc_AR, 8)];

full_reg_data.sigma_r_1 =  [nan; gen_sigma_J(res_rm_AR, 1)];
full_reg_data.sigma_r_4 =  [ones(4,1)*nan; gen_sigma_J(res_rm_AR, 4)];
full_reg_data.sigma_r_8  =  [ones(8,1)*nan;gen_sigma_J(res_rm_AR, 8)];


fitlm(full_reg_data.p_min_d,full_reg_data.sigma_c_1')
fitlm(full_reg_data,'p_min_d~sigma_c_1')


pd_vc_1 = fitlm(full_reg_data,'p_min_d~sigma_c_1');


pd_vc_4 = fitlm(full_reg_data,'p_min_d~sigma_c_4');
pd_vc_8 = fitlm(full_reg_data,'p_min_d~sigma_c_8');

pd_vr_1 = fitlm(full_reg_data,'p_min_d~sigma_r_1');
pd_vr_4 = fitlm(full_reg_data,'p_min_d~sigma_r_4');
pd_vr_8 = fitlm(full_reg_data,'p_min_d~sigma_r_8');

pe_vc_1 = fitlm(full_reg_data,'p_min_e~sigma_c_1');
pe_vc_4 = fitlm(full_reg_data,'p_min_e~sigma_c_4');
pe_vc_8 = fitlm(full_reg_data,'p_min_e~sigma_c_8');

pe_vr_1 = fitlm(full_reg_data,'p_min_e~sigma_r_1');
pe_vr_4 = fitlm(full_reg_data,'p_min_e~sigma_r_4');
pe_vr_8 = fitlm(full_reg_data,'p_min_e~sigma_r_8');


% table 3
table_3_data = cell(9,14);
table_3_data([2:4,7:9],1) = num2cell([1,4,8,1,4,8]);
table_3_data([1,6],1) = {'Panel A: price-dividend ratio','Panel B: price-earnings ratio'};

table_3_data([2,3,4],[2,3,4]) = {...
    pd_vc_1.Coefficients.Estimate(2), pd_vc_1.Coefficients.tStat(2),pd_vc_1.Rsquared.Adjusted;...
    pd_vc_4.Coefficients.Estimate(2), pd_vc_4.Coefficients.tStat(2),pd_vc_4.Rsquared.Adjusted;...
    pd_vc_8.Coefficients.Estimate(2), pd_vc_8.Coefficients.tStat(2),pd_vc_8.Rsquared.Adjusted};

table_3_data([2,3,4],[9,10,11]) = {...
    pd_vr_1.Coefficients.Estimate(2), pd_vr_1.Coefficients.tStat(2),pd_vr_1.Rsquared.Adjusted;...
    pd_vr_4.Coefficients.Estimate(2), pd_vr_4.Coefficients.tStat(2),pd_vr_4.Rsquared.Adjusted;...
    pd_vr_8.Coefficients.Estimate(2), pd_vr_8.Coefficients.tStat(2),pd_vr_8.Rsquared.Adjusted};

table_3_data([7,8,9],[2,3,4]) = {...
    pe_vc_1.Coefficients.Estimate(2), pe_vc_1.Coefficients.tStat(2),pe_vc_1.Rsquared.Adjusted;...
    pe_vc_4.Coefficients.Estimate(2), pe_vc_4.Coefficients.tStat(2),pe_vc_4.Rsquared.Adjusted;...
    pe_vc_8.Coefficients.Estimate(2), pe_vc_8.Coefficients.tStat(2),pe_vc_8.Rsquared.Adjusted};

table_3_data([7,8,9],[9,10,11]) = {...
    pe_vr_1.Coefficients.Estimate(2), pe_vr_1.Coefficients.tStat(2),pe_vr_1.Rsquared.Adjusted;...
    pe_vr_4.Coefficients.Estimate(2), pe_vr_4.Coefficients.tStat(2),pe_vr_4.Rsquared.Adjusted;...
    pe_vr_8.Coefficients.Estimate(2), pe_vr_8.Coefficients.tStat(2),pe_vr_8.Rsquared.Adjusted};


clf

f3 = figure('Name','Economic uncertainty predicting future valuation ratios: USA','NumberTitle','off');


f3.Position = [560,528,1070,250];

table_3 = uitable(f3,'Data',table_3_data,'Position',[20 30 1030 200]);
table_3.Position = [20 30 1030 200];

table_3.ColumnWidth = {150,65,65,65,65,65,65,65,65,65,65,65,65,65};
table_3.ColumnName = {'J', 'b', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)',[], 'b', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)'};

%% Figure 1

clf

full_reg_data.sigma_c_12  =  [ones(12,1)*nan;gen_sigma_J(res_gc_AR, 12)];

subplot(2,1,1)
plot(zscore(full_reg_data.p_min_e(13:end)),'r')
hold on
plot(zscore(full_reg_data.sigma_c_12(13:end)),'b')
title(' Consumption Volatility against log price-earnings ratio');
legend('(p_t - e_t)','\sigma_{c,t-1,12}','Location','north')

subplot(2,1,2)
plot(zscore(full_reg_data.p_min_e(13:end)),'r')
hold on
plot(zscore(full_reg_data.g_e(13:end)-full_reg_data.g_e(1:end-12)),'b')
title(' 12 quarter earnings against log price-earnings ratio');
legend('(p_t - e_t)','(e_t - e_{t-12})','Location','north')


%% table 4


full_reg_data.abs_eta_c_1 = [abs(res_gc_AR(2:end)); nan];
full_reg_data.abs_eta_c_4 = [abs(res_gc_AR(5:end)); ones(4,1)*nan];
full_reg_data.abs_eta_c_8 = [abs(res_gc_AR(9:end)); ones(8,1)*nan];

full_reg_data.abs_eta_r_1 = [abs(res_rm_AR(2:end)); nan];
full_reg_data.abs_eta_r_4 = [abs(res_rm_AR(5:end)); ones(4,1)*nan];
full_reg_data.abs_eta_r_8 = [abs(res_rm_AR(9:end)); ones(8,1)*nan];


eta_c_pd_1 = fitlm(full_reg_data,'abs_eta_c_1~p_min_d');
eta_c_pd_4 = fitlm(full_reg_data,'abs_eta_c_4~p_min_d');
eta_c_pd_8 = fitlm(full_reg_data,'abs_eta_c_8~p_min_d');

eta_r_pd_1 = fitlm(full_reg_data,'abs_eta_r_1~p_min_d');
eta_r_pd_4 = fitlm(full_reg_data,'abs_eta_r_4~p_min_d');
eta_r_pd_8 = fitlm(full_reg_data,'abs_eta_r_8~p_min_d');

eta_c_pe_1 = fitlm(full_reg_data,'abs_eta_c_1~p_min_e');
eta_c_pe_4 = fitlm(full_reg_data,'abs_eta_c_4~p_min_e');
eta_c_pe_8 = fitlm(full_reg_data,'abs_eta_c_8~p_min_e');

eta_r_pe_1 = fitlm(full_reg_data,'abs_eta_r_1~p_min_e');
eta_r_pe_4 = fitlm(full_reg_data,'abs_eta_r_4~p_min_e');
eta_r_pe_8 = fitlm(full_reg_data,'abs_eta_r_8~p_min_e');


% table 4
table_4_data = cell(9,14);
table_4_data([2:4,7:9],1) = num2cell([1,4,8,1,4,8]);
table_4_data([1,6],1) = {'Panel A: price-dividend ratio','Panel B: price-earnings ratio'};

table_4_data([2,3,4],[2,3,4]) = {...
    eta_c_pd_1.Coefficients.Estimate(2), eta_c_pd_1.Coefficients.tStat(2),eta_c_pd_1.Rsquared.Adjusted;...
    eta_c_pd_4.Coefficients.Estimate(2), eta_c_pd_4.Coefficients.tStat(2),eta_c_pd_4.Rsquared.Adjusted;...
    eta_c_pd_8.Coefficients.Estimate(2), eta_c_pd_8.Coefficients.tStat(2),eta_c_pd_8.Rsquared.Adjusted};

table_4_data([2,3,4],[9,10,11]) = {...
    eta_r_pd_1.Coefficients.Estimate(2), eta_r_pd_1.Coefficients.tStat(2),eta_r_pd_1.Rsquared.Adjusted;...
    eta_r_pd_4.Coefficients.Estimate(2), eta_r_pd_4.Coefficients.tStat(2),eta_r_pd_4.Rsquared.Adjusted;...
    eta_r_pd_8.Coefficients.Estimate(2), eta_r_pd_8.Coefficients.tStat(2),eta_r_pd_8.Rsquared.Adjusted};

table_4_data([7,8,9],[2,3,4]) = {...
    eta_c_pe_1.Coefficients.Estimate(2), eta_c_pe_1.Coefficients.tStat(2),eta_c_pe_1.Rsquared.Adjusted;...
    eta_c_pe_4.Coefficients.Estimate(2), eta_c_pe_4.Coefficients.tStat(2),eta_c_pe_4.Rsquared.Adjusted;...
    eta_c_pe_8.Coefficients.Estimate(2), eta_c_pe_8.Coefficients.tStat(2),eta_c_pe_8.Rsquared.Adjusted};

table_4_data([7,8,9],[9,10,11]) = {...
    eta_r_pe_1.Coefficients.Estimate(2), eta_r_pe_1.Coefficients.tStat(2),eta_r_pe_1.Rsquared.Adjusted;...
    eta_r_pe_4.Coefficients.Estimate(2), eta_r_pe_4.Coefficients.tStat(2),eta_r_pe_4.Rsquared.Adjusted;...
    eta_r_pe_8.Coefficients.Estimate(2), eta_r_pe_8.Coefficients.tStat(2),eta_r_pe_8.Rsquared.Adjusted};


clf

f4 = figure('Name','Valuation ratios prediction future economic uncertainty: USA','NumberTitle','off');


f4.Position = [560,528,1070,250];

table_4 = uitable(f4,'Data',table_4_data,'Position',[20 30 1030 200]);
table_4.Position = [20 30 1030 200];

table_4.ColumnWidth = {150,65,65,65,65,65,65,65,65,65,65,65,65,65};
table_4.ColumnName = {'J', 'a', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)',[], 'a', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)'};


%% Table 5

full_reg_data.logvc = log(v_gc_ARGARCH);
full_reg_data.logvc_lag1 =  [nan;log(v_gc_ARGARCH(1:end-1))];
full_reg_data.p_min_e_lag1 =  [nan;full_reg_data.p_min_e(1:end-1)];


pe_logvc = fitlm(full_reg_data, 'p_min_e~logvc_lag1');

pe_ar_logvc = fitlm(full_reg_data, 'p_min_e~p_min_e_lag1+logvc_lag1');

logvc_pe = fitlm(full_reg_data, 'logvc~p_min_e_lag1');

logvc_ar_pe = fitlm(full_reg_data, 'logvc~p_min_e_lag1+logvc_lag1');


% table 5
table_5_data = cell(15,8);
table_5_data([1:3,5:7,9:11,13:15],1) = {'Panel A:Predicting price-earnings ratio','p_t - e_t = a0 + a1*log(sigma_c_t-1^2) + eps_t',...
    'a1', 'p_t - e_t = a0 +  a1*(p_t-1 - e_t-1)+ a2*log(sigma_c_t-1^2)  + eps_t','a2','a1',...
    'Panel B: Predicting volatility','log(sigma_c_t^2) = a0 + a1*(p_t-1 - e_t-1) + eps_t',...
    'a1', 'log(sigma_c_t^2) = a0 + a1*(p_t-1 - e_t-1) + a2*log(sigma_c_t-1^2) + eps_t'...
    'a1','a2'};

table_5_data(3,[2,3,4]) = {...
    pe_logvc.Coefficients.Estimate(2), pe_logvc.Coefficients.tStat(2),pe_logvc.Rsquared.Adjusted};

table_5_data([6,7],[2,3,4]) = {...
    pe_ar_logvc.Coefficients.Estimate(2), pe_ar_logvc.Coefficients.tStat(2), pe_ar_logvc.Rsquared.Adjusted;...
   pe_ar_logvc.Coefficients.Estimate(3), pe_ar_logvc.Coefficients.tStat(3),[]};

table_5_data(11,[2,3,4]) = {...
    logvc_pe.Coefficients.Estimate(2), logvc_pe.Coefficients.tStat(2),logvc_pe.Rsquared.Adjusted};

table_5_data([14,15],[2,3,4]) = {...
    logvc_ar_pe.Coefficients.Estimate(3),  logvc_ar_pe.Coefficients.tStat(3), logvc_ar_pe.Rsquared.Adjusted;...
     logvc_ar_pe.Coefficients.Estimate(2),  logvc_ar_pe.Coefficients.tStat(2), []};


clf

f5 = figure('Name','Price-earnings ratios and economic uncertainty: USA','NumberTitle','off');


f5.Position = [560,528,940,360];

table_5 = uitable(f5,'Data',table_5_data,'Position',[20 30 880 310]);
table_5.Position = [20 30 880 310];

table_5.ColumnWidth = {370,65,65,65,65,65,65,80};
table_5.ColumnName = {'J', 'a', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)','R^2(97.25%)'};


%% Table 6

full_reg_data.sum_ge_4 = [gen_sum_J(full_reg_data.g_e, 4); ones(4,1)*nan];
full_reg_data.sum_ge_8 = [gen_sum_J(full_reg_data.g_e, 8); ones(8,1)*nan];
full_reg_data.sum_ge_12 = [gen_sum_J(full_reg_data.g_e, 12); ones(12,1)*nan];
full_reg_data.sum_ge_16 = [gen_sum_J(full_reg_data.g_e, 16); ones(16,1)*nan];

full_reg_data.sum_gd_4 = [gen_sum_J(full_reg_data.g_d, 4); ones(4,1)*nan];
full_reg_data.sum_gd_8 = [gen_sum_J(full_reg_data.g_d, 8); ones(8,1)*nan];
full_reg_data.sum_gd_12 = [gen_sum_J(full_reg_data.g_d, 12); ones(12,1)*nan];
full_reg_data.sum_gd_16 = [gen_sum_J(full_reg_data.g_d, 16); ones(16,1)*nan];

full_reg_data.sum_rm_4 = [gen_sum_J(full_reg_data.r_m, 4); ones(4,1)*nan];
full_reg_data.sum_rm_8 = [gen_sum_J(full_reg_data.r_m, 8); ones(8,1)*nan];
full_reg_data.sum_rm_12 = [gen_sum_J(full_reg_data.r_m, 12); ones(12,1)*nan];
full_reg_data.sum_rm_16 = [gen_sum_J(full_reg_data.r_m, 16); ones(16,1)*nan];

% model

sum_ge_4_pd = fitlm(full_reg_data, 'sum_ge_4~p_min_d');
sum_ge_8_pd = fitlm(full_reg_data, 'sum_ge_8~p_min_d');
sum_ge_12_pd = fitlm(full_reg_data, 'sum_ge_12~p_min_d');
sum_ge_16_pd = fitlm(full_reg_data, 'sum_ge_16~p_min_d');

sum_gd_4_pd = fitlm(full_reg_data, 'sum_gd_4~p_min_d');
sum_gd_8_pd = fitlm(full_reg_data, 'sum_gd_8~p_min_d');
sum_gd_12_pd = fitlm(full_reg_data, 'sum_gd_12~p_min_d');
sum_gd_16_pd = fitlm(full_reg_data, 'sum_gd_16~p_min_d');

sum_rm_4_pd = fitlm(full_reg_data, 'sum_rm_4~p_min_d');
sum_rm_8_pd = fitlm(full_reg_data, 'sum_rm_8~p_min_d');
sum_rm_12_pd = fitlm(full_reg_data, 'sum_rm_12~p_min_d');
sum_rm_16_pd = fitlm(full_reg_data, 'sum_rm_16~p_min_d');

sum_ge_4_pe = fitlm(full_reg_data, 'sum_ge_4~p_min_e');
sum_ge_8_pe = fitlm(full_reg_data, 'sum_ge_8~p_min_e');
sum_ge_12_pe = fitlm(full_reg_data, 'sum_ge_12~p_min_e');
sum_ge_16_pe = fitlm(full_reg_data, 'sum_ge_16~p_min_e');

sum_gd_4_pe = fitlm(full_reg_data, 'sum_gd_4~p_min_e');
sum_gd_8_pe = fitlm(full_reg_data, 'sum_gd_8~p_min_e');
sum_gd_12_pe = fitlm(full_reg_data, 'sum_gd_12~p_min_e');
sum_gd_16_pe = fitlm(full_reg_data, 'sum_gd_16~p_min_e');

sum_rm_4_pe = fitlm(full_reg_data, 'sum_rm_4~p_min_e');
sum_rm_8_pe = fitlm(full_reg_data, 'sum_rm_8~p_min_e');
sum_rm_12_pe = fitlm(full_reg_data, 'sum_rm_12~p_min_e');
sum_rm_16_pe = fitlm(full_reg_data, 'sum_rm_16~p_min_e');

% table 6

table_6_data = cell(11,12);
table_6_data([1:5,7:11],1) = {'Panel A: Price-dividend ratio', 4, 8, 12, 16, ...
    'Panel B: Price-earnings ratio', 4, 8, 12, 16};

table_6_data(2:5,2:4) = {...
   sum_ge_4_pd.Coefficients.Estimate(2), sum_ge_4_pd.Coefficients.tStat(2),sum_ge_4_pd.Rsquared.Adjusted;...
   sum_ge_8_pd.Coefficients.Estimate(2), sum_ge_8_pd.Coefficients.tStat(2),sum_ge_8_pd.Rsquared.Adjusted;...
   sum_ge_12_pd.Coefficients.Estimate(2), sum_ge_12_pd.Coefficients.tStat(2),sum_ge_12_pd.Rsquared.Adjusted;...
   sum_ge_16_pd.Coefficients.Estimate(2), sum_ge_16_pd.Coefficients.tStat(2),sum_ge_16_pd.Rsquared.Adjusted};

table_6_data(2:5,6:8) = {...
   sum_gd_4_pd.Coefficients.Estimate(2), sum_gd_4_pd.Coefficients.tStat(2),sum_gd_4_pd.Rsquared.Adjusted;...
   sum_gd_8_pd.Coefficients.Estimate(2), sum_gd_8_pd.Coefficients.tStat(2),sum_gd_8_pd.Rsquared.Adjusted;...
   sum_gd_12_pd.Coefficients.Estimate(2), sum_gd_12_pd.Coefficients.tStat(2),sum_gd_12_pd.Rsquared.Adjusted;...
   sum_gd_16_pd.Coefficients.Estimate(2), sum_gd_16_pd.Coefficients.tStat(2),sum_gd_16_pd.Rsquared.Adjusted};

table_6_data(2:5,10:12) = {...
   sum_rm_4_pd.Coefficients.Estimate(2), sum_rm_4_pd.Coefficients.tStat(2),sum_rm_4_pd.Rsquared.Adjusted;...
   sum_rm_8_pd.Coefficients.Estimate(2), sum_rm_8_pd.Coefficients.tStat(2),sum_rm_8_pd.Rsquared.Adjusted;...
   sum_rm_12_pd.Coefficients.Estimate(2), sum_rm_12_pd.Coefficients.tStat(2),sum_rm_12_pd.Rsquared.Adjusted;...
   sum_rm_16_pd.Coefficients.Estimate(2), sum_rm_16_pd.Coefficients.tStat(2),sum_rm_16_pd.Rsquared.Adjusted};

table_6_data(8:11,2:4) = {...
   sum_ge_4_pe.Coefficients.Estimate(2), sum_ge_4_pe.Coefficients.tStat(2),sum_ge_4_pe.Rsquared.Adjusted;...
   sum_ge_8_pe.Coefficients.Estimate(2), sum_ge_8_pe.Coefficients.tStat(2),sum_ge_8_pe.Rsquared.Adjusted;...
   sum_ge_12_pe.Coefficients.Estimate(2), sum_ge_12_pe.Coefficients.tStat(2),sum_ge_12_pe.Rsquared.Adjusted;...
   sum_ge_16_pe.Coefficients.Estimate(2), sum_ge_16_pe.Coefficients.tStat(2),sum_ge_16_pe.Rsquared.Adjusted};

table_6_data(8:11,6:8) = {...
   sum_gd_4_pe.Coefficients.Estimate(2), sum_gd_4_pe.Coefficients.tStat(2),sum_gd_4_pe.Rsquared.Adjusted;...
   sum_gd_8_pe.Coefficients.Estimate(2), sum_gd_8_pe.Coefficients.tStat(2),sum_gd_8_pe.Rsquared.Adjusted;...
   sum_gd_12_pe.Coefficients.Estimate(2), sum_gd_12_pe.Coefficients.tStat(2),sum_gd_12_pe.Rsquared.Adjusted;...
   sum_gd_16_pe.Coefficients.Estimate(2), sum_gd_16_pe.Coefficients.tStat(2),sum_gd_16_pe.Rsquared.Adjusted};

table_6_data(8:11,10:12) = {...
   sum_rm_4_pe.Coefficients.Estimate(2), sum_rm_4_pe.Coefficients.tStat(2),sum_rm_4_pe.Rsquared.Adjusted;...
   sum_rm_8_pe.Coefficients.Estimate(2), sum_rm_8_pe.Coefficients.tStat(2),sum_rm_8_pe.Rsquared.Adjusted;...
   sum_rm_12_pe.Coefficients.Estimate(2), sum_rm_12_pe.Coefficients.tStat(2),sum_rm_12_pe.Rsquared.Adjusted;...
   sum_rm_16_pe.Coefficients.Estimate(2), sum_rm_16_pe.Coefficients.tStat(2),sum_rm_16_pe.Rsquared.Adjusted};


clf

f6 = figure('Name','Price-earnings ratios and economic uncertainty: USA','NumberTitle','off');


f6.Position = [560,528,840,270];

table_6 = uitable(f6,'Data',table_6_data,'Position',[20 30 805 235]);
table_6.Position = [20 30 805 235];

table_6.ColumnWidth = {140,65,65,65,20,65,65,65,20,65,65,65};
table_6.ColumnName = {'J', 'beta_J', 't-stat', 'R^2', [], 'beta_J', 't-stat', 'R^2', [],'beta_J', 't-stat', 'R^2'};


