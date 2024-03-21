
library(psych)
library(qgraph)
library(Matrix)
library(missForest)

# read in data
x <- read.csv("exposome_arielle.csv")

# remove rows missing 20 or more values
x <- x[rowSums(is.na(x)) < 20,]

# convert some variables to factors for missForest()
for (i in 1:ncol(x)) {if (length(table(x[,i])) < 3) {x[,i] <- as.factor(x[,i])}}

# limit data to what we plan to impute
temp <- x[,c(3:102,133:136,148:157,171:172)]

# impute data in chunks because missForest() takes a very long time with 
# data sets beyond a certain size
set.seed(2023)
temp1 <- missForest(temp[,1:15])$ximp
set.seed(2023)
temp2 <- missForest(temp[,16:30])$ximp
set.seed(2023)
temp3 <- missForest(temp[,31:45])$ximp
set.seed(2023)
temp4 <- missForest(temp[,46:60])$ximp
set.seed(2023)
temp5 <- missForest(temp[,61:75])$ximp
set.seed(2023)
temp6 <- missForest(temp[,76:90])$ximp
set.seed(2023)
temp7 <- missForest(temp[,91:98])$ximp
set.seed(2023)
temp8 <- missForest(temp[,99:116])$ximp

# put imputed data frames back together as "temp"
temp <- data.frame(temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8)

# re-insert "temp", now imputed, into the original matrix
x[,c(3:102,133:136,148:157,171:172)] <- temp

# write out file so it never has to be imputed again
# write.csv(x,"exposome_arielle_imputed.csv",na="",row.names=FALSE)

# read in imputed file
x <- read.csv("exposome_arielle_imputed.csv")

