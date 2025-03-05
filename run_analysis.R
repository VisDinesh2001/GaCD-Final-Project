## Load required packages

library(dplyr)

## Create a directory to store the data
if(!file.exists("./originaldataset")){
  dir.create("./originaldataset")
}

## Download dataset to local storage
## Extra code to stop download and unzipping on every source if files exist.
if(!file.exists("./originaldataset/projectdata.zip")){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, destfile = "./originaldataset/projectdata.zip")
  
  ## Unzip the data
  unzip(zipfile = "./originaldataset/projectdata.zip", exdir = "./originaldataset")
}

## Read files into R
  ## Training Datasets
  x_train <- read.table("./originaldataset/UCI HAR Dataset/train/X_train.txt")
  y_train <- read.table("./originaldataset/UCI HAR Dataset/train/y_train.txt")
  subject_train <- read.table("./originaldataset/UCI HAR Dataset/train/subject_train.txt")
  ## Testing Datasets
  x_test <- read.table("./originaldataset/UCI HAR Dataset/test/X_test.txt")
  y_test <- read.table("./originaldataset/UCI HAR Dataset/test/y_test.txt")
  subject_test <- read.table("./originaldataset/UCI HAR Dataset/test/subject_test.txt")
  ## Labels and Features
  activity_labels <- read.table("./originaldataset/UCI HAR Dataset/activity_labels.txt")
  features <- read.table("./originaldataset/UCI HAR Dataset/features.txt")
  
## Label variables
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"
colnames(x_train) <- features[, 2] ## Retrieves the measurement names from features

colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"
colnames(x_test) <- features[, 2]

## Combine data sets, then merge
train_all <- cbind(y_train, subject_train, x_train)
test_all <- cbind(y_test, subject_test, x_test)

complete_data <- rbind(train_all, test_all)

## Extract measurements of mean and SD for data
  ## Subset columns of complete_data for mean and SD values
  mean_SD <- grepl("activityID|subjectID|mean\\(\\)|std\\(\\)", colnames(complete_data))
  data_extracted <- complete_data[, mean_SD]
  
## Replace activityID with descriptive labels
  data_extracted$activityID <- activity_labels[data_extracted$activityID, 2]
  names(data_extracted)[1] <- "Activity"
  
## Label Data set with descriptive variable names
  colnames(data_extracted) <- gsub("^t", "Time", colnames(data_extracted))
  colnames(data_extracted) <- gsub("^f", "Frequency", colnames(data_extracted))
  colnames(data_extracted) <- gsub("Acc", "Accelerometer", colnames(data_extracted))
  colnames(data_extracted) <- gsub("Gyro", "Gyroscope", colnames(data_extracted))
  colnames(data_extracted) <- gsub("Mag", "Magnitude", colnames(data_extracted))
  colnames(data_extracted) <- gsub("BodyBody", "Body", colnames(data_extracted))
  
## Creating a separate data table containing averages by subject and activity
  grouped_data <- group_by(data_extracted, subjectID, Activity)
  final_data <- summarize_all(grouped_data, mean)
  write.table(final_data, "final_data.txt", row.names = FALSE)