# This script will create a csv of the data we need to run the ridge regressions
# This particular version is set up for the Separate Samples ExpFactor (bifactor scores derived separately in the discovery and replication samples)


# First load in the spatial extent of each PFN (they're in order, 1-17) - this is a simple way to restrict our sample to participants who have PFNs generated
pfn_sizes <- read.csv("/Users/askeller/Documents/Kellernet_PrelimAnalysis/All_PFN_sizes.csv")

# Load bifactor exposome score data
bifactor_scores<-read.csv("/Users/askeller/Documents/ExposomeAnalyses/SeparateSamplesExposome/abcd_exposome_longitudinal_scores_discovery_and_replication.csv")
colnames(bifactor_scores)[colnames(bifactor_scores)=="src_subject_id"]<-"subjectkey"

# These bifactor scores were derived separately in the Discovery and Replication samples to avoid contamination across the samples, but we want to treat them as essentially the same (the weights are nearly identical). We will therefore merge the scores for factor 1 from the Discovery sample with the scores for factor 1 from the Replication sample, and ditto for all the other factors. 
bifactor_scores_united = unite(bifactor_scores, ExpFactor, c(General_discovery,General_replication),na.rm=TRUE)

# Extract just the baseline scores and merge with the PFN data
bifactor_scores.baseline <- bifactor_scores_united[bifactor_scores_united$eventname=="baseline_year_1_arm_1",]
all.data <- merge(pfn_sizes,bifactor_scores.baseline[,c("subjectkey", setdiff(colnames(bifactor_scores.baseline),colnames(pfn_sizes)))],by="subjectkey")

# Remove subjects based on the following head motion criteria:
## 1) 8min of retained TRs (600 TRs)
## 2) ABCD Booleans for rest and T1
num_TRs <- read.csv("/Users/askeller/Documents/Kellernet_PrelimAnalysis/num_TRs_by_subj_redo.csv")
data<-merge(all.data,num_TRs,by="subjectkey")
data.clean<-data[data$numTRs>=600,]

# Remove participants based on standardized quality control from ABCD
abcd_imgincl01 <- read.csv("/Users/askeller/Documents/Kellernet_PrelimAnalysis/abcd_imgincl01.csv")
abcd_imgincl01 <- abcd_imgincl01[abcd_imgincl01$eventnam=="baseline_year_1_arm_1",]
abcd_imgincl01 <- abcd_imgincl01[!abcd_imgincl01$visit=="",] 
abcd_imgincl01 <- abcd_imgincl01[abcd_imgincl01$imgincl_t1w_include==1,] 
abcd_imgincl01 <- abcd_imgincl01[abcd_imgincl01$imgincl_rsfmri_include==1,]
combined.data <- merge(data.clean,abcd_imgincl01[, c("subjectkey",'imgincl_t1w_include')],by="subjectkey") 

# Add in Family and Site covariates
family <-read.table("/Users/askeller/Documents/Kellernet_PrelimAnalysis/ses/acspsw03.txt",header=TRUE)
family.baseline<-family[family$eventname=="baseline_year_1_arm_1",]
abcd.data.almost <- merge(combined.data,family.baseline[, c("subjectkey", setdiff(colnames(family.baseline),colnames(combined.data)))],by="subjectkey")
site_info <- readRDS("/Users/askeller/Documents/Kellernet_PrelimAnalysis/DEAP-siteID.rds")
site.baseline<-site_info[site_info$event_name=="baseline_year_1_arm_1",]
colnames(site.baseline)[1]<-"subjectkey"
abcd.data.almost2 <- merge(abcd.data.almost,site.baseline[,c("subjectkey", setdiff(colnames(site.baseline),colnames(abcd.data.almost)))],by="subjectkey")

# Add mean FD (a measure of head motion that we use as a covariate)
meanFD <- read.csv("/Users/askeller/Documents/Kellernet_PrelimAnalysis/PFN_Gradients_CombinedScript/getFD/meanFD_031822.csv")
colnames(meanFD)<-c("subjectkey","meanFD")
meanFD$subjectkey <- gsub(pattern="sub-NDAR",replacement="NDAR_", meanFD$subjectkey)
abcd.data <- merge(abcd.data.almost2,meanFD,by="subjectkey")

# Set up the neat csv with just the data to be used in the ridge regression
abcd.data.for.ridge<-abcd.data[,c("subjectkey","ExpFactor","matched_group","interview_age","sex","meanFD","abcd_site","rel_family_id")] # just the columns we need
abcd.data.for.ridge.complete<-abcd.data.for.ridge[complete.cases(abcd.data.for.ridge),] # makes sure all participants have complete data
abcd.data.for.ridge.complete$subjectkey <- gsub(pattern="NDAR_",replacement="",abcd.data.for.ridge.complete$subjectkey) # this line fixes the subject ID to be in standard format (as expected by the ridge regression code)
write.csv(abcd.data.for.ridge.complete,"/Users/askeller/Documents/ExposomeAnalyses/SeparateSamplesExposome/data_for_ridge_expfactor_separatesamples.csv")
# n=7,460