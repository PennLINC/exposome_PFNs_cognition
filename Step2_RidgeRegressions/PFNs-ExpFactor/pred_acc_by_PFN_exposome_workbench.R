

library(gifti)
library(R.matlab)
library(RNifti)
library(ciftiTools)
ciftiTools.setOption('wb_path', '/Users/askeller/Documents/workbench/')
library(ggplot2)

PFNs_hardparcel<-read_cifti('/Users/askeller/Documents/Kellernet_PrelimAnalysis/hardparcel_group.dscalar.nii')
map_predacc_ExpFactor_lh <- PFNs_hardparcel$data$cortex_left
map_predacc_ExpFactor_rh <- PFNs_hardparcel$data$cortex_right

pred_acc <- readMat('/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/results_by_network/pred_acc_by_PFN_ExpFactor.mat');
pred_acc <- pred_acc$Rvals.byPFN

for (PFN in 1:17) {
    map_predacc_ExpFactor_lh[map_predacc_ExpFactor_lh==PFN,1]=pred_acc[PFN,1]
    map_predacc_ExpFactor_rh[map_predacc_ExpFactor_rh==PFN,1]=pred_acc[PFN,1]
}

PFNs_hardparcel_PredAccExpFactor <- PFNs_hardparcel
PFNs_hardparcel_PredAccExpFactor$data$cortex_left <- map_predacc_ExpFactor_lh
PFNs_hardparcel_PredAccExpFactor$data$cortex_right <- map_predacc_ExpFactor_rh

write_cifti(PFNs_hardparcel_PredAccExpFactor,'/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/results_by_network/PFNs_PredAccExpFactor')



