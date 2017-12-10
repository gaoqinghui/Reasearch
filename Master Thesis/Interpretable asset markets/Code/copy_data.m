%% Interpretable asset markets
% Gao Qinghui
% 
% Data Input
% CRSP
clear all
cd('J:\WISE\Ren yu\Interpretable asset markets\Data\CRSP')

% Monthly data
% 1948.1-1999.12
US_mdata = xlsread('CRSP.xls');
US_mdatevec = num2str([fix(US_mdata(:,1)/10000),fix(mod(US_mdata(:,1)/100,100)),fix(mod(US_mdata(:,1),100))]);
US_mdatenum = datenum(US_mdatevec);
US_mdatestr = datestr(US_mdatenum);

% Quarterly data
% 1948q1 -1999q4
US_qdata = xlsread('CRSP_1.xls');
US_qdatevec = num2str([fix(US_qdata(:,1)/10000),fix(mod(US_qdata(:,1)/100,100)),fix(mod(US_qdata(:,1),100))]);
US_qdatenum = datenum(US_qdatevec);
US_qdatestr = datestr(US_qdatenum);



% NIPA
cd('J:\WISE\Ren yu\Interpretable asset markets\Data\NIPA')

% 1948q1 - 1969q4
US_NIPA_E_1 = xlsread('Section1All_Hist.xls','11400 Qtr','H22:CQ22');
% 1970q1 - 1999q4
US_NIPA_E_2 = xlsread('Section1all_xls.xls','11400 Qtr','H22:DW22');
US_NIPA_E = [US_NIPA_E_1, US_NIPA_E_2]; 

% 1948q1 - 1999q4
US_NIPA_NonDurable_1 = xlsread('Section1All_Hist.xls','10105 Qtr','H14:CQ14');
US_NIPA_Service_1 = xlsread('Section1All_Hist.xls','10105 Qtr','H15:CQ15');
US_NIPA_NonDurable_2 = xlsread('Section1all_xls.xls','10105 Qtr','H14:DW14');
US_NIPA_Service_2 = xlsread('Section1all_xls.xls','10105 Qtr','H15:DW15');

US_NIPA_C = [US_NIPA_Service_1 + US_NIPA_NonDurable_1, US_NIPA_Service_2 + US_NIPA_NonDurable_2];


US_NIPA_percapita_Nondurable_current_1 = xlsread('Section7All_Hist.xls','70100 Qtr','H18:CQ18');
US_NIPA_percapita_Service_current_1 = xlsread('Section7All_Hist.xls','70100 Qtr','H19:CQ19');
US_NIPA_percapita_Nondurable_current_2 = xlsread('Section7all_xls.xls','70100 Qtr','H18:DW18');
US_NIPA_percapita_Service_current_2 = xlsread('Section7all_xls.xls','70100 Qtr','H19:DW19');

US_NIPA_percapita_Nondurable_2009_1 = xlsread('Section7All_Hist.xls','70100 Qtr','H27:CQ27');
US_NIPA_percapita_Service_2009_1 = xlsread('Section7All_Hist.xls','70100 Qtr','H28:CQ28');
US_NIPA_percapita_Nondurable_2009_2 = xlsread('Section7all_xls.xls','70100 Qtr','H27:DW27');
US_NIPA_percapita_Service_2009_2 = xlsread('Section7all_xls.xls','70100 Qtr','H28:DW28');

US_P_c = [(US_NIPA_percapita_Nondurable_current_1 + US_NIPA_percapita_Service_current_1)./(US_NIPA_percapita_Nondurable_2009_1 + US_NIPA_percapita_Service_2009_1),...
    (US_NIPA_percapita_Nondurable_current_2 + US_NIPA_percapita_Service_current_2)./(US_NIPA_percapita_Nondurable_2009_2 + US_NIPA_percapita_Service_2009_2)];


%
% US_mdata(:,1) is DATE(Month) from 1949.1 to 1999.12
%
% US_mdata(:,2) is vwretd(Value-weighted Return Excluding dividends)
%
% US_mdata(:,3) is vwretx(Value-weighted Return Includes distribution)
%
% US_mdata(:,4) is totval(Total market value)

%
% US_qdata(:,1) is DATE(Quarterly) from 1948q1 to 1999q4
%
% US_qdata(:,2) is vwretd(Value-weighted Return Excluding dividends)
%
% US_qdata(:,3) is vwretx(Value-weighted Return Includes distribution)
%
% US_qdata(:,4) is totval(Total market value)

