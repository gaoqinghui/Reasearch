%% Table 6

J = [4,8,12,16];
mc_time = 100;
[sum_epd] = regress_vr_gr(full_reg_data.p_min_d, full_reg_data.g_e, J);
[sum_epe] = regress_vr_gr(full_reg_data.p_min_e, full_reg_data.g_e, J, mc_time);
[sum_dpd] = regress_vr_gr(full_reg_data.p_min_d, full_reg_data.g_d, J);
[sum_dpe] = regress_vr_gr(full_reg_data.p_min_e, full_reg_data.g_d, J);
[sum_rpd] = regress_vr_gr(full_reg_data.p_min_d, full_reg_data.r_m, J);
[sum_rpe] = regress_vr_gr(full_reg_data.p_min_e, full_reg_data.r_m, J);


% Table 6

table_6_data = cell(11,12);
table_6_data([1:5,7:11],1) = {'Panel A: Price-dividend ratio', 4, 8, 12, 16, ...
    'Panel B: Price-earnings ratio', 4, 8, 12, 16};

table_6_data(2:5,2:4) = num2cell([sum_epd.b,sum_epd.t,sum_epd.R2adj]);
table_6_data(8:11,2:4) = num2cell([sum_epe.b,sum_epe.t,sum_epe.R2adj]);
table_6_data(2:5,6:8) = num2cell([sum_dpd.b,sum_dpd.t,sum_dpd.R2adj]);
table_6_data(8:11,6:8) = num2cell([sum_dpe.b,sum_dpe.t,sum_dpe.R2adj]);
table_6_data(2:5,10:12) = num2cell([sum_rpd.b,sum_rpd.t,sum_rpd.R2adj]);
table_6_data(8:11,10:12) = num2cell([sum_rpe.b,sum_rpe.t,sum_rpe.R2adj]);


clf

f6 = figure('Name','Price-earnings ratios and economic uncertainty: USA','NumberTitle','off');


f6.Position = [560,528,840,270];

table_6 = uitable(f6,'Data',table_6_data,'Position',[20 30 805 235]);
table_6.Position = [20 30 805 235];

table_6.ColumnWidth = {140,65,65,65,20,65,65,65,20,65,65,65};
table_6.ColumnName = {'J', 'beta_J', 't-stat', 'R^2', [], 'beta_J', 't-stat', 'R^2', [],'beta_J', 't-stat', 'R^2'};