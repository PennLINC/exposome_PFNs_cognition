
# Read in exposome data
data<-read.csv("/Users/askeller/Documents/ExposomeAnalyses/ABCD_longitudinal_exposome_temp.csv")

# Sum all extracurricular activities
data$all_activities <- as.numeric(data$sai_p_activities___0)+as.numeric(data$sai_p_activities___1)+as.numeric(data$sai_p_activities___2)+as.numeric(data$sai_p_activities___3)+as.numeric(data$sai_p_activities___4)+as.numeric(data$sai_p_activities___5)+as.numeric(data$sai_p_activities___6)+as.numeric(data$sai_p_activities___7)+as.numeric(data$sai_p_activities___8)+as.numeric(data$sai_p_activities___9)+as.numeric(data$sai_p_activities___10)+as.numeric(data$sai_p_activities___11)+as.numeric(data$sai_p_activities___12)+as.numeric(data$sai_p_activities___13)+as.numeric(data$sai_p_activities___14)+as.numeric(data$sai_p_activities___15)+as.numeric(data$sai_p_activities___16)+as.numeric(data$sai_p_activities___17)+as.numeric(data$sai_p_activities___18)+as.numeric(data$sai_p_activities___19)+as.numeric(data$sai_p_activities___20)+as.numeric(data$sai_p_activities___21)+as.numeric(data$sai_p_activities___22)+as.numeric(data$sai_p_activities___23)+as.numeric(data$sai_p_activities___24)+as.numeric(data$sai_p_activities___25)+as.numeric(data$sai_p_activities___26)+as.numeric(data$sai_p_activities___27)+as.numeric(data$sai_p_activities___28)+as.numeric(data$sai_p_activities___29)

# Separate out the timepoints
data.baseline <- data[data$eventname=="baseline_year_1_arm_1",]
data.twoyear <- data[data$eventname=="2_year_follow_up_y_arm_1",]

# Compute correlations between extracurricular activities and TBIs
cor.test(data.baseline$TBIs,data.baseline$all_activities)
cor.test(data.twoyear$TBIs,data.twoyear$all_activities)

