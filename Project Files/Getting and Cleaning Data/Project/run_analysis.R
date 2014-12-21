#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!! NOTE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Please set the working directory to the location where this
# script 'run_analysis.R' resides.
# Here's the command. Replace '...' with the actual location

setwd(...)


# Also, note that the script expects the data to be in the same
# folder as that of the script. Here's the directory structure that
# the code expects the data to be in.
# 'Folder containing run_analysis.R'
#   -> UC_HAR_Dataset (folder)
#      -> activity_labels.txt
#        -> features.txt
#        -> features_info.txt
#        -> test (folder)
#           -> subject_test.txt
#           -> X_test.txt
#           -> y_test.txt
#        -> train (folder)
#           -> X_train.txt
#           -> y_train.txt
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#### TRAINING DATA FRAME ########################################
# Load the training data into a dataframe. ######################
#~ Load the feature data
trainX = read.table("./UCI_HAR_Dataset/train/X_train.txt", header= FALSE, sep="")
#~ Load the subject data
trainSub = read.table("./UCI_HAR_Dataset/train/subject_train.txt", header= FALSE, sep="")
#~ Load the activity data
trainActivity = read.table("./UCI_HAR_Dataset/train/y_train.txt", header= FALSE, sep="")
#~ Finally construct the full training dataset
trainData = cbind(trainX,trainSub,trainActivity)


#### TEST DATA FRAME ############################################
# Load the test/validation data into a dataframe. ###############
#~ Load the feature data
testY = read.table("./UCI_HAR_Dataset/test/X_test.txt", header= FALSE, sep="")
#~ Load the subject data
testSub = read.table("./UCI_HAR_Dataset/test/subject_test.txt", header= FALSE, sep="")
#~ Load the activity data
testActivity = read.table("./UCI_HAR_Dataset/test/y_test.txt", header= FALSE, sep="")
#~ Finally construct the full test dataset
testData = cbind(testY,testSub,testActivity)


#### STEP 1 : MERGE DATA FRAMES #################################
# Merge training and test data table into one dataframe and
# provide the column names
mergedData = rbind(trainData, testData)
variableNames = read.table("./UCI_HAR_Dataset/features.txt", header= FALSE, sep="")
names(mergedData) = variableNames$V2  # Feature column 
names(mergedData)[562] = "Subject"    # Subject column 
names(mergedData)[563] = "Activity"   # Activity column


### STEP 2: EXTRACT REQUIRED VARIABLES/COLUMNS ###############
# From the merged dataset (mergedData), find those indices whose variables represent a 'Mean' or 'Std'. In other words,
# find those variables/columns that either have a 'mean' or 'std' in their names. Using the indices,
# find subset from 'mergedData' where the column number/index matches those indices.
indices = c(grep("std+",variableNames$V2, value=FALSE), grep("mean+",variableNames$V2, value=FALSE))
dataWithStdMean = mergedData[,indices]


### STEP 3: PROVIDE DESCRIPTIVE ACTIVITY NAMES ##################
# For the 'mergedData' dataset (created above), change the values
# in the activity as follows:
# change 1 to 'WALKING'
# change 2 to 'WALKING_UPSTAIRS'
# change 3 to 'WALKING_DOWNSTAIRS'
# change 4 to 'SITTING'
# change 5 to 'STANDING'
# change 6 to 'LAYING'
mergedData$Activity = sub("1+","WALKING", mergedData$Activity)
mergedData$Activity = sub("2+","WALKING_UPSTAIRS", mergedData$Activity)
mergedData$Activity = sub("3+","WALKING_DOWNSTAIRS", mergedData$Activity)
mergedData$Activity = sub("4+","SITTING", mergedData$Activity)
mergedData$Activity = sub("5+","STANDING", mergedData$Activity)
mergedData$Activity = sub("6+","LAYING", mergedData$Activity)



### STEP 4: MODIFY THE COLUMNS NAMES ##################
# For the 'mergedData' dataset (created in Step 3), change the
# existing column names with more user friendly names
#~ Remove all ()
names(mergedData) = gsub(pattern="\\(\\)","", names(mergedData))
#~ Rename all 'mad' to 'medianDeviation'
names(mergedData) = gsub(pattern="mad","medianDeviation", names(mergedData)) 
#~ Rename all 'sma' to 'signalMagtdAread'
names(mergedData) = gsub(pattern="sma","signalMagtdArea", names(mergedData))
names(mergedData)


### STEP 5: MODIFY THE COLUMNS NAMES ##################
# From the 'mergedData' dataset (created in Step 4), create another dataset - 'featureAverageData' that contains
# the average of each feature/column for each combination of activty and subject.
# That is, find the mean of all features from column 1 through 561 in the 'mergedData' dataset. 
# We are excluding column 562 and 563 b/c it contains the grouping factors 'Subject' and 'Activity', respectively.
featureAverageData = aggregate(mergedData[,1:561], by=list(Activity = mergedData$Activity, Subject = mergedData$Subject), FUN=mean, na.rm=TRUE)
featureAverageData