% P : Total market value
%
% P_index(t) = (vwretx(t)+1)*P_index(t-1) : stock price index
%
% DY(t) = (1+vwretd(t))/(1+vwretx(t))-1 : divident yield for each month
%
% D_index(t) = DY(t)*P_index(t) : Divided index
%
% E: Corporate profits(earnings) after tax = dividends in the corporate
% sector + undistributed profits in the coporate sector
%
% E_index(t) = P_index(t-1)*E(t)/P(t-1): Corporate after-tax earnings index

%% Construct data
%
% construct month data (1948.1-1999.12)



% mP: Total market value(P)
mP = US_mdata(:,4).';

% mP_index: Stock price index on NYSE/AMES
mP_index = 1; % Set price_index of 1948.1 as 1
for i = 2:size(US_mdata,1)
    mP_index(i) = (US_mdata(i,3)+1)*mP_index(i-1);
end

% mD_index: Dividend index on NYSE/AMEX
mD_index = ((1 + US_mdata(:,2))./(1 + US_mdata(:,3))-1).' .* mP_index;


% construct quarterly data (1948q1-1999q4)

% US_qdata = US_qdata(4:end,:); % (1948q1-1999q4)

% qP: Total market value
qP = US_qdata(:,4).'; % (1948q1-1999q4)

% qP_index: Stock price index on NYSE/AMEX
qP_index = mP_index(3:3:end); % (1948q1-1999q4)

% qD_index: Dividend index on NYSE/AMEX
qD_index = mD_index(1:3:end) + mD_index(2:3:end) + mD_index(3:3:end); % (1948q1-1999q4)


% deseasonalized(1948q4-1999q4)

qD_index_deseasonalized = (qD_index(1:end-3) + qD_index(2:end-2)...
    + qD_index(3:end-1) + qD_index(4:end))./4;

qD_index = qD_index_deseasonalized;
% Now qD_index is from 1948q4-1999q4

qE = US_NIPA_E; % (1948q1-1999q4)

qE_index = qP_index(1:end-1).*qE(2:end)./qP(1:end-1); % (1948q2-1999q4)




qC = US_NIPA_C; % (1948q1-1999q4)

qR_m = (qD_index + qP_index(4:end))./qP_index(3:end-1) - 1; % (1948q4-1999q4)

qP_c = US_P_c; % (1948q1-1999q4)

%% Covert all data from 1948q4-1999q4

% before: qD_index(1948q4-1999q4)

% before: qP_c(1948q1-1999q4)
qP_c = qP_c(4:end);

% before: q_C(1948q1-1999q4)
qC = qC(4:end);

% before: qE_index(1948q2-1999q4)
qE_index = qE_index(3:end);

% before: qR_m(1948q4-1999q4)

% before: qP_index(1948q1-1999q4)
qP_index = qP_index(4:end);




% save data;




%% growth_rate

g_c = price2ret(qC./qP_c,[], 'Continuous');% 'Continuous', 'Periodic'
g_c = g_c(1:end-3)';
g_d = price2ret(qD_index./qP_c,[], 'Continuous');
g_d = g_d(1:end-3)';
g_e = price2ret(qE_index./qP_c,[], 'Continuous');
g_e = g_e(1:end-3)';
r_m = log((1+qR_m(2:end))./(qP_c(2:end)./qP_c(1:end-1)));
r_m = r_m(1:end-3)';
p_min_d = log(qP_index(2:end)./qD_index(2:end));
p_min_d = p_min_d(1:end-3)';
p_min_e = log(qP_index(2:end)./qE_index(2:end));
p_min_e = p_min_e(1:end-3)';

full_data = [US_qdatenum(5:end-3,1),g_c,g_d,g_e,r_m,p_min_d,p_min_e];

sub_data = full_data(92:196,:);

full_reg_data = table(full_data(:,1),full_data(:,2),full_data(:,3),full_data(:,4),full_data(:,5),full_data(:,6),full_data(:,7)...
    ,'VariableNames', {'t','g_c','g_d','g_e','r_m','p_min_d','p_min_e'});

full_reg_data.g_c_lag1 = [nan;full_reg_data.g_c(1:end-1)];
full_reg_data.r_m_lag1 = [nan;full_reg_data.r_m(1:end-1)];
full_reg_data.const = ones(size(full_reg_data,1),1);



