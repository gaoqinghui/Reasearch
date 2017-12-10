%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reading Data

cd('J:\WISE\Ren yu\Inflation\Data') % Path of Data

% TIPS: from 2003/1/1 to 2009/2/1
TIPS = csvread('FRB_H15.csv',6,1); % It seems there is a problem in time index

% Treasury: from 2000/1/1 to 2008/12/1
Treasury_60 = csvread('GS5.csv',1,1);
Treasury_84 = csvread('GS7.csv',1,1);
Treasury_120 = csvread('GS10.csv',1,1);

Treasury = [Treasury_60, Treasury_84, Treasury_120];
Treasury = Treasury(1:(end-3),:);

% CPI (CPI-U): from 1999/1/1 to 2008/12/1
CPI = csvread('CPI.csv',1,1);
length(CPI)

% Core_CPI: from 1999/1/1 to 2008/12/1
Core_CPI = csvread('Core CPI.csv', 1, 1);


% PPI: from 1999/1/1 to 2008/12/1 
PPI = csvread('PPI.csv', 1, 1);
length(PPI)

PRICE = [CPI, Core_CPI, PPI];
PRICE = PRICE(1:(end-3),:);

ret_PRICE = log(PRICE(13:end,:)./PRICE(1:(end-12),:))*100;

% real_activity: from 1999/1/1 to 2008/12/1
EMPLOY_Adjusted = csvread('EMPLOY-Seasonally Adjusted.csv', 1, 1);
EMPLOY_Unadjusted = csvread('EMPLOY-Seasonally Unadjusted.csv', 1, 1);
IP = csvread('IP.csv', 1, 1);
UE = csvread('UE.csv', 1, 1);

real_act = [EMPLOY_Adjusted, EMPLOY_Unadjusted, IP];
real_act = real_act(1:(end-3),:);




ret_real_act = log(real_act(13:end,:)./real_act(1:(end-12),:))*100;

UE = UE(13:(end-3));
ret_real_act = [ret_real_act UE];

stat_CPI = csvread('stat_CPI.csv',1,1);
stat_Core_CPI = csvread('stat_Core_CPI.csv',1,1);

