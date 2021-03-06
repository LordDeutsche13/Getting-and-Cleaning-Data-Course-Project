install.packages("reshape2")
install.packages("data.table")

library(plyr)
library(reshape2)
library(data.table)

## Goals
## 1. each variable should be in one column
## 2. each observation of that variable should be in a diferent row
## 3. include ids to link tables together

## Merges the training and the test sets to create one data set.


# Load: activity labels
activity <- read.table("C:/Users/The Dark Knight/Dropbox/Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt")[,2]
activity

# Load: data column names
features <- read.table("C:/Users/The Dark Knight/Dropbox/Getting and Cleaning Data/UCI HAR Dataset/features.txt")[,2]
features

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)
extract_features


# Load and process X_test & y_test data.
X_test       <- read.table("C:/Users/The Dark Knight/Dropbox/Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt")
y_test       <- read.table("C:/Users/The Dark Knight/Dropbox/Getting and Cleaning Data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/The Dark Knight/Dropbox/Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,extract_features]

# Load activity labels
y_test[,2] = activity[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity")
names(subject_test) = "subject"

# Bind data
test_data <- cbind(data.table(subject_test), y_test, X_test)

# Load and process X_train & y_train data.
X_train <- read.table("C:/Users/The Dark Knight/Dropbox/Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/The Dark Knight/Dropbox/Getting and Cleaning Data/UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("C:/Users/The Dark Knight/Dropbox/Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

# Load activity data
y_train[,2] = activity[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity")
names(subject_train) = "subject"

# Bind data
train_data <- cbind(data.table(subject_train), y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity ~ variable, mean)

write.table(tidy_data, file = "C:/Users/The Dark Knight/Dropbox/Getting and Cleaning Data/tidy_data.txt",row.name=FALSE)
