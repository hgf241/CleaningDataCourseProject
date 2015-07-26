library(dplyr)
library(reshape2)

# reading the common files
activities <- read.table("activity_labels.txt", col.names=c("Activity","ActivityName"))
featurelist <- read.table("features.txt", stringsAsFactor=TRUE,col.names=c("Feature","FeatureName"))

# creating the common column names
cols <- c("Subject", "Source", "Activity")

# reading the train data
x_train <- read.table("train\\x_train.txt", col.names=featurelist$FeatureName)
y_train <- read.table("train\\y_train.txt", col.names=c("Activity"))
subject_train <- read.table("train\\subject_train.txt", col.names=c("Subject"))

# reading the test data
x_test <- read.table("test\\x_test.txt", col.names=featurelist$FeatureName)
y_test <- read.table("test\\y_test.txt", col.names=c("Activity"))
subject_test <- read.table("test\\subject_test.txt", col.names=c("Subject"))

# filter the std and mean columns
xtrain <- select(x_train, contains(".std."), contains(".mean."))
xtest <- select(x_test, contains(".std."), contains(".mean."))

# combine the y-values and activities
ym_train <- merge(y_train, activities, sort=FALSE)
ym_test <- merge(y_test, activities, sort=FALSE)

# combine the subject, source and activities to a table
train <- cbind(subject_train, "Train", ym_train)
test <- cbind(subject_test, "Test", ym_test)

# the activity ID isn't needed
train <- select(train, 1,2,4)
test <- select(test, 1,2,4)

# rename the column for the source
colnames(train) <- cols
colnames(test) <- cols

testdata <- cbind(test, xtest)
traindata <- cbind(train, xtrain)

# combine both datasets
x_all <- rbind(traindata, testdata)

# summarize the dataset
data <- melt(x_all, varnames= cols,id=1:3)
data <- dcast(data, Subject + Activity ~ variable, mean, na.rm = TRUE)

# write the data to the disk
write.table(data, file="tidy_data.txt", row.name=FALSE)

