# Peer assessments for Getting and Cleaning Data

library(reshape2)

# Step 0: Read data into R
# Read feature names and activity labels
features <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", colClasses=c("numeric", "character"))

# Read training sets
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=features[, 2])
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names="label")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names="id")
# Read test sets
xTest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=features[, 2])
yTest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names="label")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names="id")

# Step 1: Merges the training and the test sets to create one data set
data <- cbind(rbind(xTrain, xTest), rbind(yTrain, yTest), rbind(subjectTrain, subjectTest))

# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement
pattern <- "(mean)|(std)|(label)|(id)"
extractedData <- data[,grep(pattern, names(data))]

# Step 3: Uses descriptive activity names to name the activities in the data set
extractedData$label <- factor(extractedData$label, labels = activityLabels[, 2])

# Step 4: Appropriately labels the data set with descriptive variable names
names(extractedData) <- gsub(pattern="[()]", replacement="", names(extractedData))
names(extractedData) <- gsub(pattern="\\.+", replacement="_", names(extractedData))
names(extractedData) <- gsub(pattern="_$", replacement="", names(extractedData))

# Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
meltedData <- melt(data=extractedData, id=c("id", "label"))
tidyDataSet <- dcast(data=meltedData, id+label ~ variable, mean)

write.csv(tidyDataSet, file="./tidy_data_set.txt", row.names=FALSE)
