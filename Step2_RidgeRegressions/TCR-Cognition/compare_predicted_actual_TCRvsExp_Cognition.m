
% NOTE: this script is meant to be run with the matlab GUI to make figures

clear all

% Add package to read NPY files into matlab
addpath('/Users/askeller/Documents/npy-matlab/')


%% Get predicted scores (Exp-Factor)

% Load in prediction results
folder_name='/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/PFNvsExp_Cognition/results_all_network_Exp';
file_name_pred1_samp1_exp='thompson_PC1_prediction_testA.npy';
file_name_pred2_samp1_exp='thompson_PC2_prediction_testA.npy';
file_name_pred3_samp1_exp='thompson_PC3_prediction_testA.npy';
file_name_pred1_samp2_exp='thompson_PC1_prediction_testB.npy';
file_name_pred2_samp2_exp='thompson_PC2_prediction_testB.npy';
file_name_pred3_samp2_exp='thompson_PC3_prediction_testB.npy';
pred_PC1_samp1_exp = readNPY([folder_name '/' file_name_pred1_samp1_exp]);
pred_PC2_samp1_exp = readNPY([folder_name '/' file_name_pred2_samp1_exp]);
pred_PC3_samp1_exp = readNPY([folder_name '/' file_name_pred3_samp1_exp]);
pred_PC1_samp2_exp = readNPY([folder_name '/' file_name_pred1_samp2_exp]);
pred_PC2_samp2_exp = readNPY([folder_name '/' file_name_pred2_samp2_exp]);
pred_PC3_samp2_exp = readNPY([folder_name '/' file_name_pred3_samp2_exp]);

% put predictions on same scale as actual
pred_PC1_samp1_exp = zscore(pred_PC1_samp1_exp);
pred_PC2_samp1_exp = zscore(pred_PC2_samp1_exp);
pred_PC3_samp1_exp = zscore(pred_PC3_samp1_exp);
pred_PC1_samp2_exp = zscore(pred_PC1_samp2_exp);
pred_PC2_samp2_exp = zscore(pred_PC2_samp2_exp);
pred_PC3_samp2_exp = zscore(pred_PC3_samp2_exp);


%% Get predicted scores (TCR)

% Load in prediction results
folder_name='/Users/askeller/Documents/ExposomeAnalyses/CodeForGithub/Step2_RidgeRegressions/TCR-Cognition/results';
file_name_pred1_samp1_tcr='thompson_PC1_prediction_testA.npy';
file_name_pred2_samp1_tcr='thompson_PC2_prediction_testA.npy';
file_name_pred3_samp1_tcr='thompson_PC3_prediction_testA.npy';
file_name_pred1_samp2_tcr='thompson_PC1_prediction_testB.npy';
file_name_pred2_samp2_tcr='thompson_PC2_prediction_testB.npy';
file_name_pred3_samp2_tcr='thompson_PC3_prediction_testB.npy';
pred_PC1_samp1_tcr = readNPY([folder_name '/' file_name_pred1_samp1_tcr]);
pred_PC2_samp1_tcr = readNPY([folder_name '/' file_name_pred2_samp1_tcr]);
pred_PC3_samp1_tcr = readNPY([folder_name '/' file_name_pred3_samp1_tcr]);
pred_PC1_samp2_tcr = readNPY([folder_name '/' file_name_pred1_samp2_tcr]);
pred_PC2_samp2_tcr = readNPY([folder_name '/' file_name_pred2_samp2_tcr]);
pred_PC3_samp2_tcr = readNPY([folder_name '/' file_name_pred3_samp2_tcr]);

% put predictions on same scale as actual
pred_PC1_samp1_tcr = zscore(pred_PC1_samp1_tcr);
pred_PC2_samp1_tcr = zscore(pred_PC2_samp1_tcr);
pred_PC3_samp1_tcr = zscore(pred_PC3_samp1_tcr);
pred_PC1_samp2_tcr = zscore(pred_PC1_samp2_tcr);
pred_PC2_samp2_tcr = zscore(pred_PC2_samp2_tcr);
pred_PC3_samp2_tcr = zscore(pred_PC3_samp2_tcr);

