# exposome_PFNs_cognition
Code for the project relating exposome factors to PFN topography and cognition in ABCD, led by Arielle Keller.
This pipeline will expect that PFNs have already been generated for each participant using NMF. Details and code to accomplish this are documented at https://github.com/ZaixuCui/pncSingleFuncParcel

# Step 1: Associations between exposome and cognition

## Exposome_PFNs_Cognition.Rmd

This markdown file...

## Expsome_PFNs_Cognition_Longitudinal.Rmd

This markdown file... 


# Step 2: Ridge regression models to predict exposome scores from multivariate patterns of PFN topography
Here we will train and test ridge regression models using PFN topography to predict exposome scores.


### 2.1	General Workflow and Notes

This is the general format for running ridge regressions using PFN topography:

- Use a "get_data_for_ridge" script to prepare a csv file of the data to be used in the ridge regression
- Use a "submit" script to submit CUBIC jobs that will run the ridge regressions
- This will call a wrapper script ("proc_predict") that will call two scripts:
      - a preprocessing script ("preprocess")
      - a predictive modeling script ("predict")

Note #1: the "submit" scirpts will submit separate jobs for each of the 17 PFNs (to run individual network ridge regressions) and the "submit_all" scripts will run ridge regressions using all the PFNs together (vertex-wise loadings for each PFN are concatenated). Note that these "submit_all" CUBIC jobs need a lot more power than for the independent PFN models so the GB request is higher.

Note #2: If you want to change the output directories for all the results to land in, change the “homedir” variable and “tempdir” variables in the submit script and change the “workingdir” in the proc_predict wrapper script. The homedir is meant to be the outermost folder containing the scripts, results folder, and temporary files folder. The tempdir folder will store intermediate files used during the process (I like to save everything out to check, but they’re considered “temp” because they can be deleted afterward if needed). The workingdir folder is the results directory, which will auto populate with folders for each PFN. Because python likes to 0-index, the folders will be labeled “0_network”… “16_network” and there will be a folder for “all_network” containing the results of submit_all.py. 

Note #3: Covariates for age, sex, head motion, and ABCD site are regressed out of all models


### 2.3    Using the multivariate pattern of PFN topography to predict exp-factor

This version of the ridge regressions will train on one sub-sample of the ABCD data (also referred to as the “Discovery” sub-sample) and test on the other (also referred to as the “Replication” sub-sample), and vice versa. 

get_data_for_ridge_expfactor.R