stat_CPI = stat_CPI(1:(end-3),:);
stat_Core_CPI = stat_Core_CPI(1:(end-3),:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Table 1

% auto_xxx is the autocorrelation of xxxx

auto_TIPS = nan(size(TIPS,2),3);
for i = 1:size(TIPS,2)
    temp = autocorr(TIPS(:,i),3);
    auto_TIPS(i,:) = temp(2:end);
end

stat_TIPS = [mean(TIPS)', std(TIPS)', skewness(TIPS)', kurtosis(TIPS)', auto_TIPS]

auto_Treasury = nan(size(Treasury,2),3);
for i = 1:size(Treasury,2)
    temp = autocorr(Treasury(:,i),3);
    auto_Treasury(i,:) = temp(2:end);
end

stat_treasury = [mean(Treasury)', std(Treasury)', skewness(Treasury)', kurtosis(Treasury)', auto_Treasury]

auto_PRICE = nan(size(PRICE,2),3);
for i = 1:size(PRICE,2)
    temp = autocorr(PRICE(:,i),3);
    auto_PRICE(i,:) = temp(2:end);
end

stat_PRICE = [mean(ret_PRICE)', std(ret_PRICE)', skewness(ret_PRICE)', kurtosis(ret_PRICE)', auto_PRICE]

auto_ret_real_act = nan(size(ret_real_act,2),3);
for i = 1:size(ret_real_act,2)
    temp = autocorr(ret_real_act(:,i),3);
    auto_ret_real_act(i,:) = temp(2:end);
end

stat_real_act = [mean(ret_real_act)', std(ret_real_act)', skewness(ret_real_act)', kurtosis(ret_real_act)', auto_ret_real_act]

sum_stat = [stat_TIPS; stat_treasury; stat_PRICE; stat_real_act]

xlswrite('sum_stat.xlsx', sum_stat);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Table 2

Y = csvread('3-Month Treasury Bill-Secondary Market Rate.csv',13,1);
Y = Y(1:(end-3));
Q = -3/4*Y; % three month yields

P = price2ret(PRICE(12:end,1));
R = price2ret(real_act(12:end,[1,3]));
R = [R UE];

X = ones(size(P));


tau_list = [12 24 36 57 60 81 84 117 120];



% gamma_tau_1 = cal_gamma(tau_list, P, Q, R);
% gamma_tau_1.value

cd('J:\WISE\Ren yu\Inflation\Code');

% cal_gamma_tau is a function to calculate gamma via VAR

gamma_tau = nan(1,9);
for i = 1:length(gamma_tau)
    gamma_tau(i) = cal_gamma_tau(tau_list(i), P, Q, X);
end

gamma_tau_annual = gamma_tau;
gamma_tau_annual = -1200*gamma_tau_annual./tau_list;

gamma_tau
gamma_tau_annual


gamma_list = [gamma_tau', gamma_tau_annual']

xlswrite('gamma_list.xlsx', gamma_list);

%% Table 3

% tau
tau_list = [57, 81, 117];

% f_tau_l: forward rate
f_tau_l = nan(size(Y,1), length(tau_list));
for i = 1:length(tau_list)
    temp_tau = tau_list(i);
    for j = 1:size(Y,1)
        f_tau_l(j,i) = log(exp(-1/36*(temp_tau^2-(temp_tau+3)^2)*Y(j))-1);
    end
end


f_tau_l = f_tau_l(37:end,:);
TIPS = TIPS(1:(end-5),:);
gamma_tau = gamma_tau([4, 6, 8]);
y_r = 12*TIPS*diag(1./tau_list) - 3*f_tau_l*diag(1./tau_list) + ones(size(f_tau_l,1), length(tau_list))*diag(gamma_tau./tau_list);

% y_r: real yields
y_r

stat_y_r = [mean(y_r)', std(y_r)', skewness(y_r)', kurtosis(y_r)']

xlswrite('stat_y_r.xlsx', stat_y_r);

y_r_before = y_r(1:17,:);
y_r_after = y_r(18:end,:);



stat_y_r_before = [mean(y_r_before)', std(y_r_before)', skewness(y_r_before)', kurtosis(y_r_before)']
stat_y_r_after = [mean(y_r_after)', std(y_r_after)', skewness(y_r_after)', kurtosis(y_r_after)']

xlswrite('stat_y_r_before.xlsx', stat_y_r_before);
xlswrite('stat_y_r_after.xlsx', stat_y_r_after);


%% Table 4



mean_expected_CPI = nan(3,5);
std_expected_CPI = nan(3,5); 
mean_expected_Core_CPI = nan(3,5); 
std_expected_Core_CPI = nan(3,5); 

tau_list = [57, 81, 117];
T_list = [1,3,5,7,10];

for i = 1:length(tau_list)
    for j = 1:length(T_list)
        mean_expected_CPI(i,j) = mean(expected_inflation(stat_CPI, tau_list(i), T_list(j)).*100);
       	std_expected_CPI(i,j) = std(expected_inflation(stat_CPI, tau_list(i), T_list(j)).*100);
        mean_expected_Core_CPI(i,j) = mean(expected_inflation(stat_Core_CPI, tau_list(i), T_list(j)).*100);
       	std_expected_Core_CPI(i,j) = std(expected_inflation(stat_Core_CPI, tau_list(i), T_list(j)).*100);
    end
end


xlswrite('mean_expected_CPI.csv', mean_expected_CPI)
xlswrite('std_expected_CPI.csv', std_expected_CPI)
xlswrite('mean_expected_Core_CPI.csv', mean_expected_Core_CPI)
xlswrite('std_expected_Core_CPI.csv', std_expected_Core_CPI)

%% Table 5

RMSE_CPI = nan(3,1);
RMSE_Core_CPI = nan(3,1);

ret_PRICE = log(PRICE(13:end)./PRICE(1:(end-12),:);

for i = 1:length(tau_list)
        RMSE_CPI(i,j) = sqrt(mean(expected_inflation(stat_CPI, tau_list(i), 1)- ret_PRICE).^2);
       	RMSE_Core_CPI(i,j) = sqrt(mean(expected_inflation(stat_Core_CPI, tau_list(i), 1)-ret_PRICE).^2);
end

xlswrite('RMSE_CPI.xlsx',RMSE_CPI)
xlswrite('RMSE_Core_CPI.xlsx',RMSE_Core_CPI)

%% Table 6

y_r

size(y_r)

y_tau = nan(69,3)

for i = 1:3
    y_tau(:,i) = tau_list(i)/12*Y(37:end);
end

% Define IRP
IRP_CPI = nan(69,3);
IRP_Core_CPI = nan(69,3);

for i = 1:3
    temp_inflation_CPI = expected_inflation(stat_CPI, tau_list(i),1);
    temp_inflation_Core_CPI = expected_inflation(stat_Core_CPI, tau_list(i),1);
    IRP_CPI(:,i) = y_tau(:,i) - y_r(:,i) - temp_inflation_CPI(37:end);
    IRP_Core_CPI(:,i) = y_tau(:,i) - y_r(:,i) - temp_inflation_Core_CPI(37:end);
end


mean_IRP_CPI = mean(IRP_CPI);
mean_IRP_Core_CPI = mean(IRP_Core_CPI);

xlswrite('mean_IRP_CPI.xlsx', mean_IRP_CPI);
xlswrite('mean_IRP_Core_CPI.xlsx', mean_IRP_Core_CPI);


