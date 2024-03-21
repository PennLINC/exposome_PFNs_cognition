# exposome_PFNs_cognition
Code for the project relating exposome factors to PFN topography and cognition in ABCD, led by Arielle Keller.
This pipeline will expect that PFNs have already been generated for each participant using NMF. Details and code to accomplish this are documented at https://github.com/ZaixuCui/pncSingleFuncParcel

# Step 0: Calculate the exposome
R code **ABCD_exposome_script.R** is used to prepare data for Mplus. Longitudinal bifactor analysis is then applied to this data using Mplus. Mplus output for the exposome scores calculated in our paper is provided in **longitudinal_abcd_exposome_esem_full_sample_7f_2april2023.out**.


# Step 1: Associations between exposome and cognition

## Exposome_PFNs_Cognition.Rmd

This markdown file does data wrangling and analyses to link exposome scores with PFN topography and cognition. Analyses are performed separately in matched discovery and replication samples. This code will also generate the figures and tables for all of these analyses. Sensitivity analyses and stratification analyses are also included here. 


# Step 2: Ridge regression models to predict exposome scores from multivariate patterns of PFN topography
Here we will train and test ridge regression models using multivariate patterns of PFN topography. We use the same core coding framework and approach to run many different versions of these ridge regressions, summarized below:

There are 6 "versions" of ridge regression to be run, each with a different purpose but the same exact coding framework (described in 2.1):
1. **PFNs-ExpFactor**: Use PFN topography to predict Exp-Factor (all at baseline T0 assessment)
2. **PFNs-ExpFactor_SeparateSamples**: Use PFN topography to predict Exp-Factor, where Exp-Factor is defined separately in each of the two samples (Discovery and Replication) -- this is a sensitivity analysis to make sure that there's no significant leakage across samples
3. **ExpFactor-Cognition**: Use the Exposome Factor ("Exp-Factor") to predict cognition (all at baseline T0 assessment)
4. **ExpFactorPFNs-Cognition**: Use the Exposome Factor ("Exp-Factor") plus the multivariate pattern of personalized functional network ("PFN") topography to predict cognition (all at baseline T0 assessment)
5. **ExpFactorPFNs-T2CogPred**: Use the Exp-Factor and PFN topography to predict cognition at time 2 ("T2") while controlling for baseline cognitive performance
6. **PFNs-CogRegExp**: Use PFN topography to predict a pseudo-variable of cognition with Exposome Factor regressed out (all at baseline T0 assessment)



## 2.1	General Workflow and Notes

This is the general format for running ridge regressions using PFN topography:

- Use a "get_data_for_ridge" script to prepare a csv file of the data to be used in the ridge regression
- Use a "submit" script to submit CUBIC jobs that will run the ridge regressions
- This will call a wrapper script ("proc_predict") that will call two scripts:
  - a preprocessing script ("preprocess")
  - a predictive modeling script ("predict")

The "submit" scirpts will submit separate jobs for each of the 17 PFNs (to run individual network ridge regressions) and the "submit_all" scripts will run ridge regressions using all the PFNs together (vertex-wise loadings for each PFN are concatenated). Note that these "submit_all" CUBIC jobs need a lot more power than for the independent PFN models so the GB request is higher.

If you want to change the output directories for all the results to land in, change the “homedir” variable and “tempdir” variables in the submit script and change the “workingdir” in the proc_predict wrapper script. The homedir is meant to be the outermost folder containing the scripts, results folder, and temporary files folder. The tempdir folder will store intermediate files used during the process (I like to save everything out to check, but they’re considered “temp” because they can be deleted afterward if needed). The workingdir folder is the results directory, which will auto populate with folders for each PFN. Because python likes to 0-index, the folders will be labeled “0_network”… “16_network” and there will be a folder for “all_network” containing the results of submit_all.py. 

Note that covariates for age, sex, head motion, and ABCD site are regressed out of all models. All versions of the ridge regressions will train on one sub-sample of the ABCD data (also referred to as the “Discovery” sub-sample) and test on the other (also referred to as the “Replication” sub-sample), and vice versa. 

The first step (getting the data prepared for the ridge regression) is easiest to run locally in RStudio, since the goal is simply to re-organize and pare down some very lightweight data files. The steps of the ridge regression from submit --> proc_predict --> preprocess --> predict are all meant to be run on CUBIC as submitted jobs. After running the ridge regressions, I copy the results files back to my local machine to run the lightweight stats/plotting scripts using the Matlab GUI. 


## 2.2 Notes specific to each version of the ridge regression

### 1) **PFNs-ExpFactor**
Here we use the multivariate pattern of PFN topography to predict exp-factor

First, use **get_data_for_ridge_expfactor.R** to prepare the data. Then, use **submit_all_expfactor.py** and **submit_expfactor.py** to submit CUBIC jobs to run the ridge regressions. The first submit file "all" trains the ridge model on all 17 PFNs together, while the second submit file without the word "all" submits 17 separate jobs each with a model trained on one PFN at a time. These scripts will call the wrapper **expfactor_proc_predict.py** which will call **preprocess_expfactor.py** and **predict_matchedsamples.py**. For stats and plotting of the results, use **compare_predicted_actual_expfactor.m**. 

