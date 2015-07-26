if (!("reshape2" %in% rownames(installed.packages())) ) {
  install.packages("reshape2") 
  }
# loading library
library(reshape2)

# Creating activity names
activities <- read.table("./activity_labels.txt",col.names=c("activity_id","activity_name"))

# Creating feature labels
features <- read.table("./features.txt",col.names=c("feature_id","feature_name"))
feature_label <- features[,2]

#1 Merges the training and the test sets to create one data set.
#TEST: Reading the test data and labeling the variable columns
test_data <- read.table("./test/X_test.txt")
colnames(test_data) <- feature_label

#TRAIN: Reading the training data and labeling the variable columns
train_data <- read.table("./train/X_train.txt")
colnames(train_data) <- feature_label


#TEST: Reading test subject id and label coulmn 
test_subject_id <- read.table("./test/subject_test.txt")
colnames(test_subject_id) <- "subject_id"

#TEST: Reading activity id of subject and label coulmn 
test_activity_id <- read.table("./test/y_test.txt")
colnames(test_activity_id) <- "activity_id"


#TRAIN: Reading train subjects id and label coulmn 
train_subject_id <- read.table("./train/subject_train.txt")
colnames(train_subject_id) <- "subject_id"

#TRAIN: Reading activity id of subject and label coulmn 
train_activity_id <- read.table("./train/y_train.txt")
colnames(train_activity_id) <- "activity_id"

#TEST: Combines test data with subject and activity
test_data_full <- cbind(test_subject_id , test_activity_id , test_data)

#TRAIN: Combines train data with subject and activity
train_data_full <- cbind(train_subject_id , train_activity_id , train_data)

#ALL: Combines test and train data sets
complete_data <- rbind(test_data_full,train_data_full)

#2 Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_index <- grep("mean", names(complete_data), ignore.case=TRUE)
mean_label <- names(complete_data)[mean_index]
std_index <- grep("std", names(complete_data), ignore.case=TRUE)
std_label <- names(complete_data)[std_index]
reduced_data <-complete_data[,c("subject_id","activity_id",mean_label,std_label)]

#3 Uses descriptive activity names to name the activities in the data set.
descriptive <- merge(activities,reduced_data,by.x="activity_id",by.y="activity_id",all=TRUE)

#4 Appropriately labels the data set with descriptive variable names. 
# Already done as part of generating the individual test and train data

#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable
# for each activity and each subject.
# 
data_melt <- melt(descriptive,id=c("activity_id","activity_name","subject_id"))

# 
mean_data <- dcast(data_melt,activity_id + activity_name + subject_id ~ variable,mean)

# Writing tidy data as text file
write.table(mean_data,"./tidy_data.txt", row.name=FALSE)