# create composite variables
school_Enjoy <- rowMeans(data.frame(x$school_12_y,x$school_15_y*(-1),x$school_3_y),na.rm=TRUE)
school_FeelInvolved <- rowMeans(data.frame(x$school_10_y,x$school_5_y,x$school_2_y,x$school_6_y),na.rm=TRUE)
school_GoodGrades <- rowMeans(data.frame(x$school_8_y,x$school_17_y*(-1),x$school_9_y),na.rm=TRUE) 
school_PositiveFeedback <- rowMeans(data.frame(x$school_7_y,x$school_4_y),na.rm=TRUE) 
family_probs_youth_BadKey <- rowMeans(data.frame(x$fes_youth_q1,x$fes_youth_q3,x$fes_youth_q5,x$fes_youth_q6,x$fes_youth_q8),na.rm=TRUE)
family_probs_youth_GoodKey <- rowMeans(data.frame(x$fes_youth_q2,x$fes_youth_q4,x$fes_youth_q7,x$fes_youth_q9),na.rm=TRUE)
family_probs_parent_BadKey <- rowMeans(data.frame(x$fam_enviro1_p,x$fam_enviro3_p,x$fam_enviro5_p,x$fam_enviro6_p,x$fam_enviro8_p),na.rm=TRUE)
family_probs_parent_GoodKey <- rowMeans(data.frame(x$fam_enviro2r_p,x$fam_enviro4r_p,x$fam_enviro7r_p,x$fam_enviro9r_p),na.rm=TRUE)
parent_monitor <- rowMeans(data.frame(x$parent_monitor_q1_y,x$parent_monitor_q2_y,x$parent_monitor_q3_y,x$parent_monitor_q4_y,x$parent_monitor_q5_y),na.rm=TRUE)
nbrhd_safety_parent <- rowMeans(data.frame(x$neighborhood1r_p,x$neighborhood2r_p,x$neighborhood3r_p),na.rm=TRUE)
substance_risk <- rowMeans(data.frame(x$su_risk_p_1,x$su_risk_p_2,x$su_risk_p_3,x$su_risk_p_4,x$su_risk_p_5),na.rm=TRUE)
mexAm_Religiosity <- rowMeans(data.frame(x$mex_american25_p,x$mex_american15_p,x$mex_american11_p,x$mex_american20_p,x$mex_american6_p,x$mex_american1_p,x$mex_american28_p),na.rm=TRUE)
mexAm_CaringSecurity <- rowMeans(data.frame(x$mex_american16_p,x$mex_american13_p,x$mex_american7_p,x$mex_american21_p,x$mex_american8_p,x$mex_american26_p,x$mex_american9_p,x$mex_american23_p,x$mex_american14_p,x$mex_american17_p,x$mex_american12_p),na.rm=TRUE)
mexAm_FamilyImage <- rowMeans(data.frame(x$mex_american18_p,x$mex_american4_p,x$mex_american27_p,x$mex_american3_p,x$mex_american2_p,x$mex_american22_p),na.rm=TRUE)
mexAm_Independence <- rowMeans(data.frame(x$mex_american10_p,x$mex_american5_p,x$mex_american24_p,x$mex_american19_p),na.rm=TRUE)
parent_rules <- rowMeans(data.frame(x$parent_rules_q1,x$parent_rules_q4,x$parent_rules_q7),na.rm=TRUE)
activities_Feminine <- rowMeans(data.frame(x$sai_p_activities___24,x$sai_p_activities___0,x$sai_p_activities___26,x$sai_p_activities___22,x$sai_p_activities___25,x$sai_p_activities___9,x$sai_p_activities___6,x$sai_p_activities___23,x$sai_p_activities___8,x$sai_p_activities___17,x$sai_p_read,x$sai_p_activities___27),na.rm=TRUE)
activities_Masculine <- rowMeans(data.frame(x$sai_p_activities___5,x$sai_p_activities___2,x$sai_p_activities___1,x$sai_p_activities___13,x$sai_p_activities___20,x$sai_p_activities___12,x$sai_p_activities___14),na.rm=TRUE)
activities_Other <- rowMeans(data.frame(x$sai_p_activities___18,x$sai_p_activities___28,x$sai_p_lmusic,x$sai_p_activities___21,x$sai_p_activities___19,x$sai_p_activities___3,x$sai_p_activities___11,x$sai_p_activities___16,x$sai_p_activities___15,x$sai_p_activities___7,x$sai_p_activities___4,x$sai_p_activities___10),na.rm=TRUE)
TBIs <- rowMeans(data.frame(x$tbi_1,x$tbi_2,x$tbi_3,x$tbi_4,x$tbi_5,x$tbi_6o,x$tbi_7a),na.rm=TRUE)
peer_deviance <- rowMeans(data.frame(x$peer_deviance_1,x$peer_deviance_2,x$peer_deviance_3,x$peer_deviance_4,x$peer_deviance_8,x$peer_deviance_9),na.rm=TRUE)
screen_time <- rowMeans(data.frame(x$screentime_11_wknd_br,x$screentime_5_wkdy_br,x$screentime_6_wkdy_br,x$screentime_12_wknd_br,x$screentime_14_wknd_br,x$screentime_8_wkdy_br,x$screentime_2_wkdy_br,x$screentime_8_wknd_br,x$screentime_1_wkdy_br,x$screentime_7_wknd_br),na.rm=TRUE)
devices <- rowMeans(data.frame(x$screentime_scrn_media_p__1,x$screentime_scrn_media_p__2,x$screentime_scrn_media_p__3,x$screentime_scrn_media_p__4,x$screentime_scrn_media_p__5,x$screentime_scrn_media_p__6,x$screentime_scrn_media_p__7,x$screentime_device_p__1,x$screentime_device_p__2,x$screentime_device_p__3,x$screentime_device_p__4,x$screentime_device_p__6),na.rm=TRUE)
x <- data.frame(x,school_Enjoy,school_FeelInvolved,school_GoodGrades,school_PositiveFeedback,family_probs_youth_BadKey,family_probs_youth_GoodKey,family_probs_parent_BadKey,family_probs_parent_GoodKey,parent_monitor,nbrhd_safety_parent,substance_risk,mexAm_Religiosity,mexAm_CaringSecurity,mexAm_FamilyImage,mexAm_Independence,parent_rules,activities_Feminine,activities_Masculine,activities_Other,TBIs,peer_deviance,screen_time,devices)

# scale variables
x[,173:195] <- scale(x[,173:195])

# create a unique ID combining ID and timepoint
uid <- paste0(x$src_subject_id,"_",x$eventname)

# put data together
x <- data.frame(uid,x)

# write/save data set
# write.csv(x,"arielle_individual_exposome_with_scores.csv",na="",row.names=FALSE)


# read in geolocation-based data
x <- read.csv("geo_data.csv")

# limit to variables of interest
x <- x[,c(1:106,133,138:186)]

# remove rows missing 50 or more values
x <- x[rowSums(is.na(x)) < 50,]

