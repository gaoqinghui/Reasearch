%% Table 4

% table 4
table_4_data = cell(9,14);
table_4_data([2:4,7:9],1) = num2cell([1,4,8,1,4,8]);
table_4_data([1,6],1) = {'Panel A: price-dividend ratio','Panel B: price-earnings ratio'};

table_4_data(2:4,2:7) = num2cell([cpd.b,cpd.t,cpd.R2adj,cpd.t2_5,cpd.t5,cpd.R2_95]);

table_4_data(2:4,9:14) = num2cell([rpd.b,rpd.t,rpd.R2adj,rpd.t2_5,rpd.t5,rpd.R2_95]);
     
table_4_data(7:9,2:7) = num2cell([cpe.b,cpe.t,cpe.R2adj,cpe.t2_5,cpe.t5,cpe.R2_95]);

table_4_data(7:9,9:14) = num2cell([rpe.b,rpe.t,rpe.R2adj,rpe.t2_5,rpe.t5,rpe.R2_95]);

clf

f4 = figure('Name','Valuation ratios prediction future economic uncertainty: USA','NumberTitle','off');


f4.Position = [560,528,1070,250];

table_4 = uitable(f4,'Data',table_4_data,'Position',[20 30 1030 200]);
table_4.Position = [20 30 1030 200];

table_4.ColumnWidth = {150,65,65,65,65,65,65,65,65,65,65,65,65,65};
table_4.ColumnName = {'J', 'a', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)',[], 'a', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)'};

    