%% Table 3

% set up random seed and MC_times
rnd_seed = 20170906;
rng(rnd_seed);
mc_time = 300;

% generate sigma(gen_sigma_J is a function written by me)
full_reg_data.sigma_c_1 =  gen_sigma_J(AR_gc_abs_res, 1);
full_reg_data.sigma_c_4 =  gen_sigma_J(AR_gc_abs_res, 4);
full_reg_data.sigma_c_8  =  gen_sigma_J(AR_gc_abs_res, 8);

full_reg_data.sigma_r_1 =  gen_sigma_J(AR_rm_abs_res, 1);
full_reg_data.sigma_r_4 =  gen_sigma_J(AR_rm_abs_res, 4);
full_reg_data.sigma_r_8  =  gen_sigma_J(AR_rm_abs_res, 8);

%% Estimate

% OLS
% pd_vc_1 = fitlm(full_reg_data,'p_min_d~sigma_c_1');
% pd_vc_4 = fitlm(full_reg_data,'p_min_d~sigma_c_4');
% pd_vc_8 = fitlm(full_reg_data,'p_min_d~sigma_c_8');
% 
% pd_vr_1 = fitlm(full_reg_data,'p_min_d~sigma_r_1');
% pd_vr_4 = fitlm(full_reg_data,'p_min_d~sigma_r_4');
% pd_vr_8 = fitlm(full_reg_data,'p_min_d~sigma_r_8');
% 
% pe_vc_1 = fitlm(full_reg_data,'p_min_e~sigma_c_1');
% pe_vc_4 = fitlm(full_reg_data,'p_min_e~sigma_c_4');
% pe_vc_8 = fitlm(full_reg_data,'p_min_e~sigma_c_8');
% 
% pe_vr_1 = fitlm(full_reg_data,'p_min_e~sigma_r_1');
% pe_vr_4 = fitlm(full_reg_data,'p_min_e~sigma_r_4');
% pe_vr_8 = fitlm(full_reg_data,'p_min_e~sigma_r_8');

%% HAC(Newey-West with lag length J)
[pd_vc_1.beta ,~,pd_vc_1.R2adj,~,~,~,~,~,~,~,pd_vc_1.t_NW,pd_vc_1.t_HH] = olshac(full_reg_data.p_min_d(3:end), [full_reg_data.const(3:end), full_reg_data.sigma_c_1(3:end)],1,1);

pd_vc_1.beta(2)
pd_vc_1.t_NW(2)
pd_vc_1.R2adj


%% Monte-Carlo
mc_time = 100;
[pdc, cpd] = MC_regress2( full_reg_data.p_min_d, full_reg_data.g_c, [1,4,8], mc_time);
[pdr, rpd] = MC_regress2( full_reg_data.p_min_d, full_reg_data.r_m, [1,4,8], mc_time);
[pec, cpe] = MC_regress2( full_reg_data.p_min_e, full_reg_data.g_c, [1,4,8], mc_time);
[per, rpe] = MC_regress2( full_reg_data.p_min_e, full_reg_data.r_m, [1,4,8], mc_time);




%% Table 3
table_3_data = cell(9,14);
table_3_data([2:4,7:9],1) = num2cell([1,4,8,1,4,8]);
table_3_data([1,6],1) = {'Panel A: price-dividend ratio','Panel B: price-earnings ratio'};

table_3_data([2,3,4],[2,3,4,5,6,7]) = ...
    num2cell([pdc.b,pdc.t,pdc.R2adj,pdc.t2_5,pdc.t5,pdc.R2_95]);

table_3_data([2,3,4],[9,10,11,12,13,14]) = ...
    num2cell([pdr.b,pdr.t,pdr.R2adj,pdr.t2_5,pdc.t5,pdr.R2_95]);

table_3_data([7,8,9],[2,3,4,5,6,7]) = ...
    num2cell([pec.b,pec.t,pec.R2adj,pec.t2_5,pec.t5,pec.R2_95]);

table_3_data([7,8,9],[9,10,11,12,13,14]) = ...
    num2cell([per.b,per.t,per.R2adj,per.t2_5,per.t5,per.R2_95]);


clf

f3 = figure('Name','Economic uncertainty predicting future valuation ratios: USA','NumberTitle','off');


f3.Position = [560,528,1070,250];

table_3 = uitable(f3,'Data',table_3_data,'Position',[20 30 1030 200]);
table_3.Position = [20 30 1030 200];

table_3.ColumnWidth = {150,65,65,65,65,65,65,65,65,65,65,65,65,65};
table_3.ColumnName = {'J', 'b', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)',[], 'b', 't-stat', 'R^2', 't(2.5%)','t(5%)','R^2(95%)'};

