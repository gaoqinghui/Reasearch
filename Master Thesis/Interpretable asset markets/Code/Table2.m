%% Table 2

load data

% Set up AR(1) and AR(1)-GARCH(1,1)
AR = arima('ARLags',1);
ARGARCH = arima('ARLags',1,'Variance',garch(1,1));

%% estimate
% MLE for AR(1)
%[AR_gc.mdl, AR_gc.vcov] = estimate(AR, full_reg_data.g_c,'display','off');
%[AR_rm.coef, AR_rm.vcov] = estimate(AR, full_reg_data.r_m,'display','off');
%AR_gc_abs_res = abs(infer(AR_gc.mdl, full_reg_data.g_c));

% OLS for AR(1)
clear AR_gc
AR_gc = fitlm(full_reg_data, 'g_c~g_c_lag1');
AR_gc_NWvcov = hac(AR_gc,'type','HAC','bandwidth',floor(4*(200/100)^(2/9))+1,'weights','BT','display','off');
% AR_gc_NWvcov = hac(AR_gc,'type','HAC','bandwidth','AR1OLS','weights','BT','display','off');

% Using olshac
%[AR_gc.beta ~,~,~,~,~,AR_gc.std_NW,AR_gc.std_HH] = olshac(full_reg_data.g_c(2:end), [full_reg_data.const(2:end), full_reg_data.g_c_lag1(2:end)],1,1);


AR_rm = fitlm(full_reg_data, 'r_m~r_m_lag1');
AR_rm_NWvcov = hac(AR_rm,'type','HAC','bandwidth',floor(4*(200/100)^(2/9))+1,'weights','BT','display','off');
% AR_rm_NWvcov = hac(AR_rm,'type','HAC','bandwidth','AR1OLS','weights','BT','display','off');

% Absolute residuals

AR_gc_abs_res = abs(AR_gc.Residuals.Raw(~isnan(AR_gc.Residuals.Raw)));
AR_rm_abs_res = abs(AR_rm.Residuals.Raw(~isnan(AR_rm.Residuals.Raw)));
[h_gc, pValue_gc, Qstat_gc] = lbqtest(AR_gc_abs_res,'lags',[1,4,8]);
[h_rm, pValue_rm, Qstat_rm] = lbqtest(AR_rm_abs_res,'lags',[1,4,8]);

AC_AR(:,1) = autocorr(AR_gc_abs_res);
AC_AR(:,2) = autocorr(AR_rm_abs_res);

% MLE for AR(1)-GARCH(1,1)
[ARGARCH_gc.mdl, ARGARCH_gc.vcov] = estimate(ARGARCH, full_reg_data.g_c,'display','off');
[ARGARCH_rm.mdl, ARGARCH_rm.vcov] = estimate(ARGARCH, full_reg_data.r_m,'display','off');


%

%% Table_2

f2 = figure('Name','Consumption growth and market return projection','NumberTitle','off');

table_2_data = cell(19,10);

table_2_data(1:19,1) = {'AR(1) estimates',[] ,'Panel A: Consumption growth','Estimate','S.E.'...
    ,[] ,'Panel B: Market return','Estimate','S.E.'...
    ,[] ,'AR(1)-GARCH(1,1) estimates',[] ,'Panel C: Consumption','Estimate','S.E.'...
    ,[] ,'Panel D: Market return','Estimate','S.E.'};

table_2_data([4,5,8,9],[2,3,8,9,10]) = num2cell([AR_gc.Coefficients.Estimate', AC_AR([2,5,8],1)';sqrt(diag(AR_gc_NWvcov))', Qstat_gc;...
    AR_rm.Coefficients.Estimate', AC_AR([2,5,8],2)';sqrt(diag(AR_rm_NWvcov))', Qstat_rm;]);

table_2_data([14,15],[2,3,4,6,5]) = num2cell([ ARGARCH_gc.mdl.Constant,ARGARCH_gc.mdl.AR{1},...
    ARGARCH_gc.mdl.Variance.Constant,ARGARCH_gc.mdl.Variance.GARCH{1},ARGARCH_gc.mdl.Variance.ARCH{1};...
     sqrt(diag(ARGARCH_gc.vcov))']);

table_2_data([17,18],[2,3,4,6,5]) = num2cell([ ARGARCH_rm.mdl.Constant,ARGARCH_rm.mdl.AR{1},...
    ARGARCH_rm.mdl.Variance.Constant,ARGARCH_rm.mdl.Variance.GARCH{1},ARGARCH_rm.mdl.Variance.ARCH{1};...
     sqrt(diag(ARGARCH_rm.vcov))']);

table_2_data([4,5,8,9],7) = {'Estimate','Q-stat','Estimate','Q-stat'};


f2.Position = [560,528,900,450];

table_2 = uitable(f2,'Data',table_2_data,'Position',[40 30 715 385]);

table_2.Position = [40 30 775 385];

table_2.ColumnWidth = {150,65,65,65,65,65,65,65,65,65};
table_2.ColumnName = {[],'const','A1','w0','w1','w2',[],'AC(1)','AC(4)','AC(8)'};