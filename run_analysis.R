#setting working directory

setwd("C:/Users/Medicine/Desktop/Data cleaning")

library(dplyr)

filename <- "Smartphonedat.zip"

# Checking if filename already exists.
if (!file.exists(filename)){
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filename, mode = "wb")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}

list.files("UCI HAR Dataset")

##Making the Test and Training Set Data

#Reading the training data

subjectrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)

ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Reading the test data

subjectest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)

ytest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

#Reading features data

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))

#Reading activity labels data

activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

##1. Merging the training and the test sets to create one data set
Xtotal <- rbind(xtrain, xtest)
Ytotal <- rbind(ytrain, ytest)
Subtotal <- rbind(subjectrain, subjectest)
Mergedata<-cbind(Subtotal,Ytotal,Xtotal)

#2. Extracting the measurements on the mean and standard deviation for each measurement
Tidydata<-Mergedata %>% select(subject, code, contains("mean"), contains("std"))


#3. Using descriptive activity names to name the activities in the data set

Activitylabel<- activities[Tidydata$code, 2]

#4. Appropriately labels the data set with descriptive variable names

names(Tidydata)[2]="activity"

names(Tidydata)<-gsub("Acc", "Accelerometer", names(Tidydata))

names(Tidydata)<-gsub("Gyro", "Gyroscope", names(Tidydata))

names(Tidydata)<-gsub("BodyBody", "Body", names(Tidydata))

names(Tidydata)<-gsub("Mag", "Magnitude", names(Tidydata))

names(Tidydata)<-gsub("^t", "Time", names(Tidydata))

names(Tidydata)<-gsub("^f", "Frequency", names(Tidydata))

names(Tidydata)<-gsub("tBody", "TimeBody", names(Tidydata))

names(Tidydata)<-gsub("-mean()", "Mean", names(Tidydata), ignore.case = TRUE)

names(Tidydata)<-gsub("-std()", "STD", names(Tidydata), ignore.case = TRUE)

names(Tidydata)<-gsub("-freq()", "Frequency", names(Tidydata), ignore.case = TRUE)

names(Tidydata)<-gsub("angle", "Angle", names(Tidydata))

names(Tidydata)<-gsub("gravity", "Gravity", names(Tidydata))

#5. Creates a second, independent tidy data set from step 4 with the average of each variable for each activity and each subject

Finaldat <- Tidydata %>%
            group_by(subject, activity) %>%
            summarise_all(funs(mean))
write.table(Finaldat, "Tidydata.txt", row.name=FALSE)


str(Finaldat)