We also have 3 other sub-versions of this ridge model that we won't need to run for the other versions. The first is a "null" model in which we scramble the outcome variable (here, Exp-Factor) that we're predicting. The accuracy of this model (which should be very low!) tells us how well we can predict a nonsense outcome variable that we know should be unrelated to the features we train on (in this case, PFNs). The second is a "boostrap" model, in which we make sure that our choice of split across Discovery and Replication samples isn't biased. To do so, we perform a hundred iterations of the ridge regression where each time we take a new random split of the data into two groups for train/test and then do our usual two-fold cross-validation. The output here is a distribution of 100 accuracy values that give us a range of what we should expect -- if our true accuracy value from the Discovery and Replication split falls within this range, then we know it's a reasonable choice of split. The third sub-version is called "bootstrap_null", which as you can imagine is the null model (scrambled outcome variable) for these bootstrap splits (100 random re-samples). Keep in mind that the jobs on CUBIC that do bootstrapping will take quite a bit longer to run (for me it's usually about 40 hours) than the jobs without bootstrapping.

To plot prediction accuracy by PFN for the individual network models (in both a bar graph and a brainmap), use **pred_acc_by_PFN_exposome.m** and **pred_acc_by_PFN_exposome_workbench.R**.

### 2) **PFNs-ExpFactor_SeparateSamples**
This is the same as (1) PFNs-ExpFactor except that the Exp-Factor outcome variable is defined separately in the Discovery and Replication samples. The purpose of this analysis is to make sure that there isn't any substantial leakage across our training and testing samples by the fact that the exposome is typically defined in the whole combined sample. 

First, use **get_data_for_ridge_expfactor_separatesamples.R** to prepare the data. Then, use **submit_all_expfactor_SepSamp.py** to submit a CUBIC job to run the ridge regression. This script will call the wrapper **expfactor_SepSamp_proc_predict.py** which will call **preprocess_expfactor_sepsamp.py** and **predict_matchedsamples.py**. For stats and plotting of the results, use **compare_predicted_actual_expfactor_separatesamples.m**. 

### 3) **ExpFactor-Cognition**
This analysis will use just the single-variable exposome factor (Exp-Factor) to predict cognition across three cognitive domains (General Cognition, Executive Function, and Learning/Memory). 

First, use **get_ExpFactor_features.R** to prepare the data. Then, use **submit_all_ExpFactor.py** to submit CUBIC jobs to run the ridge regressions. This script will call the wrapper **keller_proc_predict_ExpFactor.py** which will call **preprocess_ExpFactor.py** and **predict_matchedsamples_ExpFactor.py**. 

### 4) **ExpFactorPFNs-Cognition**
This analysis will use both the single-variable exposome factor (Exp-Factor) and the multivariate pattern of PFN topography to predict cognition across three cognitive domains (General Cognition, Executive Function, and Learning/Memory). 

No need to prepare the data, we've got everything we need already! Use **submit_all_ExpFactor_PFNs.py** to submit CUBIC jobs to run the ridge regressions. This script will call the wrapper **keller_proc_predict_ExpFactor_PFNs.py** which will call **preprocess_ExpFactor_PFNs.py** and **predict_matchedsamples_ExpFactor_PFNs.py**. 

For stats and plotting for both (3) and (4), our goal is to compare the models to one another using a few different metrics (r, AIC, BIC). The script to use is **compare_predicted_actual_PFNvsExp_Cognition.m**. Note that the results for the PFNs-only model at baseline is drawn from our previous work (see keller_networks Github repo).


### 5) **ExpFactorPFNs-T2CogPred**

This analysis will use both the single-variable exposome factor and the multivariate pattern of PFN topography to predict cognition  at time 2 ("T2") while controlling for baseline cognitive performance. Because we're predicting longitudinal cognition here, we will use 5 individual cognitive tasks that were collected at both baseline (T0) and two-year (T2) timepoints. The 5 tasks as as follows, with parentheses for the abbreviated nicknames used in the code: Picture Vocabulary (PicVocab), Flanker, Picture Sequence Memory (Picture), Pattern Completion (Pattern), and Reading Recognition (Reading).

This analysis actually contains 3 separate ridge regression models: Model 1 uses only the single-variable Exp-Factor, Model 2 uses just the PFN topography, and Model 3 uses Exp-Factor plus PFN topography. This mirrors the analysis we've already conducted at baseline to predict the three cognitive domains. 

First, use **get_T2CogPred_features.R** to prepare the data. Then, use each of the three submit_all files to submit the three different Models described above: **submit_all_T2CogPred_ExpFactor.py**, **submit_all_T2CogPred_PFNs.py**, and **submit_all_T2CogPred_ExpFactorPFNs.py**. These scripts will call the following wrapper scripts accordingly: **T2CogPred_proc_predict_ExpFactor.py**, **T2CogPred_proc_predict_PFNs.py**, and **T2CogPred_proc_predict_ExpFactorPFNs.py**.

Importantly, because we're predicting cognition longitudinally here, we need to account for baseline cognitive performance as a covariate in each of our models. This means we need a separate preprocess script for each version that will covary for the appropriate task. Because we have 5 cognitive tasks and 3 models, this means there are 15 separate preprocess scripts in this folder (I won't name them all here, but the naming scheme e.g. **T2CogPred_preprocess_ExpFactor_PicVocab.py** makes it clear which one is which). The predict files don't change here, so they're all the same as described above. 

### 6) **PFNs-CogRegExp** 
Use PFN topography to predict a pseudo-variable of cognition with Exposome Factor regressed out (all at baseline T0 assessment)

No need to prepare the data, we've got everything we need already! Use **submit_all_CogRegExp.py** to submit CUBIC jobs to run the ridge regressions. This script will call the wrapper **CogRegExp_proc_predict.py** which will call **preprocess_CogRegExp.py** and **predict_matchedsamples.py**. Stats and plotting are done with **compare_predicted_actual_CogRegExp.m**.