cd('J:\WISE\Ren yu\Interpretable asset markets\Copy')
 save data






%% Table 1





var_names = char('g_c','g_d','g_e','r_m','p-d','p-e');
var_mean = mean(full_data(:,2:end),1)';
var_std = std(full_data(:,2:end),1)';
corr_g = [nan,corr(full_data(:,2),full_data(:,3)),corr(full_data(:,2),full_data(:,4)),nan,nan,nan]';

ACF(1,:) = autocorr(full_data(:,2), 8);
ACF(2,:) = autocorr(full_data(:,3), 8);
ACF(3,:) = autocorr(full_data(:,4), 8);
ACF(4,:) = autocorr(full_data(:,5), 8);
ACF(5,:) = autocorr(full_data(:,6), 8);
ACF(6,:) = autocorr(full_data(:,7), 8);

AC_4 = ACF(:,5);
AC_8 = ACF(:,9);

T = table(var_names,var_mean,var_std,corr_g,AC_4,AC_8);

T.Properties.VariableNames = {'VarNames','Mean','Std','corr_with_g_c','AC_4','AC_8'}  % , 'AC(4)', 'AC(8)

clf
f = figure;
table_data = table2cell(T);
table_data = table_data(:,2:end);
table_data(:,3) = {[],table_data{[2,3],3},[],[],[]};
t = uitable(f,'Data',table_data,'Position',[40 220 450 140],'RowName',{'g_c','g_d','g_e','r_m','(p-d)','(p-e)'},'ColumnName',{'Mean','Std','corr(g_c,g.)','AC(4)','AC(8)'});
t.RowName = {'g_c','g_d','g_e','r_m','(p-d)','(p-e)'};
t.ColumnName = {'Mean','Std','corr(g_c,g.)','AC(4)','AC(8)'};

var_names = char('g_c','g_d','g_e','r_m','p-d','p-e');
sub_var_mean = mean(sub_data(:,2:end),1)';
sub_var_std = std(sub_data(:,2:end),1)';
sub_corr_g = {[],corr(sub_data(:,2),sub_data(:,3)),corr(sub_data(:,2),sub_data(:,4)),[],[],[]}'

sub_ACF(1,:) = autocorr(sub_data(:,2), 8);
sub_ACF(2,:) = autocorr(sub_data(:,3), 8);
sub_ACF(3,:) = autocorr(sub_data(:,4), 8);
sub_ACF(4,:) = autocorr(sub_data(:,5), 8);
sub_ACF(5,:) = autocorr(sub_data(:,6), 8);
sub_ACF(6,:) = autocorr(sub_data(:,7), 8);

sub_AC_4 = sub_ACF(:,5);
sub_AC_8 = sub_ACF(:,9);

sub_T = table(var_names,sub_var_mean,sub_var_std,sub_corr_g,sub_AC_4,sub_AC_8);

sub_T.Properties.VariableNames = {'VarNames','Mean','Std','corr_with_g_c','AC_4','AC_8'}  % , 'AC(4)', 'AC(8)



sub_table_data = table2cell(sub_T);
sub_table_data = sub_table_data(:,2:end);
sub_table_data(:,3) = {[],sub_table_data{[2,3],3},[],[],[]};
sub_t = uitable(f,'Data',sub_table_data,'Position',[40 80 450 140],'RowName',{'g_c','g_d','g_e','r_m','(p-d)','(p-e)'},'ColumnName',{'Mean','Std','corr(g_c,g.)','AC(4)','AC(8)'});
sub_t.RowName = {'g_c','g_d','g_e','r_m','(p-d)','(p-e)'};
sub_t.ColumnName = {'Mean','Std','corr(g_c,g.)','AC(4)','AC(8)'};


%%


RowName = {'g_c','g_d','g_e','r_m','(p-d)','(p-e)'};
ColumnName = {'Mean','Std','corr(g_c,g.)','AC(4)','AC(8)'};

clf

f = figure('Name','Summary statistics','NumberTitle','off');

t = uitable(f,'Data',table_data,'Position',[40 220 450 140]);
t.RowName = RowName;
t.ColumnName = ColumnName;

sub_t = uitable(f,'Data',sub_table_data,'Position',[40 80 450 140]);
sub_t.RowName =  RowName;
sub_t.ColumnName = ColumnName;


cd('J:\WISE\Ren yu\Interpretable asset markets\Copy')
save data




