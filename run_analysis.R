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