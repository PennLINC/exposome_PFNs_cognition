
% NOTE: this script is meant to be run with the matlab GUI to make figures

clear all

% Add package to read NPY files into matlab
addpath('/Users/askeller/Documents/npy-matlab/')


%% Get predicted scores - ADI

% Load in prediction results
folder_name='/Users/askeller/Documents/ExposomeAnalyses/CodeForGithub/Step3_SupplementaryAnalyses/PFNs-ADI/';
file_name_pred1_samp1='reshist_addr1_adi_income_prediction_testA.npy';
file_name_pred1_samp2='reshist_addr1_adi_income_prediction_testB.npy';
pred_adi_samp1 = readNPY([folder_name '/' file_name_pred1_samp1]);
pred_adi_samp2 = readNPY([folder_name '/' file_name_pred1_samp2]);


% put predictions on same scale as actual
pred_adi_samp1 = zscore(pred_adi_samp1);
pred_adi_samp2 = zscore(pred_adi_samp2);


%% Get actual scores - ADI

% fourth column has the matched_group
data_for_ridge=xlsread('/Users/askeller/Documents/ExposomeAnalyses/CodeForGithub/Step3_SupplementaryAnalyses/PFNs-ADI/data_for_ridge_adi.xls');

% Load in actual ADI scores
actual_adi = data_for_ridge(:,7);


% split data out by matched group
actual_adi_samp1 = actual_adi(data_for_ridge(:,1)==1);
actual_adi_samp2 = actual_adi(data_for_ridge(:,1)==2);



%% Compare accuracy 
[r,p,ci_low,ci_high]=corrcoef(actual_adi_samp1,pred_adi_samp1)
p(1,2)
[r,p,ci_low,ci_high]=corrcoef(actual_adi_samp2,pred_adi_samp2)
p(1,2)




%% Calculate AIC and BIC

% Use the formula
%    AIC = n * ln(RSS/n) + 2*k
%    BIC = -2 * ln(RSS) + ln(n)*k
%        where n = the sample size
%          and k = the number of parameters in the model 

k=1010004; % 59,412 vertices * 17 networks

% PC1 

n_samp1 = length(actual_adi_samp1);
n_samp2 = length(actual_adi_samp1);

RSS_adi_samp1 = sum((actual_adi_samp1-pred_adi_samp1).^2);
RSS_adi_samp2 = sum((actual_adi_samp1-pred_adi_samp1).^2);

AIC_adi_samp1 = n_samp1 * log(RSS_adi_samp1/n_samp1) + 2
AIC_adi_samp2 = n_samp2 * log(RSS_adi_samp2/n_samp2) + 2

BIC_adi_samp1 = -2*log(RSS_adi_samp1) + log(n_samp1)
BIC_adi_samp2 = -2*log(RSS_adi_samp2) + log(n_samp2)


