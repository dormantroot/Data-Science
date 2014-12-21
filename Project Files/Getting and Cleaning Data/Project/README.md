##Getting and Cleaning Data Project
===================
### Contents
- README.md
- run_analysis.R (R file containing the script)
- UCI_HAR_Dataset (Folder containing the necessary dataset)
- Project_Instructions.html (The code book that describes exactly what the run_analysis.R script performs)
- Project_Instructions.md/Rmd (mark down files)

This folder contains the R script - 'run_analysis.R'. The entire R code pertaining to this project is in this script.  Before running the script, please set the working directory to the location where this script 'run_analysis.R' resides. Here's the command 'setwd(...)'. Replace '...' with the actual location.

Also, note that the script expects the data to be in the same folder as that of the script. Here's the directory structure that the code expects the data to be in.
->'Folder containing run_analysis.R'
   -> UC_HAR_Dataset (folder)
      -> activity_labels.txt
        -> features.txt
        -> features_info.txt
        -> test (folder)
           -> subject_test.txt
           -> X_test.txt
           -> y_test.txt
        -> train (folder)
           -> X_train.txt
           -> y_train.txt
		   
The required dataset is in this Github folder. However, if for some reason you can't download it from Github, here's the link (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ) to an alternate source to download the zip file containing the entire dataset.