%% Get actual scores

% fourth column has the matched_group
data_for_ridge=xlsread('/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/PFNvsExp_Cognition/data_for_ridge_PFNandExp.xls');

% Load in actual cognitive scores
actual_PC1 = data_for_ridge(:,1);
actual_PC2 = data_for_ridge(:,2);
actual_PC3 = data_for_ridge(:,3);

% split data out by matched group
actual_PC1_samp1 = actual_PC1(data_for_ridge(:,4)==1);
actual_PC1_samp2 = actual_PC1(data_for_ridge(:,4)==2);
actual_PC2_samp1 = actual_PC2(data_for_ridge(:,4)==1);
actual_PC2_samp2 = actual_PC2(data_for_ridge(:,4)==2);
actual_PC3_samp1 = actual_PC3(data_for_ridge(:,4)==1);
actual_PC3_samp2 = actual_PC3(data_for_ridge(:,4)==2);



%% Compare accuracy between EXP-FACTOR and TCR models
%% PC1
[r_exp,p]=corrcoef(actual_PC1_samp1,pred_PC1_samp1_exp)
p(1,2)
[r_exp,p]=corrcoef(actual_PC1_samp2,pred_PC1_samp2_exp)
p(1,2)
[r_tcr,p]=corrcoef(actual_PC1_samp1,pred_PC1_samp1_tcr)
p(1,2)
[r_tcr,p]=corrcoef(actual_PC1_samp2,pred_PC1_samp2_tcr)
p(1,2)

%% PC2
[r_exp,p]=corrcoef(actual_PC2_samp1,pred_PC2_samp1_exp)
p(1,2)
[r_exp,p]=corrcoef(actual_PC2_samp2,pred_PC2_samp2_exp)
p(1,2)
[r_tcr,p]=corrcoef(actual_PC2_samp1,pred_PC2_samp1_tcr)
p(1,2)
[r_tcr,p]=corrcoef(actual_PC2_samp2,pred_PC2_samp2_tcr)
p(1,2)

%% PC3
[r_exp,p]=corrcoef(actual_PC3_samp1,pred_PC3_samp1_exp)
p(1,2)
[r_exp,p]=corrcoef(actual_PC3_samp2,pred_PC3_samp2_exp)
p(1,2)
[r_tcr,p]=corrcoef(actual_PC3_samp1,pred_PC3_samp1_tcr)
p(1,2)
[r_tcr,p]=corrcoef(actual_PC3_samp2,pred_PC3_samp2_tcr)
p(1,2)





%% Calculate AIC and BIC

% Use the formula
%    AIC = n * ln(RSS/n) + 2*k
%    BIC = -2 * ln(RSS) + ln(n)*k
%        where n = the sample size
%          and k = the number of parameters in the model 

k=17; % 17 networks

% PC1 

n_samp1 = length(actual_PC1_samp1);
n_samp2 = length(actual_PC1_samp2);

RSS_PC1_samp1_exp = sum((actual_PC1_samp1-pred_PC1_samp1_exp).^2);
RSS_PC1_samp2_exp = sum((actual_PC1_samp2-pred_PC1_samp2_exp).^2);

RSS_PC1_samp1_tcr = sum((actual_PC1_samp1-pred_PC1_samp1_tcr).^2);
RSS_PC1_samp2_tcr = sum((actual_PC1_samp2-pred_PC1_samp2_tcr).^2);

AIC_PC1_samp1_exp = n_samp1 * log(RSS_PC1_samp1_exp/n_samp1) + 2
AIC_PC1_samp2_exp = n_samp2 * log(RSS_PC1_samp2_exp/n_samp2) + 2