# remove some columns we don't want, mostly due to their correlation > 0.90 with
# some other variable in the data set
x <- x[,!colnames(x) %in% c("reshist_addr1_coi_r_coi_met","reshist_addr1_coi_r_se_met","reshist_addr1_coi_c5_coi_met","reshist_addr1_coi_z_ed_nat","reshist_addr1_coi_r_coi_stt","reshist_addr1_svi_th1_20142018","reshist_addr1_dui","reshist_addr1_coi_r_se_stt","reshist_addr1_drgposs","reshist_addr1_coi_c5_coi_stt","reshist_addr1_mjsale","reshist_addr1_coi_z_se_nat","reshist_addr1_coi_r_ed_met","reshist_addr1_drgsale","reshist_addr1_coi_r_coi_nat","reshist_addr1_drugtot","reshist_addr1_coi_c5_ed_met","reshist_addr1_coi_r_se_nat","reshist_addr1_coi_r_ed_stt","reshist_addr1_coi_r_he_met","reshist_addr1_p1vlnt","reshist_addr1_coi_z_he_nat","reshist_addr1_leadrisk_poverty","reshist_addr1_opat_kfrpp_avg","reshist_addr1_coi_c5_ed_stt","reshist_addr1_coi_c5_se_met","reshist_addr1_coi_c5_se_stt","reshist_addr1_adi_b138","reshist_addr1_adi_edu_l","reshist_addr1_adi_home_o","reshist_addr1_adi_home_v","reshist_addr1_adi_income","reshist_addr1_adi_pov","reshist_addr1_coi_c5_ed_nat","reshist_addr1_coi_c5_he_nat","reshist_addr1_coi_c5_he_stt","reshist_addr1_coi_c5_se_nat","reshist_addr1_coi_ed_attain","reshist_addr1_coi_ed_math","reshist_addr1_coi_r_he_stt","reshist_addr1_coi_z_coi_nat","reshist_addr1_grndtot","reshist_addr1_opat_kfrpp_p1","reshist_addr1_opat_kfrpp_p25","reshist_addr1_opat_kfrpp_p50","reshist_addr1_opat_kfrpp_p75","reshist_addr1_scanweektemp_t1","reshist_addr1_scanweektemp_t2","reshist_addr1_scanweektemp_t3","reshist_addr1_scanweektemp_t4","reshist_addr1_scanweektemp_t5","reshist_addr1_scanweektemp_t6","reshist_addr1_svi_eng_20142018","reshist_addr1_walkindex","reshist_addr1_adi_wsum","reshist_addr1_coi_ed_reading","reshist_addr1_leadrisk","reshist_addr1_svi_cap_20142018","reshist_addr1_svi_hs_20142018","reshist_addr1_svi_pov_20142018","reshist_addr1_svi_th3_20142018","reshist_addr1_svi_tot_20142018","reshist_state_so_factor")]

# limit to data we want to impute
temp <- x[,c(3:76,85:93)]

# impute in chunks
set.seed(2023)
temp1 <- missForest(temp[,1:30])$ximp
set.seed(2023)
temp2 <- missForest(temp[,31:60])$ximp
set.seed(2023)
temp3 <- missForest(temp[,61:83])$ximp

# recompile imputed frames
temp <- data.frame(temp1,temp2,temp3)

# reinsert "temp" into data set
x[,c(3:76,85:93)] <- temp

# write out imputed data
# write.csv(x,"geo_data_arielle_imputed.csv",na="",row.names=FALSE)

# read in imputed data
x <- read.csv("geo_data_arielle_imputed.csv")

# winsorize data at upper and lower 1%
x[,3:93] <- scale(winsor(x[,3:93],trim=0.01))

