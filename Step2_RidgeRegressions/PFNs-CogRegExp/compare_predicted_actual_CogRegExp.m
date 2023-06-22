
% NOTE: this script is meant to be run with the matlab GUI to make figures

clear all

% Add package to read NPY files into matlab
addpath('/Users/askeller/Documents/npy-matlab/')

% Load in prediction results
folder_name='/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/PFNvsExp_Cognition/CogRegExp/CogRegExp_results';
file_name_pred1_samp1='CogRegExp_prediction_testA.npy';
file_name_pred1_samp2='CogRegExp_prediction_testB.npy';

pred_ExpFactor_samp1 = readNPY([folder_name '/' file_name_pred1_samp1]);
pred_ExpFactor_samp2 = readNPY([folder_name '/' file_name_pred1_samp2]);

% put predictions on same scale as actual
pred_ExpFactor_samp1 = zscore(pred_ExpFactor_samp1);
pred_ExpFactor_samp2 = zscore(pred_ExpFactor_samp2);


% fourth column has the matched_group
data_for_ridge=xlsread('/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/PFNvsExp_Cognition/data_for_ridge_cogregexp.xls');

% Load in actual scores
actual_ExpFactor = data_for_ridge(:,1);

% split data out by matched group
actual_ExpFactor_samp1 = actual_ExpFactor(data_for_ridge(:,4)==1);
actual_ExpFactor_samp2 = actual_ExpFactor(data_for_ridge(:,4)==2);



%% Plotting

% load colors
color_fill = gray(10);
color_fill_1 = color_fill(1,:);
color_fill_2 = color_fill(7,:);

figure()
scatter(actual_ExpFactor_samp2,pred_ExpFactor_samp2,15,color_fill_2,'Marker','^','MarkerFaceColor',color_fill_2)
[r,p,ci,stats]=corrcoef(actual_ExpFactor_samp2,pred_ExpFactor_samp2)
hold on
scatter(actual_ExpFactor_samp1,pred_ExpFactor_samp1,75,color_fill_1,'Marker','.')
[r,p,ci,stats]=corrcoef(actual_ExpFactor_samp1,pred_ExpFactor_samp1)
hold on
linearFit = polyfit(actual_ExpFactor_samp1,pred_ExpFactor_samp1,1);
hline = refline(linearFit);
hline.Color=color_fill_1;
hline.LineWidth=2;
hold on
linearFit = polyfit(actual_ExpFactor_samp2,pred_ExpFactor_samp2,1);
hline = refline(linearFit);
hline.Color=color_fill_2;
hline.LineWidth=2;
xlabel("Actual Exp-Factor",'FontSize',16)
ylabel("Predicted Exp-Factor",'FontSize',16)
axis([-4 4 -4 4])