AIC_PC1_samp1_tcr = n_samp1 * log(RSS_PC1_samp1_tcr/n_samp1) + 2*(k+1)
AIC_PC1_samp2_tcr = n_samp2 * log(RSS_PC1_samp2_tcr/n_samp2) + 2*(k+1)


BIC_PC1_samp1_exp = -2*log(RSS_PC1_samp1_exp) + log(n_samp1)
BIC_PC1_samp2_exp = -2*log(RSS_PC1_samp2_exp) + log(n_samp2)

BIC_PC1_samp1_tcr = -2*log(RSS_PC1_samp1_tcr) + log(n_samp1)*(k+1)
BIC_PC1_samp2_tcr = -2*log(RSS_PC1_samp2_tcr) + log(n_samp2)*(k+1)


% PC2

n_samp1 = length(actual_PC2_samp1);
n_samp2 = length(actual_PC2_samp2);

RSS_PC2_samp1_exp = sum((actual_PC2_samp1-pred_PC2_samp1_exp).^2);
RSS_PC2_samp2_exp = sum((actual_PC2_samp2-pred_PC2_samp2_exp).^2);

RSS_PC2_samp1_tcr = sum((actual_PC2_samp1-pred_PC2_samp1_tcr).^2);
RSS_PC2_samp2_tcr = sum((actual_PC2_samp2-pred_PC2_samp2_tcr).^2);

AIC_PC2_samp1_exp = n_samp1 * log(RSS_PC2_samp1_exp/n_samp1) + 2
AIC_PC2_samp2_exp = n_samp2 * log(RSS_PC2_samp2_exp/n_samp2) + 2

AIC_PC2_samp1_tcr = n_samp1 * log(RSS_PC2_samp1_tcr/n_samp1) + 2*(k+1)
AIC_PC2_samp2_tcr = n_samp2 * log(RSS_PC2_samp2_tcr/n_samp2) + 2*(k+1)


BIC_PC2_samp1_exp = -2*log(RSS_PC2_samp1_exp) + log(n_samp1)
BIC_PC2_samp2_exp = -2*log(RSS_PC2_samp2_exp) + log(n_samp2)

BIC_PC2_samp1_tcr = -2*log(RSS_PC2_samp1_tcr) + log(n_samp1)*(k+1)
BIC_PC2_samp2_tcr = -2*log(RSS_PC2_samp2_tcr) + log(n_samp2)*(k+1)


% PC3 

n_samp1 = length(actual_PC3_samp1);
n_samp2 = length(actual_PC3_samp2);

RSS_PC3_samp1_exp = sum((actual_PC3_samp1-pred_PC3_samp1_exp).^2);
RSS_PC3_samp2_exp = sum((actual_PC3_samp2-pred_PC3_samp2_exp).^2);

RSS_PC3_samp1_tcr = sum((actual_PC3_samp1-pred_PC3_samp1_tcr).^2);
RSS_PC3_samp2_tcr = sum((actual_PC3_samp2-pred_PC3_samp2_tcr).^2);

AIC_PC3_samp1_exp = n_samp1 * log(RSS_PC3_samp1_exp/n_samp1) + 2
AIC_PC3_samp2_exp = n_samp2 * log(RSS_PC3_samp2_exp/n_samp2) + 2

AIC_PC3_samp1_tcr = n_samp1 * log(RSS_PC3_samp1_tcr/n_samp1) + 2*(k+1)
AIC_PC3_samp2_tcr = n_samp2 * log(RSS_PC3_samp2_tcr/n_samp2) + 2*(k+1)


BIC_PC3_samp1_exp = -2*log(RSS_PC3_samp1_exp) + log(n_samp1)
BIC_PC3_samp2_exp = -2*log(RSS_PC3_samp2_exp) + log(n_samp2)

BIC_PC3_samp1_tcr = -2*log(RSS_PC3_samp1_tcr) + log(n_samp1)*(k+1)
BIC_PC3_samp2_tcr = -2*log(RSS_PC3_samp2_tcr) + log(n_samp2)*(k+1)
