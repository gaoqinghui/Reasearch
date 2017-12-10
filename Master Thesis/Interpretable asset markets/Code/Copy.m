% Copy
% working directory
cd('J:\WISE\Ren yu\Interpretable asset markets\Copy')

%% Loading data
load('data.mat')


%% Table 1
f1 = figure('Name','Summary statistics','NumberTitle','off');

t = uitable(f1,'Data',table_data,'Position',[40 220 450 140]);
t.RowName = RowName;
t.ColumnName = ColumnName;


sub_t = uitable(f1,'Data',sub_table_data,'Position',[40 80 450 140]);
sub_t.RowName =  RowName;
sub_t.ColumnName = ColumnName;

%% Table 2


