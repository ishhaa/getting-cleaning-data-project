source("./utility.R") 

current.wd <- get.filepath()
folder.dataset <- file.path(current.wd, "dataset", "UCI HAR Dataset")
folder.train <- file.path(folder.dataset, "train")
folder.test <- file.path(folder.dataset, "test")

message("Performing Step 1: Merging Datasets")

xTrain <- read.table(file.path(folder.train, "X_train.txt"))
xTest <- read.table(file.path(folder.test, "X_test.txt"))
X <- rbind(xTrain, xTest)

subTrain <- read.table(file.path(folder.train, "subject_train.txt"))
subTest <- read.table(file.path(folder.test, "subject_test.txt"))
subjects <- rbind(subTrain, subTest)

yTrain <- read.table(file.path(folder.train, "y_train.txt"))
yTest <- read.table(file.path(folder.test, "y_test.txt"))
y <- rbind(yTrain, yTest)

message("Performing Step 2: Get Mean and Std of Measurements")

features <- read.table(file.path(folder.dataset, "features.txt"))

features.selected <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, features.selected] 
names(X) <- features[features.selected, 2]
names(X) <- gsub("\\(|\\)", "", names(X)) 
names(X) <- gsub("\\-", " ", names(X)) 

message("Performing Step 3: Rename activities in the dataset")

activities <- read.table(file.path(folder.dataset, "activity_labels.txt"))

y[,1] <- activities[y[,1], 2]
names(y) <- "activity" 
 ---------------------------------------------------------------------

message("Performing Step 4: Re-label the dataset w/ descriptive names")

names(subjects) <- "subject"
data.cleaned <- cbind(subjects, y, X)
write.table(data.cleaned, 
            file.path(current.wd, "merged_and_cleaned_dataset.txt"))

message("merged_and_cleaned_dataset.txt file created!")

message("Performing Step 5: Create the Tidy dataset")

subjects.unique <- unique(subjects)[,1]
subjects.len <-  length(subjects.unique)
activities.len <- length(activities[,1])
columns <- ncol(data.cleaned)

data.tidy <- data.cleaned[1:(subjects.len * activities.len), ]
row <- 1
for (s in 1:subjects.len) {
	for (a in 1:activities.len) {
	  data.tidy[row, 1] <- subjects.unique[s]
	  data.tidy[row, 2] <- activities[a, 2]
		subset <- data.cleaned[data.cleaned$subject==s & 
                        data.cleaned$activity==activities[a, 2], ]
		data.tidy[row, 3:columns] <- colMeans(subset[, 3:columns])
		row <- row+1
	}
}

write.table(data.tidy, 
            file.path(current.wd, "tidy_dataset_with_average_values.txt"), 
            row.names = FALSE)

message("tidy_dataset_with_average_values.txt file created!")
