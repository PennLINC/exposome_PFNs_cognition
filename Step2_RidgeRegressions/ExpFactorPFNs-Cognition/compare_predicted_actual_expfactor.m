
% NOTE: this script is meant to be run with the matlab GUI to make figures

clear all

% Add package to read NPY files into matlab
addpath('/Users/askeller/Documents/npy-matlab/')

% Load in prediction results
folder_name='/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge';
file_name_pred1_samp1='ExpFactor_prediction_testA.npy';
file_name_pred1_samp2='ExpFactor_prediction_testB.npy';

pred_ExpFactor_samp1 = readNPY([folder_name '/' file_name_pred1_samp1]);
pred_ExpFactor_samp2 = readNPY([folder_name '/' file_name_pred1_samp2]);

% put predictions on same scale as actual
pred_ExpFactor_samp1 = zscore(pred_ExpFactor_samp1);
pred_ExpFactor_samp2 = zscore(pred_ExpFactor_samp2);


% fourth column has the matched_group
data_for_ridge=xlsread('/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/data_for_ridge_expfactor.xls');

% Load in actual scores
actual_ExpFactor = data_for_ridge(:,1);

% split data out by matched group
actual_ExpFactor_samp1 = actual_ExpFactor(data_for_ridge(:,2)==1);
actual_ExpFactor_samp2 = actual_ExpFactor(data_for_ridge(:,2)==2);




% ~~~~~ NULL ~~~~~~ %
folder_name='/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/null_results';
file_name_acc_ExpFactor_null_samp1='ExpFactor_acc_null_testA.npy';
file_name_acc_ExpFactor_null_samp2='ExpFactor_acc_null_testB.npy';
acc_ExpFactor_null_samp1 = readNPY([folder_name '/' file_name_acc_ExpFactor_null_samp1]);
acc_ExpFactor_null_samp2 = readNPY([folder_name '/' file_name_acc_ExpFactor_null_samp2]);


% ~~~~~ BOOTSTRAP ~~~~~~ %
folder_name='/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/boot_results';
file_name_acc_ExpFactor_boot='ExpFactor_acc_boot.npy';
acc_ExpFactor_boot = readNPY([folder_name '/' file_name_acc_ExpFactor_boot]);


% ~~~~~ BOOTSTRAP NULL ~~~~~~ %
folder_name='/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/boot_null_results';
file_name_acc_ExpFactor_boot_null='ExpFactor_acc_boot_null.npy';
acc_ExpFactor_boot_null = readNPY([folder_name '/' file_name_acc_ExpFactor_boot_null]);




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



figure()
subplot(2,1,1)
hist(acc_ExpFactor_null_samp1)
h=findobj(gca,'Type','patch')
h.FaceColor = color_fill_1;
h.EdgeColor = color_fill_1;
set(gca,'ytick',[])
hold on
axis([-0.1 0.1 0 30])
box off
subplot(2,1,2)
hist(acc_ExpFactor_null_samp2)
h=findobj(gca,'Type','patch')
h.FaceColor = color_fill_2;
h.EdgeColor = color_fill_2;
set(gca,'ytick',[])
axis([-0.1 0.1 0 30])
box off



%% Make histograms for the bootstrapped distributions:

figure()
hist(acc_ExpFactor_boot,6)
h=findobj(gca,'Type','patch')
h.FaceColor = color_fill_1;
h.EdgeColor = color_fill_1;
set(gca,'ytick',[])
set(gca,'FontSize',12)
xlabel('Prediction Accuracy (r)')
box off
axis([0.435 0.465 0 40])


figure()
hist(acc_ExpFactor_boot_null)
h=findobj(gca,'Type','patch')
h.FaceColor = color_fill_2;
h.EdgeColor = color_fill_2;
set(gca,'ytick',[])
set(gca,'FontSize',18)
box off
axis([-0.05 0.05 0 30])






