%% calculate prediction accuracy within each network.

clear all

% Add package to read NPY files into matlab
addpath('/Users/askeller/Documents/npy-matlab/')

% fourth column has the matched_group
data_for_ridge=xlsread('/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/data_for_ridge_expfactor.xls');

% Load in actual scores
actual_ExpFactor = data_for_ridge(:,1);

% split data out by matched group
actual_ExpFactor_samp1 = actual_ExpFactor(data_for_ridge(:,2)==1);
actual_ExpFactor_samp2 = actual_ExpFactor(data_for_ridge(:,2)==2);

% concatenate matched group 1 and matched group 2
actual_ExpFactor = [actual_ExpFactor_samp1; actual_ExpFactor_samp2];

% matrix to collect R values by PFN
Rvals_byPFN = zeros(17,1);


% loop through each PFN and calculate the R value
for eachPFN = 0:16

eval(['folder_name=''/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/results_by_network/' num2str(eachPFN) '_network'';'])

% Load the predicted exposome scores from the ridge regression
file_name_pred1_samp1='ExpFactor_prediction_testA.npy';
file_name_pred1_samp2='ExpFactor_prediction_testB.npy';
pred_ExpFactor_samp1 = readNPY([folder_name '/' file_name_pred1_samp1]);
pred_ExpFactor_samp2 = readNPY([folder_name '/' file_name_pred1_samp2]);


% concatenate across samples:
pred_ExpFactor = [pred_ExpFactor_samp1; pred_ExpFactor_samp2];

% calculate the correlation between actual and predicted
[r_EF,p_EF]=corrcoef(actual_ExpFactor,pred_ExpFactor);

% extract and save R values
Rvals_byPFN(eachPFN+1,1) = r_EF(1,2);

end


save('/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/results_by_network/pred_acc_by_PFN_ExpFactor.mat','Rvals_byPFN')



%% Make bar plots of prediction accuracy by PFN

clear all

% Add package to read NPY files into matlab
addpath('/Users/askeller/Documents/npy-matlab/')

% fourth column has the matched_group
data_for_ridge=xlsread('/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/data_for_ridge_expfactor.xls');

% Load in actual scores
actual_ExpFactor = data_for_ridge(:,1);

% split data out by matched group
actual_ExpFactor_samp1 = actual_ExpFactor(data_for_ridge(:,2)==1);
actual_ExpFactor_samp2 = actual_ExpFactor(data_for_ridge(:,2)==2);

% set empty matrices
pred_acc_ExpFactor_samp1 = [];
pred_acc_ExpFactor_samp2 = [];


for eachPFN = 0:16

    eval(['folder_name=''/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/results_by_network/' num2str(eachPFN) '_network'';'])

    % Load the predicted exposome scores from the ridge regression
    file_name_pred1_samp1='ExpFactor_prediction_testA.npy';
    file_name_pred1_samp2='ExpFactor_prediction_testB.npy';
    pred_ExpFactor_samp1 = readNPY([folder_name '/' file_name_pred1_samp1]);
    pred_ExpFactor_samp2 = readNPY([folder_name '/' file_name_pred1_samp2]);

    % put predictions on same scale as actual
    pred_ExpFactor_samp1 = zscore(pred_ExpFactor_samp1);
    pred_ExpFactor_samp2 = zscore(pred_ExpFactor_samp2);


    % calculate the correlation between actual and predicted (sample 1)
    [r_EF,p_EF]=corrcoef(actual_ExpFactor_samp1,pred_ExpFactor_samp1);
    pred_acc_ExpFactor_samp1 = [pred_acc_ExpFactor_samp1 r_EF(1,2)];

    % calculate the correlation between actual and predicted (sample 2)
    [r_EF,p_EF]=corrcoef(actual_ExpFactor_samp2,pred_ExpFactor_samp2);
    pred_acc_ExpFactor_samp2 = [pred_acc_ExpFactor_samp2 r_EF(1,2)];

end


% Sort the pred accs (sort by average across samples)
[ordered,index_EF]=sort(mean([pred_acc_ExpFactor_samp1; pred_acc_ExpFactor_samp2]));
pred_acc_ExpFactor_samp1_ordered = pred_acc_ExpFactor_samp1(index_EF);
pred_acc_ExpFactor_samp2_ordered = pred_acc_ExpFactor_samp2(index_EF);




%% General Cognition


% load in colors for graph
network_colors =       [215/255 105/255 122/255; 124/255 152/255 190/255; 236/255 188/255 78/255; 124/255 152/255 190/255; 71/255 159/255 66/255; 161/255 61/255 168/255; 211/255 80/255 247/255; 215/255 105/255 122/255; 211/255 80/255 247/255; 161/255 61/255 168/255; 124/255 152/255 190/255; 215/255 105/255 122/255; 124/255 152/255 190/255; 71/255 159/255 66/255; 236/255 188/255 78/255; 74/255 50/255 162/255; 236/255 188/255 78/255];
network_colors_light = [234/255 183/255 191/255; 192/255 205/255 223/255; 245/255 222/255 169/255; 192/255 205/255 223/255; 165/255 208/255 167/255; 208/255 162/255 212/255; 230/255 165/255 250/255; 234/255 183/255 191/255; 230/255 165/255 250/255; 208/255 162/255 212/255; 192/255 205/255 223/255; 234/255 183/255 191/255; 192/255 205/255 223/255; 165/255 208/255 167/255; 245/255 222/255 169/255; 171/255 161/255 209/255; 245/255 222/255 169/255];
network_colors_sorted = network_colors(index_EF,:);
network_colors_light_sorted = network_colors_light(index_EF,:);

figure(1)
for eachPFN2 = 1:17
    bar(eachPFN2,pred_acc_ExpFactor_samp1_ordered(eachPFN2),'BarWidth',0.3,'FaceColor',network_colors_sorted(eachPFN2,:),'EdgeColor','none')
    hold on
    bar(eachPFN2+0.3,pred_acc_ExpFactor_samp2_ordered(eachPFN2),'BarWidth',0.3,'FaceColor',network_colors_light_sorted(eachPFN2,:),'EdgeColor','none')
end
xticks([1.15:1:17.15])
xticklabels(index_EF)
xlabel('Personalized Functional Network','FontSize',14)
ylabel('Prediction Accuracy','FontSize',14)
box off


