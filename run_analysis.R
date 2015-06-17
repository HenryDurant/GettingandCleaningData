## GETTING AND CLEANING DATA
## ASSIGNMENT

## INSTRUCTIONS

## You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each  ##    variable for each activity and each subject.

## SET WORKING DIRECTORY

setwd("C:/Users/Henry/Documents/Rworkingdirectory/Getting and Cleaning Data/Project")

## LOAD PACKAGES

library(dplyr)
library(plyr)

## DOWNLOAD DATA 
##Download ZIP manually, then place in project WD

features <- read.table("features.txt", colClasses = c("character"))
activityLabels <- read.table("activity_labels.txt", col.names = c("ActivityId", "Activity"))
xTrain <- read.table("./train/X_train.txt")
yTrain <- read.table("./train/Y_train.txt")
subjectTrain <- read.table("./train/subject_train.txt")
xTest <- read.table("./test/X_test.txt")
yTest <- read.table("./test/Y_test.txt")
subjectTest <- read.table("./test/subject_test.txt")

## MERGE DATA

trainData <- cbind(xTrain, subjectTrain, yTrain)
testData <- cbind(xTest, subjectTest, yTest)
mergeData <- rbind(trainData, testData)

## Append LABELS

sensorLabels <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(mergeData) <- sensorLabels

## EXTRACT SD AND MEAN DATA

mergeDataMeanSD <- mergeData[,grepl("mean|std|Subject|ActivityId", names(mergeData))]

##Name Activities

mergeDataMeanSD <- inner_join(mergeDataMeanSD, activityLabels, by = "ActivityId", match = "first")
mergeDataMeanSD <- mergeDataMeanSD[,-1]

##Tidy Labels
names(mergeDataMeanSD) <- gsub('\\(|\\)',"",names(mergeDataMeanSD), perl = TRUE)
names(mergeDataMeanSD) <- gsub('tBody',"Body",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('fBody',"Body",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('tGravity',"Gravity",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('Acc',".Acceleration",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('std',".StandardDeviation",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('mean',".Mean",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('-',"",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('Jerk',".Jerk",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('Gyro',".Gyration",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('Freq',".Frequency",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('Mag',".Magnitude",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('X',".X-Axis",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('Y',".Y-Axis",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('Z',".Z-Axis",names(mergeDataMeanSD))
names(mergeDataMeanSD) <- gsub('BodyBody.',"",names(mergeDataMeanSD))


##Creat dataset of Mean for each variable of each Activity for Each Subject
TidyMeanData <- ddply(mergeDataMeanSD, c("Subject", "Activity"), numcolwise(mean))

write.table(TidyMeanData, file = "TidyMeanData.txt", row.name = FALSE)


