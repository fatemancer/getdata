##
run_analysis <- function()
  
{
if (grep("UCI HAR Dataset", getwd(), fixed=T)==FALSE) {
    setwd("./UCI HAR Dataset/") } else

# reading time for TRAIN set. 
# read.fwf() takes quite a time, though I couldn't apply other functions here. 
# buffersize is to allow this to be runnable on 8GB of RAM
X_train <- read.fwf("./train/X_train.txt", widths=rep(16,561), buffersize=50)
y_train <- read.fwf("./train/y_train.txt",1)
subject_train <- read.fwf("./train/subject_train.txt",10)

# reading time for TEST set
# read.fwf() takes quite a time, though I couldn't apply other functions here. 
# buffersize is to allow this to be runnable on 8GB of RAM
X_test <- read.fwf("./test/X_test.txt", widths=rep(16,561), buffersize=50)
y_test <- read.fwf("./test/y_test.txt",1)
subject_test <- read.fwf("./test/subject_test.txt",10)

# adding columns and renaming
features <- read.csv("features.txt",sep=" ", header=F)
X_test <- cbind(X_test, "TEST", subject_test, y_test)
X_train <- cbind(X_train, "TRAIN", subject_train, y_train)
names(X_test) <- c(as.character(features$V2), "Set", "Subject", "Activity")
names(X_train) <- c(as.character(features$V2), "Set", "Subject", "Activity")

# HAR creation
HAR <- rbind(X_test,X_train)

# HAR is a merged dataset that contains all the data we need. 
# Now we have to trim it, choosing only "means" and "standart deviations". 
# we use fixed=TRUE to ensure we choose only true means, not MeanFreqs or similiar
# Also we add 2 last columns, about Subject and Activity type

mean_columns <- grep("mean()", names(X_test), fixed=T) 
std_columns <- grep("std()", names(X_test))
sHAR <- HAR[c(563, 564, std_columns, mean_columns)]

# setting human-readable names for Activity
labs <- read.fwf("activity_labels.txt",c(1,50))
sHAR$Activity <- factor(sHAR$Activity, 1:6, labs$V2)

# now let us melt the data and reshape it
# we choose Subject and Activity as ids, and all columns from 3rd to 68th as measurements
mHAR <- melt(sHAR, id.vars=c("Subject","Activity"), measure.vars=names(sHAR)[3:68])

# and use dcast afterwards, that gives us the average 
# of each variable for each activity and each subject.
result <- dcast(mHAR, Subject + Activity ~ variable,mean)
write.table(result, "tidy.csv", row.names=F)
}