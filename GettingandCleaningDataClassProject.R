#Getting and Cleaning Data Project


#Step 1
#Load text files to data frames
testdata_x = read.table("\\\\SPLCLS001PVFS/userdata$/chris.peterson/CCC_Coursera/Data Science_Course 3_Getting Data/Data Sets/Project/test/X_test.txt")
testdata_y = read.table("\\\\SPLCLS001PVFS/userdata$/chris.peterson/CCC_Coursera/Data Science_Course 3_Getting Data/Data Sets/Project/test/Y_test.txt")
traindata_x = read.table("\\\\SPLCLS001PVFS/userdata$/chris.peterson/CCC_Coursera/Data Science_Course 3_Getting Data/Data Sets/Project/train/X_train.txt")
traindata_y = read.table("\\\\SPLCLS001PVFS/userdata$/chris.peterson/CCC_Coursera/Data Science_Course 3_Getting Data/Data Sets/Project/train/Y_train.txt")
labels = read.table("\\\\SPLCLS001PVFS/userdata$/chris.peterson/CCC_Coursera/Data Science_Course 3_Getting Data/Data Sets/Project/activity_labels.txt")
features = read.table("\\\\SPLCLS001PVFS/userdata$/chris.peterson/CCC_Coursera/Data Science_Course 3_Getting Data/Data Sets/Project/features.txt")

#Step 2
#Merge Labels and features with Test Data, label subject, and combine data sets
cols <- features[['V2']]
colnames(testdata_x) <- cols
testdata_x$subject <- c("test")
testdata_y <- merge(testdata_y, labels, by.x="V1", by.y = "V1")
colnames(testdata_y) <- c("observationId", "activity")
testdata_x <- cbind(testdata_x, testdata_y)

colnames(traindata_x) <- cols
traindata_x$subject <- c("train")
traindata_y <- merge(traindata_y, labels, by.x="V1", by.y = "V1")
colnames(traindata_y) <- c("observationId", "activity")
traindata_x <- cbind(traindata_x, traindata_y)

alldata <- rbind(testdata_x, traindata_x)

#Drop old data sets
rm(cols)
rm(features)
rm(labels)
rm(testdata_x)
rm(testdata_y)
rm(traindata_x)
rm(traindata_y)

#Step 3
#subset data for mean and st dev fields
#subject, activity, means, st devs
alldatamean <- alldata[ , grepl( "mean()", names( alldata) ) ]
alldatastd <- alldata[ , grepl( "std()", names( alldata) ) ]
alldataother <- subset(alldata, select = c("subject", "activity"))

alldatasubset <- cbind(alldataother, alldatamean, alldatastd)

#drop old data sets
rm(alldatamean)
rm(alldatastd)
rm(alldataother)
rm(alldataset)

#Step 4
#Store field averages in new table
avgdata <- aggregate( alldatasubset[ ,3:81], list(alldatasubset$subject, alldatasubset$activity), mean)
names(avgdata)[names(avgdata)=="Group.1"] <- "subject"
names(avgdata)[names(avgdata)=="Group.2"] <- "activity"

#Step 5 - optional
#Export CSV for review
write.csv(avgdata, file = "\\\\SPLCLS001PVFS/userdata$/chris.peterson/CCC_Coursera/Data Science_Course 3_Getting Data/Data Sets/Project/finaldataset.csv")
