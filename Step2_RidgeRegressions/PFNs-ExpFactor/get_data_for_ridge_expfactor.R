# This script will create a csv of the data we need to run the ridge regressions

# First load in the spatial extent of each PFN (they're in order, 1-17)
# Merging the other data with this file will ensure that we only select subjects for whom we have PFNs generated
pfn_sizes <- read.csv("/Users/askeller/Documents/Kellernet_PrelimAnalysis/All_PFN_sizes.csv")
# Change PFN column names so they're sensible
colnames(pfn_sizes)<-c("subjectkey","PFN1","PFN2","PFN3","PFN4","PFN5","PFN6","PFN7","PFN8","PFN9","PFN10","PFN11","PFN12","PFN13","PFN14","PFN15","PFN16","PFN17")

# Load data
bifactor_scores<-read.csv("/Users/askeller/Documents/ExposomeAnalyses/LongitudinalExpScores/abcd_longitudinal_factor_scores_7f_bifactor.csv")
colnames(bifactor_scores)[1]<-"subjectkey"
colnames(bifactor_scores)[4]<-"ExpFactor" # Rename General_SES to ExpFactor
bifactor_scores.baseline <- bifactor_scores[bifactor_scores$Timepoint=="baseline_year_1_arm_1",]
all.data <- merge(pfn_sizes,bifactor_scores.baseline[,c("subjectkey", setdiff(colnames(bifactor_scores.baseline),colnames(pfn_sizes)))],by="subjectkey")



# Remove subjects based on the following criteria:
## 1) 8min of retained TRs (600 TRs)
## 2) ABCD Booleans for rest and T1
num_TRs <- read.csv("/Users/askeller/Documents/Kellernet_PrelimAnalysis/num_TRs_by_subj_redo.csv")
data<-merge(all.data,num_TRs,by="subjectkey")
data.clean<-data[data$numTRs>=600,]

# Remove participants based on booleans from ABCD
abcd_imgincl01 <- read.csv("/Users/askeller/Documents/Kellernet_PrelimAnalysis/abcd_imgincl01.csv")
abcd_imgincl01 <- abcd_imgincl01[abcd_imgincl01$eventnam=="baseline_year_1_arm_1",]
abcd_imgincl01 <- abcd_imgincl01[!abcd_imgincl01$visit=="",] 
abcd_imgincl01 <- abcd_imgincl01[abcd_imgincl01$imgincl_t1w_include==1,] 
abcd_imgincl01 <- abcd_imgincl01[abcd_imgincl01$imgincl_rsfmri_include==1,]
combined.data <- merge(data.clean,abcd_imgincl01[, c("subjectkey",'imgincl_t1w_include')],by="subjectkey") 

# Add in Family and Site covariates
# Remember to add in this variable about family structure so we can use it as a covariate
family <-read.table("/Users/askeller/Documents/Kellernet_PrelimAnalysis/ses/acspsw03.txt",header=TRUE)
family.baseline<-family[family$eventname=="baseline_year_1_arm_1",]
abcd.data.almost <- merge(combined.data,family.baseline[, c("subjectkey", setdiff(colnames(family.baseline),colnames(combined.data)))],by="subjectkey")

# also add in the variable for site ID to use as a covariate
site_info <- readRDS("/Users/askeller/Documents/Kellernet_PrelimAnalysis/DEAP-siteID.rds")
site.baseline<-site_info[site_info$event_name=="baseline_year_1_arm_1",]
colnames(site.baseline)[1]<-"subjectkey"
abcd.data.almost2 <- merge(abcd.data.almost,site.baseline[,c("subjectkey", setdiff(colnames(site.baseline),colnames(abcd.data.almost)))],by="subjectkey")

# Add mean FD
meanFD <- read.csv("/Users/askeller/Documents/Kellernet_PrelimAnalysis/PFN_Gradients_CombinedScript/getFD/meanFD_031822.csv")
colnames(meanFD)<-c("subjectkey","meanFD")
meanFD$subjectkey <- gsub(pattern="sub-NDAR",replacement="NDAR_", meanFD$subjectkey)
abcd.data <- merge(abcd.data.almost2,meanFD,by="subjectkey")

# Load train/test split from UMinn
traintest<-read_tsv("/Users/askeller/Documents/Kellernet_PrelimAnalysis/participants.tsv")
traintest.baseline<-traintest[traintest$session_id=="ses-baselineYear1Arm1",c("participant_id","matched_group")]
colnames(traintest.baseline)[1]<-c("subjectkey")
traintest.baseline$subjectkey <- gsub(pattern="sub-NDAR",replacement="NDAR_", traintest.baseline$subjectkey)
traintest.baseline<-traintest.baseline %>% distinct()
abcd.data.traintest <- merge(abcd.data,traintest.baseline,by="subjectkey")
abcd.data.train <- abcd.data.traintest[abcd.data.traintest$matched_group==1,]
abcd.data.test <- abcd.data.traintest[abcd.data.traintest$matched_group==2,]
abcd.data.for.ridge<-abcd.data.traintest[,c("subjectkey","ExpFactor","matched_group","interview_age","sex","meanFD","abcd_site","rel_family_id")]
abcd.data.for.ridge.complete<-abcd.data.for.ridge[complete.cases(abcd.data.for.ridge),]
abcd.data.for.ridge.complete$subjectkey <- gsub(pattern="NDAR_",replacement="",abcd.data.for.ridge.complete$subjectkey)

write.csv(abcd.data.for.ridge.complete,"/Users/askeller/Documents/ExposomeAnalyses/PFNs_ExpFactor_Ridge/data_for_ridge_expfactor.csv")
