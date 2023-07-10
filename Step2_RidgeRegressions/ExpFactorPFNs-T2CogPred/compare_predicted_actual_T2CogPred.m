
% NOTE: this script is meant to be run with the matlab GUI to make figures

clear all

% Add package to read NPY files into matlab
addpath('/Users/askeller/Documents/npy-matlab/')

% Make a list of the tasks so we can loop through them
tasks = {'PicVocab','Flanker','Picture','Pattern','Reading'};


%% Get predicted scores -- ExpFactor model (Exp-Factor only)

% Get the folder name
folder_name='/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/T2CogPred_Results/ExpFactor';

% Loop through cognitive tasks (outcome variables)
for task = 1:length(tasks)

% Get the file name
eval(['file_name_' char(tasks(task)) '_Disc_ExpFactor=''' char(tasks(task)) 'T2_prediction_testA.npy'';'])
eval(['file_name_' char(tasks(task)) '_Rep_ExpFactor=''' char(tasks(task)) 'T2_prediction_testB.npy'';'])

% Load in each file and z-score
eval(['pred_' char(tasks(task)) '_Disc_ExpFactor = zscore(readNPY([folder_name ''/'' file_name_' char(tasks(task)) '_Disc_ExpFactor]));'])
eval(['pred_' char(tasks(task)) '_Rep_ExpFactor = zscore(readNPY([folder_name ''/'' file_name_' char(tasks(task)) '_Rep_ExpFactor]));'])

end


%% Get predicted scores -- PFN model (just PFNs)

% Get the folder name
folder_name='/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/T2CogPred_Results/PFNs';

% Loop through cognitive tasks (outcome variables)
for task = 1:length(tasks)

% Get the file name
eval(['file_name_' char(tasks(task)) '_Disc_PFNs=''' char(tasks(task)) 'T2_prediction_testA.npy'';'])
eval(['file_name_' char(tasks(task)) '_Rep_PFNs=''' char(tasks(task)) 'T2_prediction_testB.npy'';'])

eval(['pred_' char(tasks(task)) '_Disc_PFNs = zscore(readNPY([folder_name ''/'' file_name_' char(tasks(task)) '_Disc_PFNs]));'])
eval(['pred_' char(tasks(task)) '_Rep_PFNs = zscore(readNPY([folder_name ''/'' file_name_' char(tasks(task)) '_Rep_PFNs]));'])

end


%% Get predicted scores -- ExpFactorPFN model (Exp-Factor plus PFNs)

% Get the folder name
folder_name='/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/T2CogPred_Results/ExpFactorPFNs';

% Loop through cognitive tasks (outcome variables)
for task = 1:length(tasks)

% Get the file name
eval(['file_name_' char(tasks(task)) '_Disc_ExpFactorPFNs=''' char(tasks(task)) 'T2_prediction_testA.npy'';'])
eval(['file_name_' char(tasks(task)) '_Rep_ExpFactorPFNs=''' char(tasks(task)) 'T2_prediction_testB.npy'';'])

eval(['pred_' char(tasks(task)) '_Disc_ExpFactorPFNs = zscore(readNPY([folder_name ''/'' file_name_' char(tasks(task)) '_Disc_ExpFactorPFNs]));'])
eval(['pred_' char(tasks(task)) '_Rep_ExpFactorPFNs = zscore(readNPY([folder_name ''/'' file_name_' char(tasks(task)) '_Rep_ExpFactorPFNs]));'])

end

%% Get actual scores

% ELEVENTH column has the matched_group
data_for_ridge=xlsread('/Users/askeller/Documents/ExposomeAnalyses/CodeForGithub/Step2_RidgeRegressions/ExpFactorPFNs-T2CogPred/data_for_ridge_T2CogPred.xls');

% Load in actual T2 cognitive scores
actual_PicVocab = data_for_ridge(:,6);
actual_Flanker = data_for_ridge(:,7);
actual_Picture = data_for_ridge(:,8);
actual_Pattern = data_for_ridge(:,9);
actual_Reading = data_for_ridge(:,10);


