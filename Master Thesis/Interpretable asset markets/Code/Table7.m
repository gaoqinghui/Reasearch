%% Table 7

% table_7_data

table_7_data = cell(5,8);
table_7_data(1:5,1) = {'Earning growth rate : Price-earnings ratio', 4, 8, 12, 16};

table_7_data(2:5,2:4) = num2cell([sum_epe.b, sum_epe.t, sum_epe.R2adj]);
table_7_data(2:5,5:8) = num2cell([sum_epe.t90, sum_epe.t95, sum_epe.t97_5, sum_epe.R2_95]);


f7 = figure('Name','Price-earnings ratios and growth rates','NumberTitle','off');

f7.Position = [280,20,775,160];

table_7 = uitable(f7,'Data',table_7_data,'Position',[20 30 775 125]);
table_7.Position = [20 30 775 125];

table_7.ColumnWidth = {220,65,65,65};
table_7.ColumnName = {'J', 'beta_J', 't-stat', 'R^2', 't(90%)', 't(95%)', 't(97.5%)', 'R^2(95%)'};