# create composites
addr_poverty <- scale(x$reshist_addr1_coi_se_public+x$reshist_addr1_coi_se_single+x$reshist_addr1_adi_sp+x$reshist_addr1_adi_perc-x$reshist_addr1_coi_c5_coi_nat+x$reshist_addr1_coi_se_povrate+x$reshist_addr1_adi_unemp+x$reshist_addr1_svi_th2_20142018+x$reshist_addr1_adi_in_dis-x$reshist_addr1_coi_r_ed_nat+x$reshist_addr1_adi_ncar-x$reshist_addr1_coi_se_emprat-x$reshist_addr1_coi_se_mhe+x$reshist_addr1_svi_sin_20142018-x$reshist_addr1_coi_se_occ+x$reshist_addr1_svi_dis_20142018+x$reshist_addr1_svi_emp_20142018+x$reshist_addr1_coi_he_vacancy+x$reshist_addr1_coi_he_food-x$reshist_addr1_coi_c5_he_met-x$reshist_addr1_adi_mortg-x$reshist_addr1_coi_r_he_nat+x$reshist_addr1_svi_veh_20142018+x$reshist_addr1_coi_ed_schpov-x$reshist_addr1_adi_rent-x$reshist_addr1_adi_edu_h-x$reshist_addr1_opat_kfrpp_p100+x$reshist_addr1_svi_min_20142018-x$reshist_addr1_coi_se_home)
addr_dense_suburban <- scale(x$reshist_addr1_no2_2016_aavg+x$reshist_addr1_no2_2016_max+x$reshist_addr1_coi_ed_prxece+x$reshist_addr1_coi_he_walk-x$reshist_addr1_urban_area+x$reshist_addr1_coi_he_green-x$reshist_addr1_svi_mob_20142018+x$reshist_addr1_coi_ed_prxhqece+x$reshist_addr1_popdensity+x$reshist_addr1_d1a+x$reshist_addr1_adi_work_c)
addr_crowding_and_crime <- scale(x$reshist_addr1_adi_crowd+x$reshist_addr1_p1tot+x$reshist_addr1_svi_crwd20142018-x$reshist_state_immigrant_factor+x$reshist_addr1_pm25_2016_min-x$reshist_addr1_coi_he_hlthins)
addr_dry_heat <- scale(rowMeans(data.frame(x$reshist_addr1_scanweekvpd_t3,x$reshist_addr1_scanweekvpd_t2,x$reshist_addr1_scanweekvpd_t4,x$reshist_addr1_scanweekvpd_t1,x$reshist_addr1_scanweekvpd_t5,x$reshist_addr1_scanweekvpd_t0,x$reshist_addr1_scanweekvpd_t6,x$reshist_addr1_scanweektemp_t0),na.rm=TRUE))
addr_traditional_south_and_midwest <- scale(x$reshist_state_racism_factor+x$reshist_state_sexism_factor+x$reshist_state_mj_laws+x$reshist_addr1_coi_he_heat+x$reshist_addr1_pm252016aa)
addr_avg_air_pollution <- scale(x$reshist_addr1_coi_he_pm25+x$reshist_addr1_no2-x$reshist_addr1_pm25_2016daysepa+x$reshist_addr1_pm25-x$reshist_addr1_pm25_2016_max)
addr_ozone <- scale(x$reshist_addr1_o3_2016_annavg-x$reshist_addr1_coi_he_ozone+x$reshist_addr1_coi_ed_college+x$reshist_addr1_o3_2016_min+x$reshist_addr1_no2_2016_min-x$reshist_addr1_coi_he_rsei-x$reshist_addr1_elevation)
addr_retirement_and_group_living <- scale(x$reshist_addr1_svi_hous20142018+x$reshist_addr1_svi_th4_20142018+x$reshist_addr1_svi_grp_20142018-x$reshist_addr1_svi_17_20142018)

# add composites to data set
x <- data.frame(x,
addr_poverty,
addr_dense_suburban,
addr_crowding_and_crime,
addr_dry_heat,
addr_traditional_south_and_midwest,
addr_avg_air_pollution,
addr_ozone,
addr_retirement_and_group_living)

# create unique ID and add to data set
uid <- paste0(x$src_subject_id,"_",x$eventname)
x <- data.frame(uid,x)

# write data file
# write.csv(x,"arielle_geo_data_with_scores.csv",na="",row.names=FALSE)

# merge above files together
x1 <- read.csv("arielle_individual_exposome_with_scores.csv")
x2 <- read.csv("arielle_geo_data_with_scores.csv")
x <- merge(x1,x2,by=1,all=TRUE)

# save final data set
# write.csv(x,"Arielle_ABCD_exposome_with_scores.csv",na="")

##################################################################################
# above does data cleaning and initial data reduction; now do some more
# cleaning before writing and sending to Mplus
##################################################################################

# read in data
x <- read.csv("Arielle_ABCD_exposome_with_scores.csv")
x1 <- read.csv("ABCD_site_family.csv")
x <- merge(x,x1,by="src_subject_id",all=TRUE)

# convert timepoint strings to integers and add back to data frame
tp <- x$eventname
tp[tp == "baseline_year_1_arm_1"] <- "1"
tp[tp == "1_year_follow_up_y_arm_1"] <- "2"
tp[tp == "2_year_follow_up_y_arm_1"] <- "3"
x <- data.frame(x,tp)

# generate column of training/testing indicators (e.g. val = 1 indicates 
# testing set) by generating column of random numbers and splitting FAMILIES 
# according to those numbers
x$val <- 0
ids <- unique(x$rel_family_id)
set.seed(2023)
val_designation <- runif(length(ids))
for (i in 1:length(ids)) {
temp <- x[x$rel_family_id == ids[i],]
if (val_designation[i] > 0.5) {temp$val <- 1}
x[x$rel_family_id == ids[i],] <- temp
}

# create SES variable by averaging standardized education and income
parent_ses <- scale(rowMeans(scale(x[,9:10]),na.rm=TRUE))

# make a numeric ID so Mplus doesn't choke
pid <- as.numeric(as.factor(x[,1]))

# add variables to data frame
x <- data.frame(pid,parent_ses,x)

# write data
# write.csv(x,"ABCD_longitudinal_exposome_MPLUS3.csv",na="99999")