%% Calculate accuracy for each model (PICVOCAB)

% EXP-FACTOR

% discovery
[r,p]=corrcoef(actual_PicVocab(data_for_ridge(:,11)==1,:),pred_PicVocab_Disc_ExpFactor);
fprintf('picvocab - discovery - expfactor')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_PicVocab(data_for_ridge(:,11)==2,:),pred_PicVocab_Rep_ExpFactor);
fprintf('picvocab - rep - expfactor')
r(1,2)
p(1,2)


% PFNs

% discovery
[r,p]=corrcoef(actual_PicVocab(data_for_ridge(:,11)==1,:),pred_PicVocab_Disc_PFNs);
fprintf('picvocab - discovery - pfns')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_PicVocab(data_for_ridge(:,11)==2,:),pred_PicVocab_Rep_PFNs);
fprintf('picvocab - rep - pfns')
r(1,2)
p(1,2)


% ExpFactorPFNs

% discovery
[r,p]=corrcoef(actual_PicVocab(data_for_ridge(:,11)==1,:),pred_PicVocab_Disc_ExpFactorPFNs);
fprintf('picvocab - discovery - expfactorPFNs')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_PicVocab(data_for_ridge(:,11)==2,:),pred_PicVocab_Rep_ExpFactorPFNs);
fprintf('picvocab - discovery - expfactorPFNs')
r(1,2)
p(1,2)



%% Calculate accuracy for each model (FLANKER)

% EXP-FACTOR

% discovery
[r,p]=corrcoef(actual_Flanker(data_for_ridge(:,11)==1,:),pred_Flanker_Disc_ExpFactor);
fprintf('flanker - discovery - expfactor')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_Flanker(data_for_ridge(:,11)==2,:),pred_Flanker_Rep_ExpFactor);
fprintf('flanker - rep - expfactor')
r(1,2)
p(1,2)


% PFNs

% discovery
[r,p]=corrcoef(actual_Flanker(data_for_ridge(:,11)==1,:),pred_Flanker_Disc_PFNs);
fprintf('flanker - discovery - pfns')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_Flanker(data_for_ridge(:,11)==2,:),pred_Flanker_Rep_PFNs);
fprintf('flanker - rep - pfns')
r(1,2)
p(1,2)


% ExpFactorPFNs

% discovery
[r,p]=corrcoef(actual_Flanker(data_for_ridge(:,11)==1,:),pred_Flanker_Disc_ExpFactorPFNs);
fprintf('flanker - discovery - expfactorPFNs')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_Flanker(data_for_ridge(:,11)==2,:),pred_Flanker_Rep_ExpFactorPFNs);
fprintf('flanker - rep - expfactorPFNs')
r(1,2)
p(1,2)


%% Calculate accuracy for each model (Picture)

% EXP-FACTOR

% discovery
[r,p]=corrcoef(actual_Picture(data_for_ridge(:,11)==1,:),pred_Picture_Disc_ExpFactor);
fprintf('Picture - discovery - expfactor')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_Picture(data_for_ridge(:,11)==2,:),pred_Picture_Rep_ExpFactor);
fprintf('Picture - rep - expfactor')
r(1,2)
p(1,2)


% PFNs

% discovery
[r,p]=corrcoef(actual_Picture(data_for_ridge(:,11)==1,:),pred_Picture_Disc_PFNs);
fprintf('Picture - discovery - pfns')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_Picture(data_for_ridge(:,11)==2,:),pred_Picture_Rep_PFNs);
fprintf('Picture - rep - pfns')
r(1,2)
p(1,2)


% ExpFactorPFNs

% discovery
[r,p]=corrcoef(actual_Picture(data_for_ridge(:,11)==1,:),pred_Picture_Disc_ExpFactorPFNs);
fprintf('Picture - discovery - expfactorPFNs')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_Picture(data_for_ridge(:,11)==2,:),pred_Picture_Rep_ExpFactorPFNs);
fprintf('Picture - rep - expfactorPFNs')
r(1,2)
p(1,2)



