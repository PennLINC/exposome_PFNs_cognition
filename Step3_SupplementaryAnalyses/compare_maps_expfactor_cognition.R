

# Load in libraries
library(gifti)
library(R.matlab)
library(RNifti)
library(ciftiTools)
ciftiTools.setOption('wb_path', '/Users/askeller/Documents/workbench/')
library(ggplot2)
library(randomcoloR)
library(ggforce)
library(mgcv)



# Load in prediction accuracy for Exp Factor by PFNs
ExpFactorMap <- readMat('/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/results_by_network/pred_acc_by_PFN_ExpFactor.mat')$Rvals.byPFN;

# Load in prediction accuracy for Cognition by PFNs
CognitionMap <- read.csv('/Users/askeller/Documents/Kellernet_PrelimAnalysis/SpinTests/pred_acc_by_PFN.csv')$PC1


# How correlated are these vectors? 
# r=0.933, p-value = 4.842e-08
cor.test(ExpFactorMap,CognitionMap)

# Where are the differences?
SubtractedMap <- CognitionMap-ExpFactorMap

# Get map for workbench
PFNs_hardparcel<-read_cifti('/Users/askeller/Documents/Kellernet_PrelimAnalysis/hardparcel_group.dscalar.nii')
SubtractedMap_lh <- PFNs_hardparcel$data$cortex_left
SubtractedMap_rh <- PFNs_hardparcel$data$cortex_right

for (PFN in 1:17) {
  SubtractedMap_lh[SubtractedMap_lh==PFN,1]=SubtractedMap[PFN,1]
  SubtractedMap_rh[SubtractedMap_rh==PFN,1]=SubtractedMap[PFN,1]
}

PFNs_hardparcel_SubtractedMap <- PFNs_hardparcel
PFNs_hardparcel_SubtractedMap$data$cortex_left <- SubtractedMap_lh
PFNs_hardparcel_SubtractedMap$data$cortex_right <- SubtractedMap_rh

write_cifti(PFNs_hardparcel_SubtractedMap,'/Users/askeller/Documents/Kellernet_PrelimAnalysis/CogExpSubtractedMap')





