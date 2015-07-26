

## read
## read subject from test & train
subject_test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
names(subject_test) <- "subject"
subject_train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
names(subject_train) <- "subject"

## read y(activity) from test & train
y_test <-read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
names(y_test) <- "activity"
y_train <-read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
names(y_train) <- "activity"

## read x(features readings) from test & train
x_test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")

## read the features descriptions
features_desc <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
features_desc[,2] <- as.character(features_desc[,2])

## read the activity descriptions
activity_label <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
names(activity_label) = c("activity","activity_desc")



## combine the subject, y & x into a data table 
## both test & train
library(data.table)
dt_test <- data.table(subject_test, y_test, x_test)
dt_train <- data.table(subject_train, y_train, x_train)



## append both test & train into a single data table
## rename the variable names for y using the features_desc
dt <- rbind(dt_test, dt_train)
names(dt)[3:563] <- features_desc[,2]



## only extract the column for mean() & std()
## appropriate variable names for features_desc
## rename the activity with its activity descriptions
dt2 <- dt[,grep("subject|activity|mean\\(\\)|std\\(\\)",names(dt)),with=F]
names(dt2)<- gsub("\\(|\\)","",names(dt2))
dt2$activity <- activity_label[dt2$activity,2]


## tidy data set with the average of each variable 
## for each activity and each subject
## rename the group1 & group2 to understandable name(subject & activity)
tidyDataSet <- aggregate(dt2[,3:68,with=F],list(dt2$subject,dt2$activity), mean)
names(tidyDataSet)[1:2] <- c("subject","activity")


## write the data for course upload
write.table(tidyDataSet,file="tidyDataSet_course3assignment.txt",row.names=F)