%% Calculate accuracy for each model (Pattern)

% EXP-FACTOR

% discovery
[r,p]=corrcoef(actual_Pattern(data_for_ridge(:,11)==1,:),pred_Pattern_Disc_ExpFactor);
fprintf('Pattern - discovery - expfactor')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_Pattern(data_for_ridge(:,11)==2,:),pred_Pattern_Rep_ExpFactor);
fprintf('Pattern - rep - expfactor')
r(1,2)
p(1,2)


% PFNs

% discovery
[r,p]=corrcoef(actual_Pattern(data_for_ridge(:,11)==1,:),pred_Pattern_Disc_PFNs);
fprintf('Pattern - discovery - pfns')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_Pattern(data_for_ridge(:,11)==2,:),pred_Pattern_Rep_PFNs);
fprintf('Pattern - rep - pfns')
r(1,2)
p(1,2)


% ExpFactorPFNs

% discovery
[r,p]=corrcoef(actual_Pattern(data_for_ridge(:,11)==1,:),pred_Pattern_Disc_ExpFactorPFNs);
fprintf('Pattern - discovery - expfactorPFNs')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_Pattern(data_for_ridge(:,11)==2,:),pred_Pattern_Rep_ExpFactorPFNs);
fprintf('Pattern - rep - expfactorPFNs')
r(1,2)
p(1,2)


%% Calculate accuracy for each model (Reading)

% EXP-FACTOR

% discovery
[r,p]=corrcoef(actual_Reading(data_for_ridge(:,11)==1,:),pred_Reading_Disc_ExpFactor);
fprintf('Reading - discovery - expfactor')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_Reading(data_for_ridge(:,11)==2,:),pred_Reading_Rep_ExpFactor);
fprintf('Reading - rep - expfactor')
r(1,2)
p(1,2)


% PFNs

% discovery
[r,p]=corrcoef(actual_Reading(data_for_ridge(:,11)==1,:),pred_Reading_Disc_PFNs);
fprintf('Reading - discovery - pfns')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_Reading(data_for_ridge(:,11)==2,:),pred_Reading_Rep_PFNs);
fprintf('Reading - rep - pfns')
r(1,2)
p(1,2)


% ExpFactorPFNs

% discovery
[r,p]=corrcoef(actual_Reading(data_for_ridge(:,11)==1,:),pred_Reading_Disc_ExpFactorPFNs);
fprintf('Reading - discovery - expfactorPFNs')
r(1,2)
p(1,2)

% replication
[r,p]=corrcoef(actual_Reading(data_for_ridge(:,11)==2,:),pred_Reading_Rep_ExpFactorPFNs);
fprintf('Reading - rep - expfactorPFNs')
r(1,2)
p(1,2)


%% Calculate AIC
% Use the formula
%    AIC = n * ln(RSS/n) + 2*k
%        where n = the sample size
%          and k = the number of parameters in the model 

k=1010004; % 59,412 vertices * 17 networks
n_samp1 = length(pred_Reading_Disc_ExpFactorPFNs);
n_samp2 = length(pred_Reading_Rep_ExpFactorPFNs);


% Loop through cognitive tasks (outcome variables)
for task = 1:length(tasks)

fprintf(" ************* ")
fprintf(char(tasks(task)))
fprintf(" ************* ")

fprintf("Exp-Factor")
eval(['RSS_samp1 = sum((actual_' char(tasks(task)) '(data_for_ridge(:,11)==1,:)-pred_' char(tasks(task)) '_Disc_ExpFactor).^2);'])
eval(['RSS_samp2 = sum((actual_' char(tasks(task)) '(data_for_ridge(:,11)==2,:)-pred_' char(tasks(task)) '_Rep_ExpFactor).^2);'])
AIC_samp1 = n_samp1 * log(RSS_samp1/n_samp1) + 2
AIC_samp2 = n_samp2 * log(RSS_samp2/n_samp2) + 2


