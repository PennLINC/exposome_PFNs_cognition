# exposome_PFNs_cognition
Code for the project relating exposome factors to PFN topography and cognition in ABCD, led by Arielle Keller.
This pipeline will expect that PFNs have already been generated for each participant using NMF. Details and code to accomplish this are documented at https://github.com/ZaixuCui/pncSingleFuncParcel

# Step 1: Associations between exposome and cognition

## Exposome_PFNs_Cognition.Rmd

This markdown file does data wrangling and analyses to link exposome scores with PFN topography and cognition. Analyses are performed separately in matched discovery and replication samples. This code will also generate the figures and tables for all of these analyses. Sensitivity analyses and stratification analyses are also included here. 


# Step 2: Ridge regression models to predict exposome scores from multivariate patterns of PFN topography
Here we will train and test ridge regression models using PFN topography to predict exposome scores.

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

Note #1: the "submit" scirpts will submit separate jobs for each of the 17 PFNs (to run individual network ridge regressions) and the "submit_all" scripts will run ridge regressions using all the PFNs together (vertex-wise loadings for each PFN are concatenated). Note that these "submit_all" CUBIC jobs need a lot more power than for the independent PFN models so the GB request is higher.

Note #2: If you want to change the output directories for all the results to land in, change the “homedir” variable and “tempdir” variables in the submit script and change the “workingdir” in the proc_predict wrapper script. The homedir is meant to be the outermost folder containing the scripts, results folder, and temporary files folder. The tempdir folder will store intermediate files used during the process (I like to save everything out to check, but they’re considered “temp” because they can be deleted afterward if needed). The workingdir folder is the results directory, which will auto populate with folders for each PFN. Because python likes to 0-index, the folders will be labeled “0_network”… “16_network” and there will be a folder for “all_network” containing the results of submit_all.py. 

Note #3: Covariates for age, sex, head motion, and ABCD site are regressed out of all models

All six versions of the ridge regressions will train on one sub-sample of the ABCD data (also referred to as the “Discovery” sub-sample) and test on the other (also referred to as the “Replication” sub-sample), and vice versa. 

## 2.2 Notes specific to each version of the ridge regression

### **PFNs-ExpFactor**
Here we use the multivariate pattern of PFN topography to predict exp-factor

First, use **get_data_for_ridge_expfactor.R** to prepare the data. Then, use **submit_all_expfactor.py** and **submit_expfactor.py** to submit CUBIC jobs to run the ridge regressions. These scripts will call the wrapper **expfactor_proc_predict.py** which will call **preprocess_expfactor.py** and **predict_matchedsamples.py**