fprintf("PFNs")
eval(['RSS_samp1 = sum((actual_' char(tasks(task)) '(data_for_ridge(:,11)==1,:)-pred_' char(tasks(task)) '_Disc_PFNs).^2);'])
eval(['RSS_samp2 = sum((actual_' char(tasks(task)) '(data_for_ridge(:,11)==2,:)-pred_' char(tasks(task)) '_Rep_PFNs).^2);'])
AIC_samp1 = n_samp1 * log(RSS_samp1/n_samp1) + 2*k
AIC_samp2 = n_samp2 * log(RSS_samp2/n_samp2) + 2*k

fprintf("ExpFactorPFNs")
eval(['RSS_samp1 = sum((actual_' char(tasks(task)) '(data_for_ridge(:,11)==1,:)-pred_' char(tasks(task)) '_Disc_ExpFactorPFNs).^2);'])
eval(['RSS_samp2 = sum((actual_' char(tasks(task)) '(data_for_ridge(:,11)==2,:)-pred_' char(tasks(task)) '_Rep_ExpFactorPFNs).^2);'])
AIC_samp1 = n_samp1 * log(RSS_samp1/n_samp1) + 2*(k+1)
AIC_samp2 = n_samp2 * log(RSS_samp2/n_samp2) + 2*(k+1)

end



%% Calculate BIC
% Use the formula
%    BIC = -2 * ln(RSS) + ln(n)*k
%        where n = the sample size
%          and k = the number of parameters in the model 

k=1010004; % 59,412 vertices * 17 networks
n_samp1 = length(pred_Reading_Disc_ExpFactorPFNs);
n_samp2 = length(pred_Reading_Rep_ExpFactorPFNs);


% Loop through cognitive tasks (outcome variables)
for task = 1:length(tasks)

fprintf(" ************* ")
fprintf(char(tasks(task)))
fprintf(" ************* ")

fprintf("Exp-Factor")
eval(['RSS_samp1 = sum((actual_' char(tasks(task)) '(data_for_ridge(:,11)==1,:)-pred_' char(tasks(task)) '_Disc_ExpFactor).^2);'])
eval(['RSS_samp2 = sum((actual_' char(tasks(task)) '(data_for_ridge(:,11)==2,:)-pred_' char(tasks(task)) '_Rep_ExpFactor).^2);'])
BIC_samp1 = (-2*log(RSS_samp1)) + log(n_samp1)
BIC_samp2 = (-2*log(RSS_samp2)) + log(n_samp2)


fprintf("PFNs")
eval(['RSS_samp1 = sum((actual_' char(tasks(task)) '(data_for_ridge(:,11)==1,:)-pred_' char(tasks(task)) '_Disc_PFNs).^2);'])
eval(['RSS_samp2 = sum((actual_' char(tasks(task)) '(data_for_ridge(:,11)==2,:)-pred_' char(tasks(task)) '_Rep_PFNs).^2);'])
BIC_samp1 = (-2*log(RSS_samp1)) + log(n_samp1)*k
BIC_samp2 = (-2*log(RSS_samp2)) + log(n_samp2)*k

fprintf("ExpFactorPFNs")
eval(['RSS_samp1 = sum((actual_' char(tasks(task)) '(data_for_ridge(:,11)==1,:)-pred_' char(tasks(task)) '_Disc_ExpFactorPFNs).^2);'])
eval(['RSS_samp2 = sum((actual_' char(tasks(task)) '(data_for_ridge(:,11)==2,:)-pred_' char(tasks(task)) '_Rep_ExpFactorPFNs).^2);'])
BIC_samp1 = (-2*log(RSS_samp1)) + log(n_samp1)*(k+1)
BIC_samp2 = (-2*log(RSS_samp2)) + log(n_samp2)*(k+1)

end
